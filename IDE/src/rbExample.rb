require 'java'

require 'common.jar'

require 'ScalaProxies_Env1.jar'

java_import 'tiposPrimitivos.Impl.NumeroImpl'
java_import 'tiposPrimitivos.Impl.LogicoImpl'
java_import 'tiposPrimitivos.Impl.CadenaImpl'

# Los otros subprogramas...



tv = $tv
ventilador = $ventilador

b = tv.apagado()

ventilador.darNVueltas(NumeroImpl.new("3"))

if (b.valor()) then
  tv.encender()
end

ventilador.darUnaVuelta()
ventilador.darUnaVuelta()