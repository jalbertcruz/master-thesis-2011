-module(iFabrica).

-compile(export_all).

loop(ServiceNodeName) ->
    receive
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mdistanciaHastaAlmacen, SenderServiceNodeName, Bin} 
		->
		 io:write('mdistanciaHastaAlmacen'),
        {iFabricaServer, ServiceNodeName} ! {mdistanciaHastaAlmacen, {ServiceName, SenderServiceNodeName}, Bin},
        loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mdistanciaHastaAlmacenDone, {SenderServiceName, SenderServiceNodeName}, Res} 
		->
		 io:write('mdistanciaHastaAlmacenDone'),
        {iFabricaClient, SenderServiceNodeName} ! {SenderServiceName, mdistanciaHastaAlmacenDone, Res},
        loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mcantidadProductos, SenderServiceNodeName}
         ->
		 io:write('mcantidadProductos'),
         {iFabricaServer, ServiceNodeName} ! {mcantidadProductos, {ServiceName, SenderServiceNodeName}},
         loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mcantidadProductosDone, {SenderServiceName, SenderServiceNodeName}, Res} 
		->
		 io:write('mcantidadProductosDone'),
        {iFabricaClient, SenderServiceNodeName} ! {SenderServiceName, mcantidadProductosDone, Res},
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
			Name = list_to_atom(string:concat("iFabrica", integer_to_list(I))),
			register(Name, spawn(iFabrica, init, [ServiceNodeName]))
		end, 
	    L
	).
    

init(ServiceNodeName) ->
    loop(ServiceNodeName).

%% para usar --> iFabrica:stop(3).
stop(N)->
	L = lists:seq(1, N),
	lists:foreach(fun(I) ->  
		Name = list_to_atom(string:concat("iFabrica", integer_to_list(I))),
		Name ! stop
	end, L).

    
