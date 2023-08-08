import 'dart:io';

void main(List<String> args) {
  connect();
}

void connect() async {
  // create WebSocket server listens on port 4000
  HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 4000);
  print(
      'WebSocket server listening on ws://${server.address.host}:${server.port}');

  // Variables
  List<String> messages = [];
  List<WebSocket> sockets = [];

  // Listen and handle websocket connections
  server.transform(WebSocketTransformer()).listen((WebSocket webSocket) {
    print('WebSocket connection established.');

    sockets.add(webSocket); // init connected websockets

    webSocket.listen((message) {
      messages.add(message); // init messages
      print("received : $message");

      // Broadcast the message to all clients.
      for (var socket in sockets) {
        socket.add(message);
      }
    });

    // Send the list of messages to the newly connected client.
    webSocket.addStream(Stream.fromIterable([messages.join()]));

    // Handle WebSocket disconnection.
    webSocket.done.then((_) {
      print('WebSocket connection closed. ${webSocket.readyState}');
      // Remove the WebSocket from the list when it is closed.
      sockets.remove(webSocket);
    });
  });
}
