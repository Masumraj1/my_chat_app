import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // প্যাকেজ ইমপোর্ট
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  // আপনার আগের স্ট্যাটিক মেসেজ লিস্ট
  final List<MessageModel> _messages = [
    MessageModel(text: "আসসালামু আলাইকুম, কেমন আছেন?", isMe: false, time: "10:10 AM"),
    MessageModel(text: "ওয়ালাইকুম আসসালাম, ভালো। আপনি?", isMe: true, time: "10:11 AM"),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          MessageModel(
            text: _controller.text,
            isMe: true,
            time: "${DateTime.now().hour}:${DateTime.now().minute}",
          ),
        );
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil ইন্টিগ্রেট করা থাকলেও মেইন ফাইলে থাকে, এখানে সাইজগুলো ডাইনামিক হবে
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Chat Master", style: TextStyle(fontSize: 20.sp)), // স্পি ফন্ট সাইজ
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 60.h, // রেসপনসিভ হাইট
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15.w), // রেসপনসিভ প্যাডিং
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h), // ৫ পিক্সেল হাইট অনুযায়ী অ্যাডজাস্ট হবে
      child: Column(
        crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 0.75.sw, // স্ক্রিন উইডথ এর ৭৫% (sw = screen width)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: msg.isMe ? Colors.blueAccent : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r), // r = radius
                topRight: Radius.circular(15.r),
                bottomLeft: msg.isMe ? Radius.circular(15.r) : Radius.circular(0),
                bottomRight: msg.isMe ? Radius.circular(0) : Radius.circular(15.r),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 2.r, offset: Offset(0, 2.h)),
              ],
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                color: msg.isMe ? Colors.white : Colors.black87,
                fontSize: 16.sp, // ফন্ট সাইজ রেসপনসিভ
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            msg.time,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5.r)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: "মেসেজ লিখুন...",
                hintStyle: TextStyle(fontSize: 14.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color(0xFFEEEEEE),
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              radius: 22.r, // সার্কেল সাইজ রেসপনসিভ
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.send, color: Colors.white, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }
}