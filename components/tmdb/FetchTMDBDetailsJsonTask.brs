sub init()
  m.top.functionName = "getJsonContent"

  configFile = ReadAsciiFile("pkg:/source/secrets.json")
  config = ParseJSON(configFile)

  m.tmdb_api_key = config.tmdb.api_key
  m.tmdb_user_id = config.tmdb.user_id
  
end sub

sub getJsonContent()
  detailRequest = CreateObject("roUrlTransfer")
  detailRequest.setURL("https://api.themoviedb.org/3/" + m.top.media_type + "/" + m.top.id + "?language=en-US")
  detailRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  detailRequest.AddHeader("accept", "application/json")
  payload = detailRequest.GetToString()
  response = ParseJson(payload)

  providersRequest = CreateObject("roUrlTransfer")
  providersRequest.setURL("https://api.themoviedb.org/3/" + m.top.media_type  + "/" + m.top.id + "/watch/providers?language=en-US")
  providersRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  providersRequest.AddHeader("accept", "application/json")
  providersPayload = providersRequest.GetToString()
  providersResponse = ParseJson(providersPayload)  
  m.top.providerContent = providersResponse
  
  m.top.jsonContent = response ' fires change event
end sub

