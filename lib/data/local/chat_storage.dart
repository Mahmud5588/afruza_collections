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
    final key = "chat_unread_$roomId";
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setUnreadCount(String roomId, int count) async {
    final key = "chat_unread_$roomId";
    await prefs.setInt(key, count);
  }

  Future<void> incrementUnreadCount(String roomId) async {
    final current = await getUnreadCount(roomId);
    await setUnreadCount(roomId, current + 1);
  }

  Future<void> markAsRead(String roomId) async {
    await setUnreadCount(roomId, 0);
  }

  Future<int> getTotalUnreadCount() async {
    final rooms = await getChatRooms();
    int total = 0;
    for (final room in rooms) {
      total += await getUnreadCount(room);
    }
    return total;
  }
}
