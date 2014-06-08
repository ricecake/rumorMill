-module(rm_msg).

-export([new/0, new/1, set/3, get/2, serialize/1, deserialize/1]).


-define(ALIVE, 0).
-define(STD,   1).
-define(MULTI, 2).
-define(DIR,   4).

-define(SYN,    1).
-define(SYNACK, 2).
-define(ACK,    3).
-define(RESET,  4).

-define(Fields, [{type, 2, ?STD}, {phase, 3, ?SYN}, {seq, 3, 0}, {id, 96, 0}, {body, 0, 0}]).

new() -> #{}.
new(Type) when is_atom(Type) -> #{type => Type}.

set(Msg, Field, Value) when is_map(Msg) -> maps:put(Field, Value, Msg).

get(Msg, Field) when is_map(Msg) -> maps:get(Field, Msg).

serialize(Msg) when is_map(Msg) ->
	<< <<(encode_field(hget(Msg, Field, Default), Size))/bits>> || {Field, Size, Default} <- ?Fields >>.
	

deserialize(Raw) when is_binary(Raw) -> 
	{List, <<>>} = lists:foldl(
		fun({Field, 0, _Default},{List, Binary}) ->
			{[{Field, Binary}|List], <<>>};
		   ({Field, Size, _Default}, {List, Binary})-> 
			<<Data:Size/bits, Rest/bits>> = Binary,
			{[{Field, Data}|List], Rest} 
		end, 
		{[], Raw}, ?Fields),
		maps:from_list(List).

encode_field(Value, Size) when is_binary(Value) -> <<0:(Size - bit_size(Value)), Value/bits>>;
encode_field(Value, 0)    -> vlq:encode(Value);
encode_field(Value, Size) -> <<Value:Size>>.

hget(Map, Key, Default) -> 
	case maps:find(Key, Map) of
		{ok, Value} -> Value;
		error       -> Default
	end.

