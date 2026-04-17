function init()
    m.sportMarkupList = m.top.findNode("SportMarkupList")
    m.leagueMarkupList = m.top.findNode("LeagueMarkupList")
    m.scoreMarkupList = m.top.findNode("ScoreMarkupList")

    m.fetchJsonTask = CreateObject("roSGNode", "FetchEspnJsonTask")
    m.fetchJsonTask.ObserveField("content", "setScoreContent")
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
    m.scoreMarkupList.content = m.fetchJsonTask.content
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