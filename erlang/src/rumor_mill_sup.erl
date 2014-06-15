-module(rumor_mill_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, _} = ranch:start_listener(rm_tcp, 10,
		ranch_tcp, [{port, 5555}], rm_tcp_protocol, []),
    {ok, { {one_for_one, 5, 10}, [?CHILD(rm_tcp_sup, supervisor)]} }.

