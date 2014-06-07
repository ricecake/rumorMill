-module(rm_msg).

-export([new/0, new/1, set/3, get/2, serialize/1, deserialize/1]).


-define(STD, 10).
-define(KA,  0).

new() -> #{}.
new(Type) when is_atom(Type) -> #{type => Type}.

set(Msg, Field, Value) when is_map(Msg) -> map:put(Field, Value, Msg).

get(Msg, Field) when is_map(Msg) -> map:get(Field, Msg).

serialize(Msg) when is_map(Msg) -> <<>>.

deserialize(Binary) when is_binary(Binary) -> #{}.

hget(Map, Key, Default) -> 
	case map:find(Key, Map) of
		{ok, Value} -> Value;
		error       -> Default
	end.

