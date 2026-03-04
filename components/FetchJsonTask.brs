sub init()
    m.top.functionName = "getContent"
end sub

sub getContent()
  data = CreateObject("roSGNode", "ContentNode")

  date = CreateObject("roDateTime")

  date.FromSeconds(date.AsSeconds() - (date.GetTimeZoneOffset() * 60) + (m.top.date_offset * 86400))

  queryDate = date.asDateStringLoc("yMMdd")
  
  event_date = CreateObject("roDateTime")

  searchRequest = CreateObject("roUrlTransfer")

  if m.top.query <> invalid
    query = "?" + m.top.query + "&dates=" + queryDate
  else 
    query = "?dates=" + queryDate  
  end if

  if m.top.date_offset = 0
    query = query + "&secs=" + date.AsSeconds().ToStr().Trim() 'discourage caching
  end if  

  searchRequest.setURL(m.top.contenturi + query)
  payload = searchRequest.GetToString()
  response = ParseJson(payload)
  
  response.events.SortBy("date")

  For Each event in response.events
      dataItem = data.CreateChild("ScoreListItemData")
      dataItem.name = event.name
      
      event_date.FromISO8601String(event.date)
      event_date.FromSeconds(event_date.AsSeconds() - (event_date.GetTimeZoneOffset() * 60))

      dataItem.time = event_date.asDateStringLoc("MM/dd/yy ") + event_date.asTimeStringLoc("h:mm a")

      competition = event.competitions[0]
      
      if competition.competitors[0].homeAway = "home" then
           dataItem.home_score = competition.competitors[0].score
           dataItem.away_score = competition.competitors[1].score
      else
           dataItem.home_score = competition.competitors[1].score
           dataItem.away_score = competition.competitors[0].score
      end if
      if competition.status.type.name <> "STATUS_SCHEDULED"
        dataItem.status_detail = competition.status.type.shortDetail
      end if

      broadcasts = event.broadcasts

  End For

  if data.getChildCount() = 0   
    dataItem = data.CreateChild("ScoreListItemData")
    dataItem.time = date.asDateStringLoc("MM/dd/yy")
    dataItem.name = "No Competitions"
    end if

  m.top.content = data
    
end sub