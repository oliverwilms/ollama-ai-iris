Class Oliver.ResponseTime Extends %Persistent
{

Property RequestTimestamp As %String;

Property ResponseTimestamp As %String;

Property ResponseZCalc As %Integer [ Calculated, SqlComputeCode = {set {*}=##class(Oliver.SQL).GetDateTimeDiff({RequestTimestamp},{ResponseTimestamp})}, SqlComputed ];

/// Server to connect to (optional). If not specified, it defaults to 'localhost'.
Property Server As %String(MAXLEN = 255);

/// Port for connection.
Property Port As %String(MAXLEN = 6);

/// URL to connect to (optional).
Property URL As %String(MAXLEN = 255);

Property SendSC As %Status;

Property ResponseFilename As %String(MAXLEN = 255);

/// The HTTP status code. This is useful to determine if the request was
/// successful. Look in the rfc for HTTP to see which codes are supported
/// and what they mean. A human readable form of this code is stored as
/// the <PROPERTY>ReasonPhrase</PROPERTY>
Property StatusCode As %Integer;

/// This is the human readable reason that goes with the <PROPERTY>StatusCode</PROPERTY>.
Property ReasonPhrase As %String;

/// The HTTP status line. This is the first line of the response and signals
/// if the request was successful or if there was a problem.
Property StatusLine As %String;

/// Strict-Transport-Security Response Header
Property HSTS As %String(MAXLEN = 255);

Property Filename As %String(MAXLEN = 255);

Property ContentLength As %String;

Property myUnitTest As %String;

Property Status As %Status;

Property whichTest As %String;

Property xDynatrace As %String(MAXLEN = 1255);

Property xDynatraceApplication As %String(MAXLEN = 1255);

Property xDynatraceRequestState As %String(MAXLEN = 1255);

Property xWebgateway As %String(MAXLEN = 1255);

Property yResponse As %String(MAXLEN = "");

Property zAssessment As %String(MAXLEN = "");

Property zCC As %String(MAXLEN = "");

Property zDate As %String(MAXLEN = "");

Property zPatient As %String(MAXLEN = "");

Property zProvider As %String(MAXLEN = "");

Property zTitle As %String(MAXLEN = "");

ClassMethod NewRequest(pRequest As %Net.HttpRequest, pURL As %String, pAdapterServer As %String, pAdapterPort As %String, pUnitTest As %String, pFilename As %String) As Oliver.ResponseTime
{
	//Set tPort = $Select($Get(pAdapterPort)'="":pAdapterPort,1:pRequest.Port)
	Set tPort = $Get(pAdapterPort)
	Set oResponseTime = ..%New()
	Set oResponseTime.RequestTimestamp = $ZDateTime($NOW(),3,1,3)
	If ($Get(pUnitTest) = "") Set pUnitTest = $Get(^myUnitTests)
	Set oResponseTime.myUnitTest = pUnitTest
	Set oResponseTime.ContentLength = ""  // pRequest.ContentLength
	Set oResponseTime.Filename = $Get(pFilename)
	Set oResponseTime.Port = tPort
	Set oResponseTime.URL = $Get(pURL)
	Set oResponseTime.whichTest = $Get(^myUnitTestControl("whichTest"))
	Quit oResponseTime
}

Method SaveResponse(pResponse As %Net.HttpResponse, pSendSC As %Status = "") As %Status
{
	Set ..ResponseTimestamp = $ZDateTime($NOW(),3,1,3)
	If $IsObject(pResponse) {
		Set ..StatusCode = pResponse.StatusCode
		Set ..ReasonPhrase = pResponse.ReasonPhrase
		Set ..StatusLine = pResponse.StatusLine
		Set ..HSTS = pResponse.GetHeader("Strict-Transport-Security")
		Set tResponseFilename = pResponse.GetHeader("URL")
		If (tResponseFilename [ "=") Set tResponseFilename = $Piece(tResponseFilename,"=",2,*)
		Set ..ResponseFilename = tResponseFilename
		Set ..xDynatrace = pResponse.GetHeader("X-DYNATRACE")
		Set ..xDynatraceApplication = pResponse.GetHeader("X-DYNATRACE-APPLICATION")
		Set ..xDynatraceRequestState = pResponse.GetHeader("X-DYNATRACE-REQUESTSTATE")
		Set ..xWebgateway = pResponse.GetHeader("X-RUXIT-APACHE-SERVERNAMEPORTS")
	} Else {
		Set ..yResponse = $Get(pResponse)
	}
	Try {
		Set tSendSC = $SYSTEM.Status.GetOneStatusText(pSendSC)
	} Catch {
		Set tSendSC = pSendSC
	}
	Set ..SendSC = tSendSC
	Set tSC = ..%Save()
	Quit tSC
}

Method SaveStatus(pStatus As %Status) As %Status
{
	Set ..ResponseTimestamp = $ZDateTime($NOW(),3,1,3)
	Set ..Status = pStatus
	Set tSC = ..%Save()
	Quit tSC
}

ClassMethod test() As %Status
{
    Set oResponseTime = ..%OpenId(4)
    Set resp = oResponseTime.yResponse
    If ($Extract(resp,1,1) = "[") Set resp = $Extract(resp,2,*)
    If ($Extract(resp,*,*) = "]") Set resp = $Extract(resp,1,*-1)
    Set myAssessment = ""
    Set myCC = ""
    Set myDate = ""
    Set myPatient = ""
    Set myProvider = ""
    Set myTitle = ""
    Set sep = ", "
    Set tFlag = 0
    Set tFlagAssessment = 1
    Set tFlagCC = 3
    Set tFlagDate = 4
    Set tFlagPatient = 5
    Set tFlagProvider = 6
    Set tFlagTitle = 8
    Set tokenDate = "'Date'"
    Set tokenPatient = "'Patient'"
    Set tokenProvider = "'Provider'"
    Set tokenTitle = "'Title'"
    Set len = $Length(resp,sep)
    For ii = 1:1:len {
        Set token = $Piece(resp,sep,ii)
        If (token = "") { Continue }
        //Set token(token,ii) = token
        Set token(ii) = token
        If (token = "'essment'"),(token(ii-1) = "'Ass'"),(myAssessment = "") { Set tFlag = tFlagAssessment Continue }
        If (token = "' Complaint'"),(token(ii-1) = "'Chief'"),(myCC = "") { Set tFlag = tFlagCC Continue }
        If (token = tokenDate),(myDate = "") { Set tFlag = tFlagDate Continue }
        If (token = tokenPatient),(myPatient = "") { Set tFlag = tFlagPatient Continue }
        If (token = tokenProvider),(myProvider = "") { Set tFlag = tFlagProvider Continue }
        If (token = tokenTitle),(myTitle = "") { Set tFlag = tFlagTitle Continue }
        If (token = "'"":'") { Continue }
        If (token = "' ""'") { Continue }
        If (token = "'"",\n'") { Set tFlag = 0 }
        If (token = "' """",\n'") { Set tFlag = 0 }
        If (token = "'.""\n'") { Set tFlag = 0 }
        If ($Extract(token,1,2) = "'""") { Set tFlag = 0 }
        If ($Extract(token,1,3) = "' """) { Set tFlag = 0 }
        If ($Extract(token,1,3) = "'.""") { Set tFlag = 0 }
        If (tFlag = 0) { Continue }
        If ($Extract(token,1,1) = """") { Set tFlag = 0 }
        If (tFlag = tFlagAssessment) { Set myAssessment = myAssessment_..UnpackToken(token) }
        If (tFlag = tFlagCC) { Set myCC = myCC_..UnpackToken(token) }
        If (tFlag = tFlagDate) { Set myDate = myDate_..UnpackToken(token) }
        If (tFlag = tFlagPatient) { Set myPatient = myPatient_..UnpackToken(token) }
        If (tFlag = tFlagProvider) { Set myProvider = myProvider_..UnpackToken(token) }
        If (tFlag = tFlagTitle) { Set myTitle = myTitle_..UnpackToken(token) }
    }
    zw myAssessment
    zw myCC
    zw myDate
    zw myPatient
    zw myProvider
    zw myTitle
    //zw token
    Quit $$$OK
}

ClassMethod UnpackToken(pToken As %String = "") As %String
{
    If ($Extract(pToken,1,1) = "'") Set pToken = $Extract(pToken,2,*)
    If ($Extract(pToken,*,*) = "'") Set pToken = $Extract(pToken,1,*-1)
    Quit pToken
}

}
