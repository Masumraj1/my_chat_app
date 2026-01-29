import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';


final chatProvider = AsyncNotifierProvider<ChatNotifier, List<MessageModel>>(() {
  return ChatNotifier();
});



class ChatNotifier extends AsyncNotifier<List<MessageModel>> {

  @override
  FutureOr<List<MessageModel>> build() async {
    return [
      MessageModel(text: "আসসালামু আলাইকুম", isMe: false, time: "10:10 AM"),
      MessageModel(text: "ওয়ালাইকুম আসসালাম", isMe: true, time: "10:11 AM"),
    ];
  }

  //================Message Add Function============
  Future<void> addMessage(String text) async {
    final previousState = await future;

    final newMessage = MessageModel(
      text: text,
      isMe: true,
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
    );

    // ৩. স্টেট আপডেট করা (AsyncNotifier-এ সরাসরি state.value দেওয়া যায় না)
    state = AsyncData([...previousState, newMessage]);

    // ৪. এখানে আপনি ভবিষ্যতে সকেটে মেসেজ পাঠানোর লজিক লিখবেন
  }
}