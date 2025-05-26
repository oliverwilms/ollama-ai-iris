Class Oliver.NewProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Oliver.NewProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.REST.GenericService" Category="" ClassName="EnsLib.REST.GenericService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">ollama</Setting>
  </Item>
  <Item Name="ollama" Category="" ClassName="EnsLib.REST.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">11434</Setting>
    <Setting Target="Adapter" Name="HTTPServer">ollama</Setting>
    <Setting Target="Adapter" Name="URL">/api/chat</Setting>
  </Item>
  <Item Name="PDF File Service" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">Oliver.BplPdfExtractText</Setting>
    <Setting Target="Adapter" Name="FilePath">/irisdev/app/data_example/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.pdf</Setting>
  </Item>
  <Item Name="EnsLib.File.PassthroughOperation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/</Setting>
  </Item>
  <Item Name="Oliver.BplPdfExtractText" Category="" ClassName="Oliver.BplPdfExtractText" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Text File Service" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">Oliver.BplSendChat</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp</Setting>
    <Setting Target="Adapter" Name="FileSpec">_2025*</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/usr/irissys/mgr/iristemp</Setting>
    <Setting Target="Adapter" Name="WorkPath">/usr/irissys/mgr/iristemp</Setting>
  </Item>
  <Item Name="Oliver.BplSendChat" Category="" ClassName="Oliver.BplSendChat" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
