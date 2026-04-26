function init()
    m.WeatherMarkupList = m.top.findNode("WeatherMarkupList")
    m.fetchWeatherJsonTask = CreateObject("roSGNode", "FetchWeatherJsonTask")
    m.fetchWeatherJsonTask.ObserveField("content", "setListContent")
    m.fetchWeatherJsonTask.control = "RUN"
    m.WeatherMarkupList.SetFocus(true)
end function

sub setListContent()
    m.WeatherMarkupList.content = m.fetchWeatherJsonTask.content
end sub