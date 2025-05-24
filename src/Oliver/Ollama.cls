Class Oliver.Ollama Extends %RegisteredObject
{

ClassMethod SendChat(pPath As %String) As %String
{
  #Dim pRequest As %Net.HttpRequest = ""
  #Dim pResponse As %Net.HttpResponse = ""
  #Dim pSendSC As %Status = $$$OK
  Set pURL = "http://ollama:11434/api/chat"
  Set pAdapterServer = "ollama"
  Set pAdapterPort = 11434
  Set pUnitTest = ""
  Set pFilename = $Get(pPath)
  Set oResponseTime = ##class(Oliver.ResponseTime).NewRequest(pRequest, pURL, pAdapterServer, pAdapterPort, pUnitTest, pFilename)
  Set ^OLIVER($I(^OLIVER),"oResponseTime") = oResponseTime
  Set resp = ""
  Try {
    Set testreq = ##class(%SYS.Python).Import("testreq")
    Set resp = testreq."send_chat"(pPath)
    Set tSC = oResponseTime.zSaveResponse(resp)
    zw resp
  }
  Catch exp {
    Set ^OLIVER($I(^OLIVER),"Catch") = exp
    IF 1=exp.%IsA("%Exception.SystemException") {
      WRITE "System exception",!
      WRITE "Name: ",$ZCVT(exp.Name,"O","HTML"),!
      WRITE "Location: ",exp.Location,!
      WRITE "Code: "
    }
    ELSEIF 1=exp.%IsA("%Exception.SQL") {
      WRITE "SQL exception",!
      WRITE "SQLCODE: "
    }
    ELSEIF 1=exp.%IsA("%Exception.StatusException") {
      WRITE "%Status exception",!
      DO $SYSTEM.Status.DisplayError(exp.AsStatus())
    }
    ELSEIF 1=exp.%IsA("%Exception.General") {
      WRITE "General ObjectScript exception",!
      WRITE "Name: ",$ZCVT(exp.Name,"O","HTML"),!
      WRITE "Code: "
    }
    ELSEIF 1=exp.%IsA("%Exception.PythonException") {
      Set ^OLIVER($I(^OLIVER),"PythonException") = exp.AsSystemError()
    }
    ELSE { WRITE "Some other type of exception",! }
    WRITE exp.Code,!
    WRITE "Data: ",exp.Data,!     
  }
  Return resp
}

}
