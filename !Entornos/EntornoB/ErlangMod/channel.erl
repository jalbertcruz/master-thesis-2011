-module(channel).

-compile(export_all).

loop() ->
    receive
       stop ->

    iRobot:stop(1),

    iAlmacen:stop(1),

    iFabrica:stop(3),

 		    ok
    end.

start() ->

    iRobot:start('nServer@127.0.0.1', 1),

    iAlmacen:start('nServer@127.0.0.1', 1),

    iFabrica:start('nServer@127.0.0.1', 3),

    register(channel, spawn(channel, init, [])).

init() ->
    loop().

stop()->
    channel ! stop.

