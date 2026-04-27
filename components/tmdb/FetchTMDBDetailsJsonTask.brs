sub init()
  m.top.functionName = "getContent"

  configFile = ReadAsciiFile("pkg:/source/secrets.json")
  config = ParseJSON(configFile)

  m.tmdb_api_key = config.tmdb.api_key
  m.tmdb_user_id = config.tmdb.user_id
  
end sub

sub getContent()
  detailRequest = CreateObject("roUrlTransfer")
  detailRequest.setURL("https://api.themoviedb.org/3/" + m.top.media_type + "/" + m.top.id + "?language=en-US")
  detailRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  detailRequest.AddHeader("accept", "application/json")
  payload = detailRequest.GetToString()
  response = ParseJson(payload)  
   
   if m.top.media_type = "movie" then
      m.top.content = (response.title + Chr(10) + Chr(10) + response.overview + Chr(10) + Chr(10) + "Runtime: " + response.runtime.toStr() + " minutes")
    else if m.top.media_type = "tv" then
      m.top.content = (response.name + Chr(10) + Chr(10) + response.overview + Chr(10) + Chr(10) + "Seasons: " + response.number_of_seasons.toStr() + Chr(10) + "Episodes: " + response.number_of_episodes.toStr() + Chr(10) + "First Air Date: " + response.first_air_date)
      if response.last_air_date <> invalid then
        m.top.content = m.top.content + Chr(10) + "Last Air Date: " + response.last_air_date
      end if  
    else
      m.top.content = "Unknown Media Type"
    end if

  detailRequest = CreateObject("roUrlTransfer")
  detailRequest.setURL("https://api.themoviedb.org/3/" + m.top.media_type + "/" + m.top.id + "/watch/providers?language=en-US")
  detailRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  detailRequest.AddHeader("accept", "application/json")
  payload = detailRequest.GetToString()
  response = ParseJson(payload)  

  appendProviderType(response, "Free: ", "free")
  appendProviderType(response, "Free with ads: ", "ads")
  appendProviderType(response, "Premium: ", "flatrate")
end sub

sub appendProviderType(response, prefix as String, providerType as String)
  m.top.content = m.top.content + Chr(10) + prefix

  if response.results.count() = 0 or response.results.US[providerType] = invalid then
    m.top.content = m.top.content + "None"
    return
  end if

  for each provider in response.results.US[providerType]
    m.top.content = m.top.content + provider.provider_name + ", "
  end for
  ' Remove the trailing comma and space
  m.top.content = left(m.top.content, len(m.top.content) - 2)
end sub