import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

class ChatStorage {
  ChatStorage(this.prefs);

  final SharedPreferences prefs;

  static const _messagesKeyPrefix = "chat_messages_";

  Future<List<Map<String, dynamic>>> loadMessages(
      {String roomId = "default"}) async {
    final key = "$_messagesKeyPrefix$roomId";
    final raw = prefs.getStringList(key) ?? [];
    return raw.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  Future<void> saveMessages(List<Map<String, dynamic>> messages,
      {String roomId = "default"}) async {
    final key = "$_messagesKeyPrefix$roomId";
    final raw = messages.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList(key, raw);
  }

  Future<List<String>> getChatRooms() async {
    final keys = prefs.getKeys();
    return keys
        .where((key) => key.startsWith(_messagesKeyPrefix))
        .map((key) => key.replaceFirst(_messagesKeyPrefix, ""))
        .toList();
  }

  Future<int> getUnreadCount(String roomId) async {
    // Mock implementation - real uygulamada unread flagini saqlash kerak
    final messages = await loadMessages(roomId: roomId);
    return messages.length > 0 ? 1 : 0;
  }
}
