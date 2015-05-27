rumorMill
=========

A gossip like algorithm for peer to peer transfer of messages.

Build network as kademilla DHT

Messages are nodes in graph, with parents as unattached nodes (heads) when message came in.

Nodes gossip graph Heads, and when unknown head encountered, tree is transfered until consistent. 

When all neighbors resolve a head, it may be pruned according to persistence rules. 

Message subscriptions are gossipped per node. 
The routes you gossip are the union of your routes, and your neighbors routes, minus the routs exclusive to the gossip recipient. This helps minimize number of tracked routes. 

A lamport timestamp that's incremented whenever a new message is encountered ensure that we don't gossip with those that we already know are on the same page as us.

each node also gossips how many peers it has, and how many nodes it's a "gateway" to, so that when a node gets a message, it can preferentially send message first to the most popular nodes.
