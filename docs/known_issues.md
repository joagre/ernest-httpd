# Known issues

What is known to be wrong or missing and not planned, a line each, until the user takes one up.

- **Enough addresses fill a listener.** A listener holds `limits.connections`, at most `limits.connections-per-address` of them from one counted address, so five counted addresses at the deployed 80 and 16 hold every place, each connection kept by a request within the idle deadline, and the next client waits in the backlog until one ends (design §7). Ending an idle connection for a newcomer was weighed and refused, since its kill frees the place while the host still sends its last response, for up to 3 minutes (the log's *Milestone 2, item 12: the caps by address*).
- **A C1 control character in the configuration reaches standard error.** Design §4's `hold no control character` refuses U+0000 to U+001F and U+007F, where the report's control characters run on through U+009F, and a refusal writes a value as `Json.encode` does, which writes U+0080 to U+009F bare; only a configuration written with one on purpose meets it.
