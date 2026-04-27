sub init()
    m.top.functionName = "getJsonContent"
end sub

sub getJsonContent()
    restRequest = CreateObject("roUrlTransfer")
    restRequest.setURL(m.top.url)
    restRequest.AddHeader("accept", "application/json")
    payload = restRequest.GetToString()
    
    m.top.jsonContent = ParseJson(payload)
end sub