function itemContentChanged() 
   itemData = m.top.itemContent
   m.startTime.text = itemData.startTime
   m.temperature.text = itemData.temperature
   m.probabilityOfPrecipitation.text = itemData.probabilityOfPrecipitation
   m.windSpeed.text = itemData.windSpeed
   m.windDirection.text = itemData.windDirection   
   m.shortForecast.text = itemData.shortForecast
   m.icon.uri = itemData.iconUrl
 end function
  
 function init() 
   m.startTime = m.top.findNode("startTime") 
   m.temperature = m.top.findNode("temperature")  
   m.probabilityOfPrecipitation = m.top.findNode("probabilityOfPrecipitation")
   m.windSpeed = m.top.findNode("windSpeed")
   m.windDirection = m.top.findNode("windDirection")
   m.shortForecast = m.top.findNode("shortForecast")
   m.icon = m.top.findNode("icon")
 end function
