import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trader_app/core/interfaces/socket_interface.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FinnhubWebSocket implements ISocket {
  bool _connected = false;
  bool _explicitlyClosed = false;
  List<String> _activeSubscriptions = [];
  late WebSocketChannel _channel;

  /// Connects to the WebSocket server. Only allows a single connection.
  @override
  Future<void> connect(
    Function onMessageReceived, {
    List<String>? initialSymbols,
  }) async {
    if (_connected) return;

    try {
      final uri = Uri.parse('wss://ws.finnhub.io?token=${dotenv.env['TOKEN']}');
      _channel = WebSocketChannel.connect(uri);
      await _channel.ready;

      _connected = true;
      _explicitlyClosed = false;

      print('WebSocket connected.');

      _channel.stream.listen(
        (message) {
          onMessageReceived(jsonDecode(message));
        },
        onError: (error) => _handleError(error, onMessageReceived),
        onDone: () => _handleDone(onMessageReceived),
      );
      _resubscribeActiveSymbols(initialSymbols);
    } catch (e) {
      print('Connection error: $e');
      _reconnect(onMessageReceived);
    }
  }

  /// Handles WebSocket errors.
  void _handleError(dynamic error, Function onMessageReceived) {
    print('WebSocket error: $error');
    if (!_connected) {
      _reconnect(onMessageReceived);
    }
  }

  /// Handles unexpected WebSocket closure.
  void _handleDone(Function onMessageReceived) {
    _connected = false;
    if (!_explicitlyClosed) {
      print('WebSocket connection lost. Attempting to reconnect...');
      _reconnect(onMessageReceived);
    } else {
      print('WebSocket closed explicitly.');
    }
  }

  @override
  void subscribe(data) {
    final message = jsonEncode({'type': 'subscribe', 'symbol': data});
    _channel.sink.add(message);
    _activeSubscriptions.add(data);
  }

  @override
  void unsubscribe(data) {
    final message = jsonEncode({'type': 'unsubscribe', 'symbol': data});
    _channel.sink.add(message);
    _activeSubscriptions.remove(data);
  }

  _resubscribeActiveSymbols(List<String>? initialSymbols) {
    final symbols = List.from(initialSymbols ?? _activeSubscriptions);
    _activeSubscriptions = [];
    for (var symbol in symbols) {
      subscribe(symbol);
    }
  }

  @override
  void resetSubscriptions() {
    for (var symbol in List.from(_activeSubscriptions)) {
      unsubscribe(symbol);
    }
    _activeSubscriptions = [];
  }

  /// Attempts to reconnect after a delay.
  void _reconnect(Function onMessageReceived) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!_connected) {
        connect(onMessageReceived);
      }
    });
  }

  /// Closes the WebSocket connection explicitly.
  @override
  void close() {
    _connected = false;
    _explicitlyClosed = true;
    _channel.sink.close();
    print('WebSocket closed explicitly.');
  }
}