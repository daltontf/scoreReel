function init() 
  m.time = m.top.findNode("time") 
  m.name = m.top.findNode("name") 
  m.away_score = m.top.findNode("away_score") 
  m.home_score = m.top.findNode("home_score") 
  m.status_detail = m.top.findNode("status_detail") 
  m.national_broadcasts = m.top.findNode("national_broadcasts") 
end function

function itemContentChanged() 
  itemData = m.top.itemContent

  m.time.text = itemData.time
  m.name.text = itemData.name
  m.away_score.text = itemData.away_score
  m.home_score.text = itemData.home_score
  m.status_detail.text = itemData.status_detail
  m.national_broadcasts.text = itemData.national_broadcasts
end function

