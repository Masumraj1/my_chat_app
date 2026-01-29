import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

final chatProvider = AsyncNotifierProvider<ChatNotifier, List<MessageModel>>(() {
  return ChatNotifier();
});

class ChatNotifier extends AsyncNotifier<List<MessageModel>> {
  late WebSocketChannel _channel;
  final String _myUserId = "masum";
  final String _targetUserId = "postman";
  final String _baseUrl = "192.168.10.167:8080";

  @override
  FutureOr<List<MessageModel>> build() async {
    final history = await _fetchHistory();
    _initSocket();
    return history;
  }

  Future<List<MessageModel>> _fetchHistory() async {
    try {
      final response = await http.get(Uri.parse('http://$_baseUrl/messages/history'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // ডাটাবেস থেকে আসা লিস্ট যদি পুরানো থেকে নতুন ক্রমে থাকে (Ascending)
        return data.map((msg) => MessageModel(
          text: msg['message'] ?? '',
          isMe: msg['from'] == _myUserId,
          time: _formatTime(msg['timestamp']),
        )).toList();
      }
    } catch (e) {
      debugPrint('❌ History Error: $e');
    }
    return [];
  }

  void _initSocket() {
    try {
      // ===========>> 1. Establish WebSocket Connection <<===========
      // Connects to the server using the provided Base URL and /chat endpoint
      _channel = WebSocketChannel.connect(Uri.parse('ws://$_baseUrl/chat'));
      debugPrint('🌐 Connecting to Server: ws://$_baseUrl/chat');

      // ===========>> 2. Send Join Request <<===========
      // Immediately notify the server that this specific user has joined the session
      _channel.sink.add(jsonEncode({
        'type': 'join',
        'userId': _myUserId
      }));
      debugPrint('👤 Join request sent for User ID: $_myUserId');

      // ===========>> 3. Start Listening to Stream <<===========
      // Constantly listen for incoming data from the server
      _channel.stream.listen(
            (rawData) {
          final data = jsonDecode(rawData.toString());
          debugPrint('📩 New data packet received from server');

          // Check if the received data type is a new message
          if (data['type'] == 'new_message') {
            final newMessage = MessageModel(
              text: data['message'] ?? '',
              isMe: data['from'] == _myUserId,
              time: _formatTime(data['timestamp']),
            );

            // Update the UI state by appending the new message to the existing list
            final previousState = state.value ?? [];
            state = AsyncData([...previousState, newMessage]);
          }
        },
        onError: (error) {
          // Triggered if there is a network failure or handshake error
          debugPrint('❌ Connection Error: $error');
        },
        onDone: () {
          // Triggered when the server closes the connection or the client disconnects
          debugPrint('🔌 Connection Closed. Please re-check server status.');
        },
      );
    } catch (e) {
      // Catching any initialization or unexpected runtime errors
      debugPrint('⚠️ Initialization Error: $e');
    }
  }


  Future<void> addMessage(String text) async {
    _channel.sink.add(jsonEncode({
      'type': 'message',
      'from': _myUserId,
      'to': _targetUserId,
      'message': text,
    }));
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return "${DateTime.now().hour}:${DateTime.now().minute}";
    try {
      final date = DateTime.parse(timestamp.toString());
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "${DateTime.now().hour}:${DateTime.now().minute}";
    }
  }
}