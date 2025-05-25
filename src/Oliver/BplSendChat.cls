/// 
Class Oliver.BplSendChat Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.StreamContainer' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<code name='SendChat' xpos='200' ypos='250' >
<![CDATA[ Set text = request.OriginalFilename
 Set ^OLIVER($I(^OLIVER),"text") = text
 Set resp = ##class(Oliver.Ollama).SendChat(request.OriginalFilename)
 Set ^OLIVER($I(^OLIVER),"resp") = resp
 Set response = ##class(Ens.StreamContainer).%New()
 Set tStream = ##class(%Stream.FileCharacter).%New()
 Set tSC = tStream.Write(resp)
 Set response.Stream = tStream
 Set tSC = response.%Save()
 Set ^OLIVER($I(^OLIVER),"response.%Save()") = tSC
 ]]>
</code>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
