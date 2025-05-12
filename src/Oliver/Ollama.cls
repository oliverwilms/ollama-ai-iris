Class Oliver.Ollama Extends %RegisteredObject
{

ClassMethod SendChat(pPath As %String) As %String
{
  Set resp = ""
  Try {
    Set testreq = ##class(%SYS.Python).Import("testreq")
    Set resp = testreq.send_chat(pPath)
  }
  Catch exp {
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
    ELSE { WRITE "Some other type of exception",! }
    WRITE exp.Code,!
    WRITE "Data: ",exp.Data,!     
  }
  Return resp
}

}
