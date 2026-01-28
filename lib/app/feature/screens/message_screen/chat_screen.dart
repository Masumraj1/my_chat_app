import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // রিভারপড ইমপোর্ট
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget { // ConsumerStatefulWidget ব্যবহার করুন
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> { // ConsumerState ব্যবহার করুন
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      // Riverpod-এর প্রোভাইডার কল করে মেসেজ অ্যাড করা
      ref.read(chatProvider.notifier).addMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // এখানে আমরা মেসেজ লিস্টটি "ওয়াচ" (watch) করছি
    final messages = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Chat Master", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 60.h,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15.w),
              itemCount: messages.length, // রিভারপড থেকে আসা লিস্ট
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // বাবল এবং ইনপুট এরিয়া আপনার আগের কোডই থাকবে, শুধু ডাটা আসবে রিভারপড থেকে
  Widget _buildMessageBubble(msg) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 0.75.sw),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: msg.isMe ? Colors.blueAccent : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
                bottomLeft: msg.isMe ? Radius.circular(15.r) : Radius.circular(0),
                bottomRight: msg.isMe ? Radius.circular(0) : Radius.circular(15.r),
              ),
            ),
            child: Text(
              msg.text,
              style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87, fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 4.h),
          Text(msg.time, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "মেসেজ লিখুন...",
                fillColor: const Color(0xFFEEEEEE),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          IconButton(
            onPressed: _sendMessage,
            icon: CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.send, color: Colors.white, size: 20.r)),
          ),
        ],
      ),
    );
  }
}