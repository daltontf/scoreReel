sub init()
  m.top.functionName = "getContent"

  configFile = ReadAsciiFile("pkg:/source/secrets.json")
  config = ParseJSON(configFile)

  m.tmdb_api_key = config.tmdb.api_key
  m.tmdb_user_id = config.tmdb.user_id
end sub

sub getPage(page as Integer) as Object
  searchRequest = CreateObject("roUrlTransfer")
  searchRequest.setURL("https://api.themoviedb.org/3/account/" + m.tmdb_user_id + "/" + m.top.list_type + "/" + m.top.media_type + "?language=en-US&page=" + page.toStr())
  searchRequest.AddHeader("Authorization", "Bearer " + m.tmdb_api_key)
  searchRequest.AddHeader("accept", "application/json")
  payload = searchRequest.GetToString()
  return ParseJson(payload)
end sub

sub getContent()
  data = CreateObject("roSGNode", "ContentNode")

  page = 1
  response = getPage(page)
  arr = CreateObject("roArray", response.total_results, false)
  while true    
    For Each result in response.results
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

  For Each result in arr
      dataItem = data.CreateChild("MediaListItemData")
      dataItem.id = result.id
      if m.top.media_type = "movies" then
        dataItem.media_type = "movie"
      else 
        dataItem.media_type = m.top.media_type
      end if
      if (result.title <> invalid)
        dataItem.title = result.title
      else if (result.name <> invalid)
        dataItem.title = result.name
      else
        dataItem.title = "Unknown Title"
      end if
      
      dataItem.popularity = result.popularity
      dataItem.vote_average = result.vote_average
      if (result.release_date <> invalid)
        dataItem.release_date = result.release_date
      else if (result.first_air_date <> invalid)
        dataItem.release_date = result.first_air_date
      else
      dataItem.release_date = "Unknown Release Date"
      end if
    end for
  
  m.top.content = data

end sub