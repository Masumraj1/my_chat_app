import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  // একদম নিচে স্ক্রল করার লজিক
  void _scrollToBottom() {
    // WidgetsBinding ব্যবহার করা হয়েছে যেন ফ্রেম রেন্ডার হওয়ার পর স্ক্রল হয়
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      ref.read(chatProvider.notifier).addMessage(_controller.text);
      _controller.clear();
      // নিজের মেসেজ পাঠানোর সাথে সাথে নিচে স্ক্রল
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    // রিভারপড স্টেট লিসেনার: নতুন কোনো মেসেজ যোগ হলেই অটো স্ক্রল হবে
    ref.listen(chatProvider, (previous, next) {
      _scrollToBottom();
    });

    final chatAsync = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat Master", style: TextStyle(fontSize: 20.sp, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: chatAsync.when(
        data: (messages) {
          // হিস্টোরি লোড হওয়ার পর প্রথমবার নিচে যাওয়ার জন্য
          if (messages.isNotEmpty) _scrollToBottom();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // কন্ট্রোলার যুক্ত করা হয়েছে
                  padding: EdgeInsets.all(15.w),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),
              _buildInputArea(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }

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