function init()
    m.WeatherMarkupList = m.top.findNode("WeatherMarkupList")
    m.fetchWeatherJsonTask = CreateObject("roSGNode", "FetchWeatherJsonTask")
    m.fetchWeatherJsonTask.ObserveField("jsonContent", "setJsonContent")
    m.fetchWeatherJsonTask.control = "RUN"
    m.WeatherMarkupList.SetFocus(true)
end function

sub setJsonContent()
    contentNode = CreateObject("roSGNode", "ContentNode")
    
    For Each result in m.fetchWeatherJsonTask.jsonContent.properties.periods

        dataItem = contentNode.CreateChild("WeatherListItemData")

        dateTime = CreateObject("roDateTime")
        dateTime.FromISO8601String(result.startTime)

        dataItem.startTime = dateTime.asDateStringLoc("EEE y-MM-dd") + " " + dateTime.asTimeStringLoc("h:mm a")
        dataItem.temperature = Str(result.temperature) + " °F"
        dataItem.probabilityOfPrecipitation = Str(result.probabilityOfPrecipitation.value) + "%"
        dataItem.windSpeed = result.windSpeed
        dataItem.windDirection = result.windDirection
        dataItem.shortForecast = result.shortForecast
    end for

    m.WeatherMarkupList.content = contentNode
end sub