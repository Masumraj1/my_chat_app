import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_chat_app/app/core/constants/app_colors.dart';
import 'package:my_chat_app/app/core/constants/app_strings.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();


  //==============Send Message Function===========
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      debugPrint("My Message: ${_controller.text}");
      ref.read(chatProvider.notifier).addMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: AppColors.white,

      //==============AppBar=============
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppStrings.chatMaster,
          style: TextStyle(fontSize: 20.sp, color: AppColors.white),
        ),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 60.h,
      ),

      body: chatAsync.when(
        data: (messages) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(15.w),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(messages[index]);
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),

        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }

 //================Bubble Design =============
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


  //===============Input Message Filed ============
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: const BoxDecoration(color: Colors.white),
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

          //==============Message Send Button============
          IconButton(
            onPressed: _sendMessage,
            icon: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.send, color: Colors.white, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }
}