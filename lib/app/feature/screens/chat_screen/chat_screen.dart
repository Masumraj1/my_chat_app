import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_chat_app/app/core/constants/app_strings.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }


  //===============SendMessage Method========
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      ref.read(chatProvider.notifier).addMessage(_controller.text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(chatProvider, (previous, next) {
      _scrollToBottom();
    });

    final chatAsync = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      //===========Appbar==========
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.chatMaster, style: TextStyle(fontSize: 20.sp, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: chatAsync.when(
        data: (messages) {

          if (messages.isNotEmpty) _scrollToBottom();

          return Column(
            children: [

              //=============Message List===========
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(15.w),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),

              //==============Message Input Field=========
              _buildInputArea(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }


  //==============BubbleMessage Design============
  Widget _buildMessageBubble(msg) {
    bool isMe = msg.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                  bottomLeft: isMe ? Radius.circular(15.r) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(15.r),
                ),
              ),
              child: Text(
                msg.text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 4.h),
            Text(msg.time, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
          ],
        ),
      ),
    );
  }


  //==================Type Message Design============
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "মেসেজ লিখুন...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r), borderSide: BorderSide.none),
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.send, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}