sub init()
  m.top.functionName = "getContent"
end sub

sub getContent()
  date = CreateObject("roDateTime")
  date.FromSeconds(date.AsSeconds() - (date.GetTimeZoneOffset() * 60) + (m.top.date_offset * 86400))

  queryDate = date.asDateStringLoc("yMMdd")

  searchRequest = CreateObject("roUrlTransfer")

  if m.top.query <> invalid and m.top.query <> ""
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

  m.top.jsonContent = response
end sub