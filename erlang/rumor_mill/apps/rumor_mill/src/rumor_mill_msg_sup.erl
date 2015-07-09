%%%-------------------------------------------------------------------
%% @doc rumor_mill message processing supervisor.
%% @end
%%%-------------------------------------------------------------------

-module('rumor_mill_msg_sup').

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {simple_one_for_one, 5, 10}, [
        {rumor_mill_msg, {rumor_mill_msg, start_link, []}, transient, 5000, worker, [rumor_mill_msg]}
    ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
