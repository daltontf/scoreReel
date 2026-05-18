function init()
    m.sportMarkupList = m.top.findNode("SportMarkupList")
    m.leagueMarkupList = m.top.findNode("LeagueMarkupList")
    m.scoreMarkupList = m.top.findNode("ScoreMarkupList")

    m.fetchJsonTask = CreateObject("roSGNode", "FetchEspnJsonTask")
    m.fetchJsonTask.ObserveField("jsonContent", "setScoreContent")
    m.fetchJsonTask.date_offset = 0  

    m.sportMarkupList.ObserveField("itemFocused", "sportFocused")
    m.sportMarkupList.SetFocus(true)
end function

sub sportFocused() 
    focused = m.sportMarkupList.content.getChild(m.sportMarkupList.itemFocused) 
    leagues = CreateObject("roSGNode", focused.name + " Leagues")
    m.leagueMarkupList.content = leagues
end sub

sub setScoreContent()
  contentNode = CreateObject("roSGNode", "ContentNode")

  event_date = CreateObject("roDateTime")
  For Each event in m.fetchJsonTask.jsonContent.events
    if event.Count() = 0 then
      continue for
    end if
    dataItem = contentNode.CreateChild("ScoreListItemData")
    dataItem.name = event.name

    event_date.FromISO8601String(event.date)
    event_date.FromSeconds(event_date.AsSeconds() - (event_date.GetTimeZoneOffset() * 60))

    dataItem.time = event_date.asDateStringLoc("EEE MM/dd/yy ") + event_date.asTimeStringLoc("h:mm a")

    competition = event.competitions[0]

    if competition.competitors[0].homeAway = "home" then
      dataItem.home_score = competition.competitors[0].score
      dataItem.away_score = competition.competitors[1].score
    else
      dataItem.home_score = competition.competitors[1].score
      dataItem.away_score = competition.competitors[0].score
    end if
    if competition.status.type.name <> "STATUS_SCHEDULED"
      dataItem.status_detail = competition.status.type.shortDetail
    end if

    if competition.broadcasts <> invalid and competition.broadcasts.Count() > 0 then
      if competition.broadcasts[0].market = "national" then
        dataItem.national_broadcasts = competition.broadcasts[0].names[0]
      end if
    end if
  end for

  if contentNode.getChildCount() = 0
    dataItem = contentNode.CreateChild("ScoreListItemData")
    date = CreateObject("roDateTime")
    date.FromSeconds(date.AsSeconds() - (date.GetTimeZoneOffset() * 60) + (m.fetchJsonTask.date_offset * 86400))
    dataItem.time = date.asDateStringLoc("EEE MM/dd/yy")
    dataItem.name = "No Competitions"
  end if

    m.scoreMarkupList.content = contentNode
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  if press then
    if m.sportMarkupList.hasFocus() 
      if key = "right" or key = "OK"
        m.leagueMarkupList.SetFocus(true)
        return true
      end if
    end if
    if m.leagueMarkupList.hasFocus() 
      if key = "OK"
        focused = m.leagueMarkupList.content.getChild(m.leagueMarkupList.itemFocused)  
        m.fetchJsonTask.contenturi = focused.url
        m.fetchJsonTask.date_offset = 0
        m.fetchJsonTask.control = "RUN"
        m.scoreMarkupList.SetFocus(true)
      elseif key = "left" or key = "back"
        m.sportMarkupList.SetFocus(true)
        return true
      end if
    end if    
    if m.scoreMarkupList.hasFocus() 
      if key = "right"
        m.fetchJsonTask.date_offset = m.fetchJsonTask.date_offset + 1
        m.fetchJsonTask.control = "RUN"
      elseif key = "left"
        m.fetchJsonTask.date_offset = m.fetchJsonTask.date_offset - 1
        m.fetchJsonTask.control = "RUN"
      elseif key = "back"
        m.leagueMarkupList.SetFocus(true)  
      end if  
      return true
    end if
  end if
  return false
end function