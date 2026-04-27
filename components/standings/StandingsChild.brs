function itemContentChanged() 
    itemData = m.top.itemContent
    m.childName.text = itemData.childName
    m.grandChildName.text = itemData.grandChildName
    m.teamName.text = itemData.teamName
    m.wins.text = itemData.wins
    m.losses.text = itemData.losses
    m.winPercent.text = itemData.winPercent
    m.gamesBehind.text = itemData.gamesBehind
    m.ties.text = itemData.ties
    m.gamesPlayed.text = itemData.gamesPlayed
    m.pointDifferential.text = itemData.pointDifferential
    m.points.text = itemData.points
    m.otLosses.text = itemData.otLosses
    m["Last Ten Games"].text = itemData["Last Ten Games"]
 end function
  
 function init() 
    m.childName = m.top.findNode("childName") 
    m.grandChildName = m.top.findNode("grandChildName") 
    m.teamName = m.top.findNode("teamName")
    m.wins = m.top.findNode("wins")
    m.losses = m.top.findNode("losses")
    m.winPercent = m.top.findNode("winPercent")
    m.gamesBehind = m.top.findNode("gamesBehind")
    m.ties = m.top.findNode("ties")
    m.gamesPlayed = m.top.findNode("gamesPlayed")
    m.pointDifferential = m.top.findNode("pointDifferential")
    m.points = m.top.findNode("points")
    m.otLosses = m.top.findNode("otLosses")
    m["Last Ten Games"] = m.top.findNode("Last Ten Games")
 end function