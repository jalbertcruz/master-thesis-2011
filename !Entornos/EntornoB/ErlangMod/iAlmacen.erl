-module(iAlmacen).

-compile(export_all).

loop(ServiceNodeName) ->
    receive
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mcantidadProductos, SenderServiceNodeName}
         ->
		 io:write('mcantidadProductos'),
         {iAlmacenServer, ServiceNodeName} ! {mcantidadProductos, {ServiceName, SenderServiceNodeName}},
         loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mcantidadProductosDone, {SenderServiceName, SenderServiceNodeName}, Res} 
		->
		 io:write('mcantidadProductosDone'),
        {iAlmacenClient, SenderServiceNodeName} ! {SenderServiceName, mcantidadProductosDone, Res},
         loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
       stop -> ok

    end.

start(ServiceNodeName, N) ->
	L = lists:seq(1, N),
	lists:foreach(
		fun(I) ->  
			Name = list_to_atom(string:concat("iAlmacen", integer_to_list(I))),
			register(Name, spawn(iAlmacen, init, [ServiceNodeName]))
		end, 
	    L
	).
 	
init(ServiceNodeName) ->
    loop(ServiceNodeName).

stop(N)->
	L = lists:seq(1, N),
	lists:foreach(fun(I) ->  
		Name = list_to_atom(string:concat("iAlmacen", integer_to_list(I))),
		Name ! stop
	end, L).
