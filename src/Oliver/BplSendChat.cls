/// 
Class Oliver.BplSendChat Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.StreamContainer' height='2000' width='2000' >
<context>
<property name='resp' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='newRequest' type='Ens.StreamContainer' instantiate='0' />
</context>
<sequence xend='200' yend='650' >
<code name='SendChat' xpos='200' ypos='250' >
<![CDATA[ Set text = request.OriginalFilename
 Set ^OLIVER($I(^OLIVER),"text") = text
 Set context.resp = ##class(Oliver.Ollama).SendChat(request.OriginalFilename)
 Set ^OLIVER($I(^OLIVER),"resp") = context.resp
 Set response = ##class(Ens.StreamContainer).%New()
 Set tStream = ##class(%Stream.FileCharacter).%New()
 Set tSC = tStream.Write(context.resp)
 Set response.Stream = tStream
 Set tSC = response.%Save()
 Set ^OLIVER($I(^OLIVER),"response.%Save()") = tSC
 ]]>
</code>
<code name='context.newRequest' xpos='200' ypos='350' >
<![CDATA[ Set context.newRequest = ##class(Ens.StreamContainer).%New()
 Set text = request.OriginalFilename
 Set textFilename = ##class(%File).GetFilename(text)
 Set ^OLIVER($I(^OLIVER),"textFilename") = textFilename
 Set tStream = ##class(%Stream.FileCharacter).%New()
 Set tSC = tStream.Write(context.resp)
 Set context.newRequest.Stream = tStream
 Set context.newRequest.OriginalFilename = $Replace(textFilename,".txt",".resp")
 Set tSC = context.newRequest.%Save()
 Set ^OLIVER($I(^OLIVER),"context.newRequest.%Save()") = tSC]]>
</code>
<call name='EnsLib.File.PassthroughOperation' target='EnsLib.File.PassthroughOperation' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[EnsLib.File.PassthroughOperation]]></annotation>
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="context.newRequest" action="set" languageOverride="" />
</request>
<response type='Ens.Response' />
</call>
<reply xpos='200' ypos='550' />
</sequence>
</process>
}

}
