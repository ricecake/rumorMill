-module(rm_msg).

-export([new/0, new/1, set/3, get/2, serialize/1, deserialize/1]).


-define(ALIVE, 0).
-define(STD,   1).
-define(MULTI, 2).
-define(DIR,   3).

-define(SYN,    0).
-define(SYNACK, 1).
-define(ACK,    2).
-define(RESET,  3).
-define(CLOSE,  4).

-define(Fields, [{type, 2, ?STD}, {phase, 3, ?SYN}, {seq, 3, 0}, {id, 96, 0}, {body, 0, 0}]).

new() -> #{}.
new(Type) when is_atom(Type) -> #{type => Type}.

set(Msg, Field, Value) when is_map(Msg) -> maps:put(Field, Value, Msg).

get(Msg, Field) when is_map(Msg) -> maps:get(Field, Msg).

serialize(Msg) when is_map(Msg) ->
	Encoded = << <<(encode_field(hget(Msg, Field, Default), Size))/bits>> || {Field, Size, Default} <- ?Fields >>,
        << (size(Encoded)):32/integer, Encoded/bits >>.
	

deserialize(Raw) when is_binary(Raw) -> 
	{List, <<>>} = lists:foldl(
		fun({Field, 0, _Default},{List, Binary}) ->
			{ok, Body} = snappy:decompress(Binary),
			{[{Field, vlq:decode(Body)}|List], <<>>};
		   ({Field, Size, _Default}, {List, Binary})-> 
			<<Data:Size/bits, Rest/bits>> = Binary,
			{[{Field, Data}|List], Rest} 
		end, 
		{[], Raw}, ?Fields),
		maps:from_list(List).

encode_field(Value, 0)    ->
	Coded = vlq:encode(Value),
	{ok, Data} = snappy:compress(Coded),
	Data;
encode_field(Value, Size) when is_binary(Value) -> <<0:(Size - bit_size(Value)), Value/bits>>;
encode_field(Value, Size) -> <<Value:Size>>.

hget(Map, Key, Default) -> 
	case maps:find(Key, Map) of
		{ok, Value} -> Value;
		error       -> Default
	end.

