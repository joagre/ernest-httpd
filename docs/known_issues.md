# Known issues

What is known to be wrong or missing and not planned, a line each, until the user takes one up.

- **Enough addresses fill a listener.** A listener holds `limits.connections`, at most `limits.connections-per-address` of them from one counted address, so five counted addresses at the deployed 80 and 16 hold every place, each connection kept by a request within the idle deadline, and the next client waits in the backlog until one ends (design §7). Ending an idle connection for a newcomer was weighed and refused, since its kill frees the place while the host still sends its last response, for up to 3 minutes (the log's *Milestone 2, item 12: the caps by address*).
