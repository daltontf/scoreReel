function init()
    m.tabs = m.top.findNode("tabs")
 
    content = CreateObject("roSGNode", "ContentNode")
    tab1 = content.createChild("ContentNode")
    tab1.title = "The Movie Database (TMDB)"
    tab1.id = "tmdb"

    tab2 = content.createChild("ContentNode")
    tab2.title = "Sport Scores from ESPN"
    tab2.id = "scores"

    tab3 = content.createChild("ContentNode")
    tab3.title = "Sport Standings from ESPN"
    tab3.id = "standings"

    tab4 = content.createChild("ContentNode")
    tab4.title = "Local Weather"
    tab4.id = "weather"
    
    m.tabs.content = content
    m.tabs.observeField("itemSelected", "onTabSelected")

    m.contentGroup = m.top.findNode("contentGroup")

    m.tabs.SetFocus(true)
end function

sub onTabSelected()
    itemIndex = m.tabs.itemSelected
    item = m.tabs.content.getChild(itemIndex).id

    ' Clear previous content
    m.contentGroup.removeChildrenIndex(m.contentGroup.getChildCount(), 0)

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
