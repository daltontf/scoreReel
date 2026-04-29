function init()
    m.WeatherMarkupList = m.top.findNode("WeatherMarkupList")
    m.dateHeader = m.top.findNode("dateHeader")
    m.fetchWeatherJsonTask = CreateObject("roSGNode", "FetchWeatherJsonTask")
    m.fetchWeatherJsonTask.ObserveField("jsonContent", "setJsonContent")
    m.fetchWeatherJsonTask.control = "RUN"
    m.WeatherMarkupList.SetFocus(true)

    m.WeatherMarkupList.ObserveField("itemFocused", "dateFocused")
end function

sub dateFocused() 
    focused = m.WeatherMarkupList.content.getChild(m.WeatherMarkupList.itemFocused) 
    m.dateHeader.text = focused.date
end sub

sub setJsonContent()
    m.dateHeader.text = ""

    contentNode = CreateObject("roSGNode", "ContentNode")

    lastDateString = ""
    
    For Each result in m.fetchWeatherJsonTask.jsonContent.properties.periods

        dataItem = contentNode.CreateChild("WeatherListItemData")

        dateTime = CreateObject("roDateTime")
        dateTime.FromISO8601String(result.startTime)

        dateString = dateTime.asDateStringLoc("EEE y-MM-dd")
        dataItem.date = dateString
        if dateString <> lastDateString
            dataItem.date = "" ' make header row with date blank since we are showing the date in the header label
            dataItem.startTime = dateString
            dataItem = contentNode.CreateChild("WeatherListItemData")
            dataItem.date = dateString
            lastDateString = dateString
        end if

        dataItem.startTime = dateTime.asTimeStringLoc("h:mm a")
        dataItem.temperature = Str(result.temperature) + " °F"
        dataItem.probabilityOfPrecipitation = Str(result.probabilityOfPrecipitation.value) + "%"
        dataItem.windSpeed = result.windSpeed
        dataItem.windDirection = result.windDirection
        dataItem.shortForecast = result.shortForecast
        dataItem.iconUrl = result.icon
    end for

    m.WeatherMarkupList.content = contentNode
end sub