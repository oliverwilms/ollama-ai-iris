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
 Set ^OLIVER($I(^OLIVER),"resp") = resp]]>
</code>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
