%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(provider_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Type, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	timer:sleep(5000),
	{ok, Req2} = cowboy_req:reply(200, [
		{<<"content-type">>, <<"text/plain">>}
	], <<"Hello world!\n">>, Req),

	{Terminal, _} = cowboy_req:qs_val(<<"terminal_id">>, Req),
	{ClientType, _}  = cowboy_req:qs_val(<<"client_type">>, Req),
	{RequestId, _} = cowboy_req:qs_val(<<"request_id">>,Req),
	{RetryId, _} = cowboy_req:qs_val(<<"retry_id">>,Req),
	
	{{Year,Month,Day},{Hour,Min,Sec}} = calendar:universal_time(),
	
	%% yes, here comes sql injectioni
	Format = "insert into log (terminal_id, client_type, request_id, retry_id, year, month, day, hour, minutes, seconds) values ('~s','~s', ~s, ~s, ~p , ~p,~p,~p,~p,~p )",
	Params = [Terminal, ClientType, RequestId,RetryId,Year,Month,Day,Hour,Min,Sec],	
	io:fwrite(Format, Params),
	Query = erlang:iolist_to_binary( io_lib:format(Format, Params)),
	
	emysql:execute(hello_pool, Query),
	{ok, Req2, State}.


terminate(_Reason, _Req, _State) ->
	ok.
