
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chat_controller.dart';
import '../models/message_model.dart';

final chatProvider = AsyncNotifierProvider<ChatNotifier, List<MessageModel>>(() {
  return ChatNotifier();
});

