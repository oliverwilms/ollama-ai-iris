/// 
Class Oliver.BplPdfExtractText Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.StreamContainer' height='2000' width='2000' >
<context>
<property name='text' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='newRequest' type='Ens.StreamContainer' instantiate='0' />
</context>
<sequence xend='200' yend='550' >
<code name='Python Extract Text' xpos='200' ypos='250' >
<![CDATA[ Set tPdf = request.OriginalFilename
 Set ^OLIVER($I(^OLIVER),"tPdf") = tPdf
 Set py = ##class(%SYS.Python).Import("pdf_extract_text")
 Set context.text = py.xtract_text(request.OriginalFilename)
 Set ^OLIVER($I(^OLIVER),"text") = context.text]]>
</code>
<code name='context.newRequest' xpos='200' ypos='350' >
<![CDATA[ Set context.newRequest = ##class(Ens.StreamContainer).%New()
 Set tStream = ##class(%Stream.FileCharacter).%New()
 Set tSC = tStream.Write(context.text)
 Set context.newRequest.Stream = tStream
 ]]>
</code>
<call name='EnsLib.File.PassthroughOperation' target='EnsLib.File.PassthroughOperation' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[EnsLib.File.PassthroughOperation]]></annotation>
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="context.newRequest" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
