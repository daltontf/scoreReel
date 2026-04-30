sub init()
  m.top.functionName = "getJsonContent"

  m.tmdb_api_key = m.global.appConfig.tmdb.api_key
  m.tmdb_user_id = m.global.appConfig.tmdb.user_id
  
end sub

sub getJsonContent()
  detailRequest = CreateObject("roUrlTransfer")
  detailRequest.setURL("https://api.themoviedb.org/3/account/" + m.tmdb_user_id + "/lists?language=en-US&page=1")
  detailRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  detailRequest.AddHeader("accept", "application/json")
  payload = detailRequest.GetToString()
  response = ParseJson(payload)
  m.top.jsonContent = response ' fires change event
end sub