-module(rm_nameMap).
-behavior(gen_server).
-export([init/0, add/2, remove/2, id_to_ip/1, ip_to_id/1]).
