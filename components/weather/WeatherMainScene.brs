function init()
    m.WeatherMarkupList = m.top.findNode("WeatherMarkupList")
    m.fetchWeatherJsonTask = CreateObject("roSGNode", "FetchWeatherJsonTask")
    m.fetchWeatherJsonTask.ObserveField("jsonContent", "setJsonContent")
    m.fetchWeatherJsonTask.control = "RUN"
    m.WeatherMarkupList.SetFocus(true)
end function

sub setJsonContent()
    contentNode = CreateObject("roSGNode", "ContentNode")

    lastDateString = ""
    
    For Each result in m.fetchWeatherJsonTask.jsonContent.properties.periods

        dataItem = contentNode.CreateChild("WeatherListItemData")

        dateTime = CreateObject("roDateTime")
        dateTime.FromISO8601String(result.startTime)

        dateString = dateTime.asDateStringLoc("EEE y-MM-dd")
        if dateString <> lastDateString
            dataItem.date = dateString
            dataItem = contentNode.CreateChild("WeatherListItemData")
            lastDateString = dateString
        else
            dataItem.date = ""
        end if

        dataItem.startTime = dateTime.asTimeStringLoc("h:mm a")
        dataItem.temperature = Str(result.temperature) + " °F"
        dataItem.probabilityOfPrecipitation = Str(result.probabilityOfPrecipitation.value) + "%"
        dataItem.windSpeed = result.windSpeed
        dataItem.windDirection = result.windDirection
        dataItem.shortForecast = result.shortForecast
    end for

    m.WeatherMarkupList.content = contentNode
end sub