sub init()
  m.top.functionName = "getContent"
end sub

sub getContent()
  data = CreateObject("roSGNode", "ContentNode")

  restRequest = CreateObject("roUrlTransfer")
  restRequest.setURL("https://api.weather.gov/gridpoints/LSX/85,70/forecast/hourly")
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
