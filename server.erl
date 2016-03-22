-module(server).
-export([start/1]).

start(Port) ->
    {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
    loop(LSock).


loop(LSock) ->
    {ok, Sock} = gen_tcp:accept(LSock),
    do_recv(Sock),
    ok = gen_tcp:close(Sock),
    loop(LSock).

do_recv(Sock) ->
    receive
	{tcp, Sock, Data} -> io:format("Received : ~p~n", [Data]),
			     gen_tcp:send(Sock, response("Salut !!"));
	{error, Err} -> io:format("Error : ~p~n", [Err])
    end.

response(Str) ->
    B = iolist_to_binary(Str),
    io_lib:fwrite(
      "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",
      [size(B), B]).
