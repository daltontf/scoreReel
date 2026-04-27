sub init()
    m.top.functionName = "getContent"
end sub

sub processStandings(contentNode, parentItem, jsonNode)
    needHeader = true
    for each entry in jsonNode.standings.entries
        if needHeader
            for each stat in entry.stats
                if m.top.stats[stat.name] = true
                    parentItem[stat.name] = stat.shortDisplayName
                end if
            end for
            needHeader = false
        end if
        entryItem = contentNode.CreateChild("StandingsChildContent")
        entryItem.teamName = entry.team.displayName
        for each stat in entry.stats
            if m.top.stats[stat.name] = true
                if stat.name = "Last Ten Games"
                    entryItem[stat.name] = stat.summary 
                else
                    entryItem[stat.name] = stat.displayValue
                end if
            end if
        end for
    end for
end sub

sub getContent()
    contentNode = CreateObject("roSGNode", "ContentNode")

    restRequest = CreateObject("roUrlTransfer")

    restRequest.setURL(m.top.url)
    restRequest.AddHeader("accept", "application/json")

    payload = restRequest.GetToString()
    response = ParseJson(payload)

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

    m.top.content = contentNode
end sub