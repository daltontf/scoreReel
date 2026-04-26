function init()
    m.standingsTypeMarkupList = m.top.findNode("StandingsTypeMarkupList")
    m.standingsMarkupList = m.top.findNode("StandingsMarkupList")

    m.fetchJsonTask = CreateObject("roSGNode", "FetchEspnStandingsJsonTask")
    m.fetchJsonTask.ObserveField("content", "setStandingsContent")

    m.standingsTypeMarkupList.SetFocus(true)
end function

sub setStandingsContent()
    m.standingsMarkupList.content = m.fetchJsonTask.content
end sub

function statsToLookup(input as string) as Object
    result = {}
    for each s in input.split(",")
        result[s.trim()] = true
    end for
    return result
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
  if press then
    if m.standingsTypeMarkupList.hasFocus() 
      if key = "OK"
        focusedItem = m.standingsTypeMarkupList.itemFocused
        m.fetchJsonTask.url = m.standingsTypeMarkupList.content.getChild(focusedItem).url
        m.fetchJsonTask.stats = statsToLookup(m.standingsTypeMarkupList.content.getChild(focusedItem).stats)
        m.fetchJsonTask.control = "RUN"
        m.standingsMarkupList.SetFocus(true)
        return true
      end if
    elseif key = "left" or key = "back"
        m.standingsTypeMarkupList.SetFocus(true)
        return true
    end if
  end if
  return false
end function
