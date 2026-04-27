function init()
    m.standingsTypeMarkupList = m.top.findNode("StandingsTypeMarkupList")
    m.standingsMarkupList = m.top.findNode("StandingsMarkupList")

    m.fetchJsonTask = CreateObject("roSGNode", "FetchEspnStandingsJsonTask")
    m.fetchJsonTask.ObserveField("jsonContent", "setStandingsContent")

    m.standingsTypeMarkupList.SetFocus(true)
end function

sub processStandings(contentNode, parentItem, jsonNode)
    needHeader = true
    for each entry in jsonNode.standings.entries
        if needHeader
            for each stat in entry.stats
                if m.fetchJsonTask.stats[stat.name] = true
                    parentItem[stat.name] = stat.shortDisplayName
                end if
            end for
            needHeader = false
        end if
        entryItem = contentNode.CreateChild("StandingsChildContent")
        entryItem.teamName = entry.team.displayName
        for each stat in entry.stats
            if m.fetchJsonTask.stats[stat.name] = true
                if stat.name = "Last Ten Games"
                    entryItem[stat.name] = stat.summary 
                else
                    entryItem[stat.name] = stat.displayValue
                end if
            end if
        end for
    end for
end sub

sub setStandingsContent()
    contentNode = CreateObject("roSGNode", "ContentNode")

    response = m.fetchJsonTask.jsonContent

    if response.children <> invalid and response.children.count() > 0
        for each child in response.children
            childItem = contentNode.CreateChild("StandingsChildContent")
            childItem.childName = child.name

            if child.children <> invalid
                for each grandChild in child.children
                    grandChildItem = contentNode.CreateChild("StandingsChildContent")
                    grandChildItem.grandChildName = grandChild.name
                    processStandings(contentNode, grandChildItem, grandChild)
                end for
            else
                processStandings(contentNode, childItem, child)
            end if
        end for
    else
        topItem = contentNode.CreateChild("StandingsChildContent")
        topItem.childName = response.name
        processStandings(contentNode, topItem, response)
    end if

    m.standingsMarkupList.content = contentNode
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
