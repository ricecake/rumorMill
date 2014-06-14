-module(rm_util).

-export([encodeDocket/1, decodeDocket/1, distance/2]).

encodeDocket(RoutingList) ->
        << <<(encItem(Recipient, Status))/bits >>
                || {Recipient, Status}<- RoutingList >>.

decodeDocket(Docket) when is_binary(Docket) -> [ decItem(Item) || <<Item:33>> <= Docket].

distance(A, B) when is_binary(B) -> distance(A, binary:encode_unsigned(B));
distance(A, B) when is_binary(A) -> distance(B, binary:encode_unsigned(A));
distance(A, B) -> A bxor B.

encItem(Rec, false)-> <<Rec:32/bits, 0:1>>;
encItem(Rec, true)->  <<Rec:32/bits, 1:1>>.

decItem(<< Host:32, 0:1 >>) -> {Host, false};
decItem(<< Host:32, 1:1 >>) -> {Host, true}.