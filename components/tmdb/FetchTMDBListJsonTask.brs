sub init()
  m.top.functionName = "getArrayContent"

  m.tmdb_api_key = m.global.appConfig.tmdb.api_key
  m.tmdb_user_id = m.global.appConfig.tmdb.user_id
end sub

sub getPage(page as Integer) as Object
  searchRequest = CreateObject("roUrlTransfer")
  if m.top.list_type <> "user" then
    searchRequest.setURL("https://api.themoviedb.org/3/account/" + m.tmdb_user_id + "/" + m.top.list_type + "/" + m.top.media_type + "?language=en-US&page=" + page.toStr())
  else
    searchRequest.setURL("https://api.themoviedb.org/3/list/" + m.top.list_id.toStr() + "?language=en-US&page=" + page.toStr())
  end if
  searchRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  searchRequest.AddHeader("accept", "application/json")
  payload = searchRequest.GetToString()
  
  return ParseJson(payload)
end sub

sub getArrayContent()
  page = 1
  response = getPage(page)
  arr = CreateObject("roArray", response.total_results, false)
  
  while true    
    if m.top.list_type = "user" then
      results = response.items
    else
      results = response.results
    end if
    
    For Each result in results
      arr.Push(result)
    end for
    
    if page < response.total_pages
      page = page + 1
    else
      exit while 
    end if
    response = getPage(page)
  end while
  
  arr.SortBy("vote_average", "r")
 
  m.top.arrayContent = arr

end sub