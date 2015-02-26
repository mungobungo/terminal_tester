-module(wss_example_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
            {'_', [
                    {"/", cowboy_static, {priv_file, wss_example, "index.html"}},
		    {"/provider", provider_handler, [] },
                    {"/websocket", ws_handler, []},
                    {"/static/[...]", cowboy_static, {priv_dir, wss_example, "static"}}
                ]}
        ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]),
    SSLDir = code:priv_dir(wss_example) ++ "/ssl/",
    {ok, _} = cowboy:start_https(https, 100, [{port, 8443},
                                              {certfile, SSLDir ++ "cert.pem"},
                                              {keyfile, SSLDir ++ "key.pem"}],
                                 [{env, [{dispatch, Dispatch}]}]),
    ok = emysql:add_pool(hello_pool, [{size, 20},
		 {user, "root"},
		 {password, "zuyaVckUCA"},
		 {database, "test"},
		 {encoding, utf8}]),

    wss_example_sup:start_link().

stop(_State) ->
    ok.
