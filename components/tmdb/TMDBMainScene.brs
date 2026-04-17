function init()
    m.listMarkupList = m.top.findNode("ListMarkupList")
    m.mediaMarkupList = m.top.findNode("MediaMarkupList")
    m.details = m.top.findNode("details")

    m.fetchTMDBListJsonTask = CreateObject("roSGNode", "FetchTMDBListJsonTask")
    m.fetchTMDBListJsonTask.ObserveField("content", "setListContent")

    m.fetchTMDBDetailsJsonTask = CreateObject("roSGNode", "FetchTMDBDetailsJsonTask")
    m.fetchTMDBDetailsJsonTask.ObserveField("content", "setDetailContent")

    m.listMarkupList.observeField("itemSelected", "listItemSelected")
    m.mediaMarkupList.observeField("itemSelected", "onMediaItemSelected")

    m.listMarkupList.SetFocus(true)
end function

sub setListContent()
    m.mediaMarkupList.content = m.fetchTMDBListJsonTask.content
end sub

sub setDetailContent()
    m.details.text = m.fetchTMDBDetailsJsonTask.content
    m.details.SetFocus(true)
end sub

sub listItemSelected()
  m.details.text = ""
  focused = m.listMarkupList.content.getChild(m.listMarkupList.itemFocused)  
  m.FetchTMDBListJsonTask.list_type = focused.list_type
  m.FetchTMDBListJsonTask.media_type = focused.media_type
  m.FetchTMDBListJsonTask.control = "RUN"
  m.mediaMarkupList.SetFocus(true)

end sub

sub onMediaItemSelected()
  m.details.text = ""
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
        m.details.SetFocus(true)
      else if m.details.hasFocus()
        m.mediaMarkupList.SetFocus(true)  
      end if
      return true
    end if
    if key = "left" then
      if m.mediaMarkupList.hasFocus() then
        m.details.SetFocus(true)
      else if m.details.hasFocus()
        m.listMarkupList.SetFocus(true) 
      end if
      return true
    end if
  end if
  return false
end function
