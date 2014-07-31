
-module(iFabricaChannel).

-compile(export_all).

loop(Rest, Cola) ->
    receive
        {registerFactory, {FactoryServiceName, FactoryServiceNodeName}} ->
            loop( Rest, [ {FactoryServiceName, FactoryServiceNodeName} | Cola]);

        {newObject, {FactoryClient, HostClient}} ->
            case Cola of
                [] ->
                    {FactoryClient, HostClient} ! noService,
                    loop(Rest, Cola);

                [ {FactoryServer, HostServer} | T ] ->
                    {FactoryServer, HostServer} ! {newObject, {FactoryClient, HostClient}},
                    case T of
                        [] -> loop([], [{FactoryServer, HostServer} | Rest]);
                        _  -> loop([{FactoryServer, HostServer} | Rest], T)
                    end

            end;

	{newObjectDone,
         {SenderFactoryName, SenderFactoryNodeName},
         {ServiceName, ServiceNodeName}} ->
            {SenderFactoryName, SenderFactoryNodeName} ! {newObjectDone, {ServiceName, ServiceNodeName}},
            loop(Rest, Cola);


        {mvalorDeX,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {mvalorDeX, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {mvalorDeXDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {mvalorDeXDone, Res},
            loop(Rest, Cola);
        {mvalorDeY,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {mvalorDeY, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {mvalorDeYDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {mvalorDeYDone, Res},
            loop(Rest, Cola);
        {mdistanciaHastaAlmacen,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mdistanciaHastaAlmacen, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mdistanciaHastaAlmacenDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {mdistanciaHastaAlmacenDone, Res},
            loop(Rest, Cola);

        {msacar,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {msacar, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {msacarDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {msacarDone, Res},
            loop(Rest, Cola);
        {mcantidadProductos,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {mcantidadProductos, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {mcantidadProductosDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {mcantidadProductosDone, Res},
            loop(Rest, Cola);

       stop -> ok

    end.

start([Cant]) ->
	N = list_to_integer(atom_to_list(Cant)),
	L = lists:seq(1, N),
	lists:foreach(fun(I) ->  
		Name = list_to_atom(string:concat("iFabricaChannel", integer_to_list(I))),
		register(Name, spawn(iFabricaChannel, init, []))
	end, L).
    

init() ->
    loop([],[]).

%% para usar --> iFabricaChannel:stop(list_to_atom("3")).
stop([Cant])->
	N = list_to_integer(atom_to_list(Cant)),
	L = lists:seq(1, N),
	lists:foreach(fun(I) ->  
		Name = list_to_atom(string:concat("iFabricaChannel", integer_to_list(I))),
		Name ! stop
	end, L).

    
