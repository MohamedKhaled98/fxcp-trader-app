import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FinnhubWebSocket {
  bool _connected = false;
  bool _explicitlyClosed = false;
  List<String> _activeSubscriptions = [];
  late WebSocketChannel _channel;

  /// Connects to the WebSocket server. Only allows a single connection.
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
          print('Message received: ${jsonDecode(message)['type']}');
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

  void _emitSubscribtionEvent(String type, String symbol) {
    final message = jsonEncode({'type': type, 'symbol': symbol});
    _channel.sink.add(message);
  }

  _resubscribeActiveSymbols(List<String>? initialSymbols) {
    final symbols = _activeSubscriptions.isNotEmpty
        ? _activeSubscriptions
        : (initialSymbols ?? []);

    for (var symbol in symbols) {
      _emitSubscribtionEvent('subscribe', symbol);
    }
  }

  changeSubscriptions(List<String> newSymbols) {
    for (var symbol in _activeSubscriptions) {
      _emitSubscribtionEvent('unsubscribe', symbol);
    }
    _activeSubscriptions = [];
    addSubscriptions(newSymbols);
  }

  void addSubscriptions(List<String> symbols) {
    if (_connected) {
      for (var symbol in symbols) {
        if (!_activeSubscriptions.contains(symbol)) {
          _emitSubscribtionEvent('subscribe', symbol);
        }
      }
      _activeSubscriptions.addAll(symbols);
    }
  }

  void removeSubscriptions(List<String> symbols) {
    if (_connected) {
      for (var symbol in symbols) {
        if (_activeSubscriptions.contains(symbol)) {
          _emitSubscribtionEvent('unsubscribe', symbol);
          _activeSubscriptions.remove(symbol);
        }
      }
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

  /// Attempts to reconnect after a delay.
  void _reconnect(Function onMessageReceived) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!_connected) {
        connect(onMessageReceived);
      }
    });
  }

  /// Closes the WebSocket connection explicitly.
  void close() {
    _connected = false;
    _explicitlyClosed = true;
    _channel.sink.close();
    print('WebSocket closed explicitly.');
  }
}
