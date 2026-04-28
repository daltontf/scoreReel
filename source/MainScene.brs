function init() 
    configFile = ReadAsciiFile("pkg:/source/secrets.json")
    m.global.addFields({ appConfig: ParseJSON(configFile)})

    m.contentGroup = m.top.findNode("contentGroup")

    m.tabs = m.top.findNode("tabs")

    content = CreateObject("roSGNode", "ContentNode")

    if m.global.appConfig <> invalid and m.global.appConfig.tmdb <> invalid then
        tab1 = content.createChild("ContentNode")
        tab1.title = "The Movie Database (TMDB)"
        tab1.id = "tmdb"
    end if

    tab2 = content.createChild("ContentNode")
    tab2.title = "Sport Scores from ESPN"
    tab2.id = "scores"

    tab3 = content.createChild("ContentNode")
    tab3.title = "Sport Standings from ESPN"
    tab3.id = "standings"

    if m.global.appConfig <> invalid and m.global.appConfig.weather <> invalid then
        tab4 = content.createChild("ContentNode")
        tab4.title = "Local Weather"
        tab4.id = "weather"
    end if
    
    m.tabs.content = content
    m.tabs.observeField("itemSelected", "onTabSelected")
    m.tabs.SetFocus(true)
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
  if press and key = "back" then
       count = m.contentGroup.getChildCount()
        if count > 1
            lastChild = m.contentGroup.getChild(count - 1)
            m.contentGroup.removeChild(lastChild)
        else
            return false ' exit app if on main menu
        end if  
        m.tabs.visible = true
        m.tabs.SetFocus(true)
        return true   
    end if
end function

sub onTabSelected()
    itemIndex = m.tabs.itemSelected
    item = m.tabs.content.getChild(itemIndex).id

    ' Clear previous content
    m.tabs.visible = false

    if item = "tmdb" then
        node = CreateObject("roSGNode", "TMDBMainScene")
    else if item = "scores" then
        node = CreateObject("roSGNode", "ScoreScene")
    else if item = "standings" then
        node = CreateObject("roSGNode", "StandingsScene")    
    else if item = "weather" then
        node = CreateObject("roSGNode", "WeatherMainScene")
    end if

    m.contentGroup.appendChild(node)
end sub
