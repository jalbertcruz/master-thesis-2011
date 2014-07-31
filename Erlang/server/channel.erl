-module(channel).

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


        {mdarNVueltas,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName},
         Bin} ->
            {ServiceName, ServiceNodeName} ! {mdarNVueltas, {SenderServiceName, SenderServiceNodeName}, Bin},
            loop(Rest, Cola);

        {mdarNVueltasDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mdarNVueltasDone,
            loop(Rest, Cola);

        {mveces,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {mveces, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {mvecesDone, {SenderServiceName, SenderServiceNodeName}, Res} ->
            {SenderServiceName, SenderServiceNodeName} ! {mvecesDone, Res},
            loop(Rest, Cola);
        {mdarUnaVuelta,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {mdarUnaVuelta, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {mdarUnaVueltaDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mdarUnaVueltaDone,
            loop(Rest, Cola);
        {mcambiarSentido,
         {SenderServiceName, SenderServiceNodeName},
         {ServiceName, ServiceNodeName}} ->
            {ServiceName, ServiceNodeName} ! {mcambiarSentido, {SenderServiceName, SenderServiceNodeName}},
            loop(Rest, Cola);

        {mcambiarSentidoDone, {SenderServiceName, SenderServiceNodeName}} ->
            {SenderServiceName, SenderServiceNodeName} ! mcambiarSentidoDone,
            loop(Rest, Cola);

       stop -> ok

    end.

start() ->
    register(channel, spawn(channel, init, [])).

init() ->
    loop([],[]).

stop()->
    channel ! stop.

