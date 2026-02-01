import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_chat_app/app/core/constants/app_colors.dart';
import 'package:my_chat_app/app/core/constants/app_strings.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/chat_input_field.dart';
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
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ChatBubble(
                      message: msg.text,
                      time: msg.time,
                      isMe: msg.isMe,
                      // myBubbleColor: Colors.green,
                    );
                  },
                ),
              ),

              //==============Message Input Field=========

              ChatInputField(
                controller: _controller,
                onSend: _sendMessage,
                // hintText: "Write a message...",
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 50.sp, color: Colors.red),
              SizedBox(height: 10.h),
              Text("সার্ভারের সাথে কানেক্ট করা যাচ্ছে না"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // বাটনের ব্যাকগ্রাউন্ড কালার
                  foregroundColor: Colors.white,      // টেক্সট এবং আইকনের কালার
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r), // কর্নার রাউন্ড করার জন্য
                  ),
                ),                onPressed: () => ref.invalidate(chatProvider), // আবার চেষ্টা করার জন্য
                child: const Text("Retry"),
              )
            ],
          ),
        ),
        // error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }

}