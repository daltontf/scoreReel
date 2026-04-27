function init()
    m.listMarkupList = m.top.findNode("ListMarkupList")
    m.mediaMarkupList = m.top.findNode("MediaMarkupList")

    m.fetchTMDBListJsonTask = CreateObject("roSGNode", "FetchTMDBListJsonTask")
    m.fetchTMDBListJsonTask.ObserveField("arrayContent", "setListContent")

    m.fetchTMDBDetailsJsonTask = CreateObject("roSGNode", "FetchTMDBDetailsJsonTask")
    m.fetchTMDBDetailsJsonTask.ObserveField("jsonContent", "setDetailContent")

    m.listMarkupList.observeField("itemSelected", "listItemSelected")
    m.mediaMarkupList.observeField("itemSelected", "onMediaItemSelected")

    m.listMarkupList.SetFocus(true)
end function

sub setListContent()
    contentNode = CreateObject("roSGNode", "ContentNode")

    media_type = m.FetchTMDBListJsonTask.media_type

     For Each result in m.FetchTMDBListJsonTask.arrayContent
      dataItem = contentNode.CreateChild("MediaListItemData")
      dataItem.id = result.id
      if media_type = "movies" then
        dataItem.media_type = "movie"
      else 
        dataItem.media_type = media_type
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

    m.mediaMarkupList.content = contentNode
end sub

function appendProviderType(response, prefix as String, providerType as String)
  content = Chr(10) + prefix

  if response.results.count() = 0 or response.results.US[providerType] = invalid then
    content = content + "None"
    return content
  end if

  for each provider in response.results.US[providerType]
    content = content + provider.provider_name + ", "
  end for
  ' Remove the trailing comma and space
  content = left(content, len(content) - 2)
  return content
end function

sub resetScrollText()
  m.details = m.top.findNode("details")
  if m.details <> invalid
    m.top.removeChild(m.details)
  end if
  
  m.details = createObject("roSGNode", "ScrollableText")
  m.details.font = "font:SmallestSystemFont"
  m.details.id = "details"
  m.details.translation = [380, 40]
  m.details.font = "font:SmallSystemFont"
  m.details.visible = true
  m.details.width = 840
  m.details.height = 200
  m.top.appendChild(m.details)
end sub

sub setDetailContent()
  media_type = m.fetchTMDBDetailsJsonTask.media_type
  response = m.fetchTMDBDetailsJsonTask.jsonContent

  if media_type = "movie" then
      detailText = (response.title + Chr(10) + Chr(10) + response.overview + Chr(10) + Chr(10) + "Runtime: " + response.runtime.toStr() + " minutes")
    else if media_type = "tv" then
      detailText = (response.name + Chr(10) + Chr(10) + response.overview + Chr(10) + Chr(10) + "Seasons: " + response.number_of_seasons.toStr() + Chr(10) + "Episodes: " + response.number_of_episodes.toStr() + Chr(10) + "First Air Date: " + response.first_air_date)
      if response.last_air_date <> invalid then
        detailText = detailText + Chr(10) + "Last Air Date: " + response.last_air_date
      end if  
    else
      detailText = "Unknown Media Type"
    end if

  providersResponse = m.fetchTMDBDetailsJsonTask.providerContent

  detailText = detailText + appendProviderType(providersResponse, "Free: ", "free")
  detailText = detailText + appendProviderType(providersResponse, "Free with ads: ", "ads")
  detailText = detailText + appendProviderType(providersResponse, "Premium: ", "flatrate")

  resetScrollText()

  m.details.SetFocus(true)
  m.details.text = invalid
  m.details.text = detailText
end sub

sub listItemSelected()
  if m.details <> invalid
    m.details.text = ""
  end if
  focused = m.listMarkupList.content.getChild(m.listMarkupList.itemFocused)  
  m.FetchTMDBListJsonTask.list_type = focused.list_type
  m.FetchTMDBListJsonTask.media_type = focused.media_type
  m.FetchTMDBListJsonTask.control = "RUN"
  m.mediaMarkupList.SetFocus(true)

end sub

sub onMediaItemSelected()
  if m.details <> invalid
    m.details.text = ""
  end if
  focused = m.mediaMarkupList.content.getChild(m.mediaMarkupList.itemFocused) 
  m.fetchTMDBDetailsJsonTask.media_type = focused.media_type
  m.fetchTMDBDetailsJsonTask.id = focused.id
  m.fetchTMDBDetailsJsonTask.control = "RUN"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  if press then
    if key = "back" and not(m.listMarkupList.hasFocus()) then
      m.listMarkupList.SetFocus(true)  
      return true
    end if
    if key = "right" then
      if m.listMarkupList.hasFocus() then
        if m.details <> invalid and m.details.text <> "" then
           m.details.SetFocus(true)  
        else if m.mediaMarkupList.content <> invalid and m.mediaMarkupList.content.getChildCount() > 0 then
           m.mediaMarkupList.SetFocus(true)  
        end if
      else if m.details.hasFocus()
        m.mediaMarkupList.SetFocus(true)  
      end if
      return true
    end if
    if key = "left" then
      if m.mediaMarkupList.hasFocus() then
        if m.details <> invalid and m.details.text <> "" then
           m.details.SetFocus(true)  
        else
           m.listMarkupList.SetFocus(true)  
        end if
      else if m.details.hasFocus()
        m.listMarkupList.SetFocus(true) 
      end if
      return true
    end if
  end if
  return false
end function
