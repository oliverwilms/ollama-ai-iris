Class Oliver.Ollama Extends %RegisteredObject
{

ClassMethod SendChat(pPath As %String, pServer As %String = "ollama", pPort = 11434, pWebApp = "/api/chat") As %String
{
  #Dim pRequest As %Net.HttpRequest = ""
  #Dim pResponse As %Net.HttpResponse = ""
  #Dim pSendSC As %Status = $$$OK
  Set pURL = "http://"_pServer_":"_pPort_pWebApp
  Set pAdapterServer = pServer
  Set pAdapterPort = pPort
  Set pUnitTest = ""
  Set pFilename = $Get(pPath)
  Set oResponseTime = ##class(Oliver.ResponseTime).NewRequest(pRequest, pURL, pAdapterServer, pAdapterPort, pUnitTest, pFilename)
  Set ^OLIVER($I(^OLIVER),"oResponseTime") = oResponseTime
  Set resp = ""
  Try {
    Set testreq = ##class(%SYS.Python).Import("testreq")
    Set resp = testreq."send_chat"(pPath, pURL)
    Set tSC = oResponseTime.zSaveResponse(resp)
    Set resp = ..DecodeTokenArray(resp)
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
ClassMethod SendChatIris(pPath As %String = "", pServer As %String = "localhost", pPort = 52773, pWebApp = "/api/test/EnsLib.REST.GenericService") As %String
{
  Quit ..SendChat(pPath, pServer, pPort, pWebApp)
}

ClassMethod TestResponse(pId As %String = 1) As %String
{
  Set oResponseTime = ##class(Oliver.ResponseTime).%OpenId(pId)
  Set resp = ""
  Try {
    Set tResponse = oResponseTime.yResponse
    Set resp = ..DecodeTokenArray(tResponse)
    If ("" '= oResponseTime.zPatient) {
      Set zPatient = ..DecodeTokenArray(oResponseTime.zPatient)
      Set zPatient = oResponseTime.zPatient
      //zw zPatient
      Set resp = zPatient
    }
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

ClassMethod DecodeTokenArray(pTokenArray As %String = "") As %String
{
  Set delim = ", "
  If ($Extract(pTokenArray,1,1) = "["),($Extract(pTokenArray,*,*) = "]") Set pTokenArray = $Extract(pTokenArray,2,*-1)
  Set len = $Length(pTokenArray, delim)
  Set resp = ""
  If (pTokenArray = "") { Quit resp }
  For ii = 1:1:len {
    Set token = $Piece(pTokenArray, delim, ii)
    Set quote = $Extract(token,1,1)
    Set qlen = $Length(token, quote)
    If (qlen = 3) {
      Set resp = resp_$Piece(token,quote,2)
      Continue
    }
    zw qlen
    zw token
    Quit
  }
  Return resp
}
}
