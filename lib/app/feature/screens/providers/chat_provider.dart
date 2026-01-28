import 'package:flutter_riverpod/legacy.dart';

import '../models/message_model.dart';

// এই প্রোভাইডারটি আমাদের মেসেজ লিস্ট ধরে রাখবে
final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<MessageModel>> {
  ChatNotifier() : super([
    // প্রাথমিক কিছু মেসেজ
    MessageModel(text: "আসসালামু আলাইকুম", isMe: false, time: "10:10 AM"),
    MessageModel(text: "ওয়ালাইকুম আসসালাম", isMe: true, time: "10:11 AM"),
  ]);

  // নতুন মেসেজ যোগ করার ফাংশন
  void addMessage(String text) {
    final newMessage = MessageModel(
      text: text,
      isMe: true,
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
    );
    // রিভারপড-এ স্টেট আপডেট করার নিয়ম: আগের লিস্ট + নতুন মেসেজ
    state = [...state, newMessage];
  }
}