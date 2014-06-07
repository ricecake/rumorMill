-module(rm_msg).

-export([new/0, new/1, set/3, get/2, serialize/1, deserialize/1]).


-define(STD, 1).
-define(KA,  0).

-define(SYN,    1).
-define(SYNACK, 2).
-define(ACK,    3).
-define(RESET,  4).

-define(Fields, [{type, 1, ?STD}, {phase, 4, ?SYN}, {seq, 3, 0}, {id, 128, 0}, {body, 0, 0}]).

new() -> #{}.
new(Type) when is_atom(Type) -> #{type => Type}.

set(Msg, Field, Value) when is_map(Msg) -> maps:put(Field, Value, Msg).

get(Msg, Field) when is_map(Msg) -> maps:get(Field, Msg).

serialize(Msg) when is_map(Msg) ->
	<< <<(encode_field(hget(Msg, Field, Default), Size))/bits>> || {Field, Size, Default} <- ?Fields >>.
	

deserialize(Binary) when is_binary(Binary) -> #{}.

encode_field(Value, Size) when is_binary(Value) -> <<0:(Size - (bit_size(Value) rem Size)), Value/bits>>;
encode_field(Value, 0)    -> vlq:encode(Value);
encode_field(Value, Size) -> <<Value:Size>>.

hget(Map, Key, Default) -> 
	case maps:find(Key, Map) of
		{ok, Value} -> Value;
		error       -> Default
	end.

