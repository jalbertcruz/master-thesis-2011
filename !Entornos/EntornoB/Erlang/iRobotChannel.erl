-module(iRobotChannel).

-export([
    start/0,
    stop/0,
    init/0
        ]).

loop(Rest, Cola) ->
    receive
        {registerFactory, {FactoryServiceName, FactoryServiceNodeName}} ->
            loop( Rest, [ {FactoryServiceName, FactoryServiceNodeName} | Cola] );

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


        {mmoverHastaAlmacen,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mmoverHastaAlmacen, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mmoverHastaAlmacenDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mmoverHastaAlmacenDone,
            loop(Rest, Cola);

        {mmoverHastaFabrica,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mmoverHastaFabrica, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mmoverHastaFabricaDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mmoverHastaFabricaDone,
            loop(Rest, Cola);

        {mdistanciaHastaFabrica,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mdistanciaHastaFabrica, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mdistanciaHastaFabricaDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {mdistanciaHastaFabricaDone, Res},
            loop(Rest, Cola);

        {mcogerObjeto,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mcogerObjeto, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mcogerObjetoDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mcogerObjetoDone,
            loop(Rest, Cola);

        {mentregarObjeto,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mentregarObjeto, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mentregarObjetoDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mentregarObjetoDone,
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


       stop -> ok

    end.

start() ->
    register(channel, spawn(channel, init, [])).

init() ->
    loop([],[]).

stop()->
    channel ! stop.

