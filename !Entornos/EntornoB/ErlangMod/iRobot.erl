-module(iRobot).

-compile(export_all).

loop(ServiceNodeName) ->

    receive
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mmoverHastaAlmacen, SenderServiceNodeName, Bin} 
		 ->
		 io:write('mmoverHastaAlmacen}'),
         {iRobotServer, ServiceNodeName} ! {mmoverHastaAlmacen, {ServiceName, SenderServiceNodeName}, Bin},
         loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mmoverHastaAlmacenDone, {SenderServiceName, SenderServiceNodeName}} 
		->
		io:write('mmoverHastaAlmacenDone}'),
        {iRobotClient, SenderServiceNodeName} ! {SenderServiceName, mmoverHastaAlmacenDone},
        loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mmoverHastaFabrica, SenderServiceNodeName, Bin} 
		->
		io:write('mmoverHastaFabrica}'),
        {iRobotServer, ServiceNodeName} ! {mmoverHastaFabrica, {ServiceName, SenderServiceNodeName}, Bin},
        loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mmoverHastaFabricaDone, {SenderServiceName, SenderServiceNodeName}} 
		->
		io:write('mmoverHastaFabricaDone}'),
        {iRobotClient, SenderServiceNodeName} ! {SenderServiceName, mmoverHastaFabricaDone},
        loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mdistanciaHastaFabrica, SenderServiceNodeName, Bin} 
		->
		io:write('mdistanciaHastaFabrica}'),
        {iRobotServer, ServiceNodeName} ! {mdistanciaHastaFabrica, {ServiceName, SenderServiceNodeName}, Bin},
        loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mdistanciaHastaFabricaDone, {SenderServiceName, SenderServiceNodeName}, Res} 
		->
		io:write('mdistanciaHastaFabricaDone}'),
        {iRobotClient, SenderServiceNodeName} ! {SenderServiceName, mdistanciaHastaFabricaDone, Res},
        loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mcogerObjeto, SenderServiceNodeName, Bin} 
		 ->
		io:write('mcogerObjeto}'),
         {iRobotServer, ServiceNodeName} ! {mcogerObjeto, {ServiceName, SenderServiceNodeName}, Bin},
         loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mcogerObjetoDone, {SenderServiceName, SenderServiceNodeName}} 
		->
		io:write('mcogerObjetoDone}'),
        {iRobotClient, SenderServiceNodeName} ! {SenderServiceName, mcogerObjetoDone},
        loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mentregarObjeto, SenderServiceNodeName, Bin} 
		 ->
		io:write('mentregarObjeto}'),
         {iRobotServer, ServiceNodeName} ! {mentregarObjeto, {ServiceName, SenderServiceNodeName}, Bin},
         loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mentregarObjetoDone, {SenderServiceName, SenderServiceNodeName}} 
		->
		io:write('mentregarObjetoDone}'),
        {iRobotClient, SenderServiceNodeName} ! {SenderServiceName, mentregarObjetoDone},
        loop(ServiceNodeName);
%%---------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------------------------------
        {ServiceName, mdistanciaHastaAlmacen, SenderServiceNodeName, Bin} 
		 ->
		io:write('mdistanciaHastaAlmacen}'),
         {iRobotServer, ServiceNodeName} ! {mdistanciaHastaAlmacen, {ServiceName, SenderServiceNodeName}, Bin},
         loop(ServiceNodeName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        {mdistanciaHastaAlmacenDone, {SenderServiceName, SenderServiceNodeName}, Res} 
		->
		io:write('mdistanciaHastaAlmacenDone}'),
        {iRobotClient, SenderServiceNodeName} ! {SenderServiceName, mdistanciaHastaAlmacenDone, Res},
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
			Name = list_to_atom(string:concat("iRobot", integer_to_list(I))),
			register(Name, spawn(iRobot, init, [ServiceNodeName]))
		end, 
	    L
	).
 	
init(ServiceNodeName) ->
    loop(ServiceNodeName).

stop(N)->
	L = lists:seq(1, N),
	lists:foreach(fun(I) ->  
		Name = list_to_atom(string:concat("iRobot", integer_to_list(I))),
		Name ! stop
	end, L).