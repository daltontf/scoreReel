function itemContentChanged() 
    itemData = m.top.itemContent
    m.name.text = itemData.name
 end function
  
 function init() 
    m.name = m.top.findNode("name") 
 end function

