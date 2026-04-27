sub init()
  m.top.functionName = "getContent"

  configFile = ReadAsciiFile("pkg:/source/secrets.json")
  config = ParseJSON(configFile)

  m.gridpoint_url = config.weather.gridpoint_url
end sub

sub getContent()
  data = CreateObject("roSGNode", "ContentNode")

  restRequest = CreateObject("roUrlTransfer")
  restRequest.setURL(m.gridpoint_url + "/forecast/hourly")
  restRequest.AddHeader("accept", "application/json")
  payload = restRequest.GetToString()
  
  response = ParseJson(payload)

  For Each result in response.properties.periods
    dataItem = data.CreateChild("WeatherListItemData")

    dateTime = CreateObject("roDateTime")
    dateTime.FromISO8601String(result.startTime)

    dataItem.startTime = dateTime.asDateStringLoc("EEE y-MM-dd") + " " + dateTime.asTimeStringLoc("h:mm a")
    dataItem.temperature = Str(result.temperature) + " °F"
    dataItem.probabilityOfPrecipitation = Str(result.probabilityOfPrecipitation.value) + "%"
    dataItem.windSpeed = result.windSpeed
    dataItem.windDirection = result.windDirection
    dataItem.shortForecast = result.shortForecast
  end for

   m.top.content = data
end sub
