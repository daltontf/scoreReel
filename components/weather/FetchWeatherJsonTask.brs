sub init()
  m.top.functionName = "getJsonContent"

  configFile = ReadAsciiFile("pkg:/source/secrets.json")
  config = ParseJSON(configFile)

  m.gridpoint_url = config.weather.gridpoint_url
end sub

sub getJsonContent()
  restRequest = CreateObject("roUrlTransfer")
  restRequest.setURL(m.gridpoint_url + "/forecast/hourly")
  restRequest.AddHeader("accept", "application/json")
  payload = restRequest.GetToString()
  
  m.top.jsonContent = ParseJson(payload)  
end sub
