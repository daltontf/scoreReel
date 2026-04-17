sub init()
  m.top.functionName = "getContent"

  configFile = ReadAsciiFile("pkg:/source/secrets.json")
  config = ParseJSON(configFile)

  m.tmdb_api_key = config.tmdb_api_key
  m.tmdb_user_id = config.tmdb_user_id
  
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
      m.top.content = (response.name + Chr(10) + Chr(10) + response.overview + Chr(10) + Chr(10) + "Seasons: " + response.number_of_seasons.toStr() + Chr(10) + "Episodes: " + response.number_of_episodes.toStr() + Chr(10) + "First Air Date: " + response.first_air_date + Chr(10) + "Last Air Date: " + response.last_air_date)
    else
      m.top.content = "Unknown Media Type"
    end if
end sub