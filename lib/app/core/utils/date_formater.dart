String formatTime(dynamic timestamp) {
  if (timestamp == null) return "${DateTime.now().hour}:${DateTime.now().minute}";
  try {
    final date = DateTime.parse(timestamp.toString());
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  } catch (e) {
    return "${DateTime.now().hour}:${DateTime.now().minute}";
  }
}