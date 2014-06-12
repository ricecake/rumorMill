-module(rm_util).

-export([encodeDocket/1, decodeDocket/1]).

encodeDocket(RoutingList) ->
        << <<(encItem(Recipient, Status))/bits >>
                || {Recipient, Status}<- RoutingList >>.

decodeDocket(Docket) when is_binary(Docket) -> [ decItem(Item) || <<Item:33>> <= Docket].
encItem(Rec, false)-> <<Rec:32/bits, 0:1>>;
encItem(Rec, true)->  <<Rec:32/bits, 1:1>>.

decItem(<< Host:32, 0:1 >>) -> {Host, false};
decItem(<< Host:32, 1:1 >>) -> {Host, true}.