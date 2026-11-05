# Ernest module WebSocket

RFC 6455's frames and its handshake's accept value: a WebSocket's messages
decoded from bytes and encoded as frames, knowing no socket (design §10).

A server uses it on a connection it has upgraded: `accept` answers the
handshake's `Sec-WebSocket-Accept` for the client's `Sec-WebSocket-Key`,
a decoder of `FromClient` frames takes what the socket reads, the bytes
after the handshake's head first, and `encode` writes each message the
server sends. A client, a test's among them, decodes `FromServer` frames
and writes each message with `encodeMasked` and a key of its own for the
frame, `Crypto.randomBytes(4)`.

A decoder is a value: `decode` takes it with the bytes read and answers
the messages they complete and the decoder that holds the rest, a frame
whose bytes have not all come and a message whose final frame has not.
A decoder that answered an error is not used again: the connection closes
with the error's `closeCode`.

A message is whole: a text or a binary message's fragments are joined,
and a ping, a pong and a close are answered where they come, between two
fragments among them. No extension is read and no subprotocol: a frame
with a reserved bit set is refused.

## Examples

A client's text message decoded, RFC 6455's masked frame of §5.7:

```ernest
let decoder = WebSocket.decoder(WebSocket.FromClient, 65536);
let frame = <<0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58>>;
Either.map(WebSocket.decode(decoder, frame), fn(#(messages, _)) = messages)
// => Right([WebSocket.Text("Hello")])
```

The server's text message encoded, the RFC's unmasked frame of §5.7:

```ernest
Bytes.toHex(WebSocket.encode(WebSocket.Text("Hello")))
// => "810548656C6C6F"
```

## WebSocket.Message

```ernest
type Message =
    Text(String)
  | Binary(Bytes)
  | Ping(Bytes)
  | Pong(Bytes)
  | Close(code : Optional(Int), reason : String)
```

A WebSocket's message, what one side sends whole: a text message, a
binary message, a ping and a pong with their payloads, and a close with
its code and its reason, `None` and `""` where the close carries
neither.

A ping, a pong and a close carry at most 125 bytes, a close's two bytes
of code among them, and a close carries a code of 1000 to 1003, 1007 to
1014 or 3000 to 4999 (RFC 6455's §5.5, and its §7.4 with IANA's
registry).

### Examples

```ernest
Bytes.toHex(WebSocket.encode(WebSocket.Close(code = Some(1000), reason = "done")))
// => "880603E8646F6E65"
```

## WebSocket.Role

```ernest
type Role = FromClient | FromServer
```

The side whose frames a decoder takes: `FromClient`, a client's, each
masked, or `FromServer`, a server's, none masked.

### Examples

A decoder of a server's frames given a client's masked frame:

```ernest
let decoder = WebSocket.decoder(WebSocket.FromServer, 65536);
let frame = <<0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58>>;
Either.map(WebSocket.decode(decoder, frame), fn(#(messages, _)) = messages)
// => Left(WebSocket.ProtocolError)
```

## WebSocket.Error

```ernest
type Error = ProtocolError | TooBig | NotUtf8
```

What a decoder refuses: `ProtocolError`, a frame RFC 6455 forbids;
`TooBig`, a message past the decoder's limit; and `NotUtf8`, a text
message or a close's reason that is not UTF-8.

### Examples

```ernest
let decoder = WebSocket.decoder(WebSocket.FromServer, 4);
let frame = <<0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f>>;
Either.map(WebSocket.decode(decoder, frame), fn(#(messages, _)) = messages)
// => Left(WebSocket.TooBig)
```

## WebSocket.Decoder

```ernest
abstract type Decoder
```

The frames one role sends, with what has come of a frame or a message
whose end has not: `decoder` makes one, and `decode` takes it with the
bytes read and answers the next.

### Examples

A text message of two frames, RFC 6455's `Hel` and `lo` of §5.7, across
two reads:

```ernest
let decoder = WebSocket.decoder(WebSocket.FromServer, 65536);
{
    let #(first, decoder) <- WebSocket.decode(decoder, <<0x01, 0x03, 0x48, 0x65, 0x6c>>);
    let #(second, _) <- WebSocket.decode(decoder, <<0x80, 0x02, 0x6c, 0x6f>>);
    Right(#(first, second))
}
// => Right(#([], [WebSocket.Text("Hello")]))
```

## WebSocket.accept

```ernest
WebSocket.accept(key : String) : String
```

The value of `Sec-WebSocket-Accept` for a request's `Sec-WebSocket-Key`:
the SHA-1 digest of the key and `258EAFA5-E914-47DA-95CA-C5AB0DC85B11`,
written in base64 (RFC 6455, §4.2.2).

The key is taken as written; whether it is 16 bytes in base64 is the
handshake's to check.

### Examples

RFC 6455's key of §4.2.2:

```ernest
WebSocket.accept("dGhlIHNhbXBsZSBub25jZQ==")
// => "s3pPLMBiTxaQ9kYGzzhZRbK+xOo="
```

## WebSocket.decoder

```ernest
WebSocket.decoder(role : Role, limit : Int) : Decoder
```

A decoder of the role's frames that takes a message of at most `limit`
bytes, with no frame and no message under way.

The limit counts a text or a binary message's payload, its fragments'
together, a text message's in UTF-8; a ping, a pong and a close are held
to 125 bytes by the RFC, and the limit does not count them. A limit below
0 is 0 (report §7.4).

## WebSocket.decode

```ernest
WebSocket.decode(decoder : Decoder, bytes : Bytes) : Either(Error, #(List(Message), Decoder))
```

The messages the bytes complete, in order, and the decoder that holds
the rest; the bytes the decoder held come before them.

A frame is refused as soon as its bytes show what it breaks. A header
RFC 6455 forbids is `ProtocolError`, and a fragment's header that takes
its message past the decoder's limit is `TooBig`, each before the
payload has come; a close's code is read with its payload, and its
reason as UTF-8, else `NotUtf8`; and a text message is read as UTF-8 at
its final frame, its fragments joined, else `NotUtf8`. Bytes that
complete no message answer none, and bytes that hold an error answer the
error alone, the messages before it dropped.

The frames refused as `ProtocolError`: one masked for a `FromServer`
decoder, or not masked for a `FromClient` one; one with a reserved bit
set or a reserved opcode; one whose length is not written in the
shortest of the three forms, or whose 64 bits have the highest set; a
control frame that is not final, or whose payload passes 125 bytes; a
continuation with no message under way, and a text or a binary message's
first frame inside one; and a close whose payload is one byte, or whose
code is not 1000 to 1003, 1007 to 1014 or 3000 to 4999.

A frame after a close is decoded as any other.

### Examples

A ping between a text message's two fragments, answered in its place:

```ernest
let decoder = WebSocket.decoder(WebSocket.FromServer, 65536);
let frames = <<0x01, 0x03, 0x48, 0x65, 0x6c, 0x89, 0x00, 0x80, 0x02, 0x6c, 0x6f>>;
Either.map(WebSocket.decode(decoder, frames), fn(#(messages, _)) = messages)
// => Right([WebSocket.Ping(<<>>), WebSocket.Text("Hello")])
```

A frame whose header says it passes the limit, refused before its
payload has come:

```ernest
let decoder = WebSocket.decoder(WebSocket.FromServer, 65536);
let header = <<0x82, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01>>;
Either.map(WebSocket.decode(decoder, header), fn(#(messages, _)) = messages)
// => Left(WebSocket.TooBig)
```

## WebSocket.closeCode

```ernest
WebSocket.closeCode(error : Error) : Int
```

The close code RFC 6455 gives an error, which a connection closes with:
1002 for `ProtocolError`, 1009 for `TooBig` and 1007 for `NotUtf8`.

### Examples

```ernest
WebSocket.closeCode(WebSocket.TooBig)
// => 1009
```

## WebSocket.encode

```ernest
WebSocket.encode(message : Message) : Bytes
```

One frame of the message, unmasked, as a server sends it: final, its
payload's length in the shortest of the three forms, a text message's
payload its UTF-8, and a close's its code in two bytes and its reason, or
none where it has no code, its reason dropped.

The message is written as given: a ping, a pong or a close past 125
bytes, or a close whose code the RFC does not allow, is a frame a decoder
refuses.

### Errors

A close whose code is below 0 or above 65535 faults, as a bitstring
faults on a value that does not fit its 16 bits: `segment overflow: 70000
does not fit 16 bits` (report §7.4).

### Examples

RFC 6455's unmasked ping of §5.7:

```ernest
Bytes.toHex(WebSocket.encode(WebSocket.Ping(String.toUtf8("Hello"))))
// => "890548656C6C6F"
```

The header of the RFC's binary message of 256 bytes, its length in 16
bits, and of 64 KiB, in 64:

```ernest
let header = fn(count) = {
    let frame = WebSocket.encode(WebSocket.Binary(Bytes.repeat(<<0>>, count)));
    Bytes.toHex(Bytes.slice(frame, 0, Bytes.size(frame) - count))
};
[header(256), header(65536)]
// => ["827E0100", "827F0000000000010000"]
```

## WebSocket.encodeMasked

```ernest
WebSocket.encodeMasked(message : Message, key : Bytes) : Optional(Bytes)
```

One frame of the message masked with the four-byte key, as a client sends
it: the frame `encode` writes, its mask bit set, the key after its
length, and its payload masked with the key; `None` for a key of another
size.

A client draws the key afresh for each frame, `Crypto.randomBytes(4)`.

### Errors

A close whose code is below 0 or above 65535 faults, as `encode` does.

### Examples

RFC 6455's masked text message of §5.7, and a key of three bytes:

```ernest
let key = <<0x37, 0xfa, 0x21, 0x3d>>;
[Optional.map(WebSocket.encodeMasked(WebSocket.Text("Hello"), key), Bytes.toHex),
 Optional.map(WebSocket.encodeMasked(WebSocket.Text("Hello"), <<1, 2, 3>>), Bytes.toHex)]
// => [Some("818537FA213D7F9F4D5158"), None]
```

---

Generated by ern 0.10.0+612faac8 from src/web_socket.ern.
