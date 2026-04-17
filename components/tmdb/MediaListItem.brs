function itemContentChanged() 
   itemData = m.top.itemContent
   m.title.text = itemData.title
   m.popularity.text = itemData.popularity
   m.vote_average.text = itemData.vote_average
   m.release_date.text = itemData.release_date
 end function
  
 function init() 
   m.title = m.top.findNode("title") 
   m.popularity = m.top.findNode("popularity")  
   m.vote_average = m.top.findNode("vote_average")
   m.release_date = m.top.findNode("release_date")
 end function
