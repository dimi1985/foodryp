import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;
  late StreamController _controller;
  final Completer<void> _disposalCompleter = Completer<void>();

  WebSocketService(this.url) {
    _controller = StreamController.broadcast(onListen: _connect, onCancel: _dispose);
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen(
      (message) {
        _controller.add(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
        _controller.addError(error);
      },
      onDone: () async {
        print('WebSocket connection closed');
        if (!_disposalCompleter.isCompleted) {
          await _reconnect();
        }
      },
    );
  }

  Future<void> _reconnect() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!_disposalCompleter.isCompleted) {
      print('Reconnecting to WebSocket...');
      _controller = StreamController.broadcast(onListen: _connect, onCancel: _dispose);
      _connect();
    }
  }

  Stream get stream => _controller.stream;

  void _dispose() async {
    if (!_disposalCompleter.isCompleted) {
      _disposalCompleter.complete();
      await _channel.sink.close(status.goingAway);
      await _controller.close();
    }
  }

  void dispose() {
    _dispose();
  }
}
