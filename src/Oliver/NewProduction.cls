Class Oliver.NewProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Oliver.NewProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Service" Category="" ClassName="EnsLib.REST.GenericService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">ollama</Setting>
  </Item>
  <Item Name="ollama" Category="" ClassName="EnsLib.REST.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">11434</Setting>
    <Setting Target="Adapter" Name="HTTPServer">ollama</Setting>
    <Setting Target="Adapter" Name="URL">/api/chat</Setting>
  </Item>
</Production>
}

}
