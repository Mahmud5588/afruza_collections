import "package:flutter/material.dart";

import "../../../core/ui_constants.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/di.dart";
import "../../../data/local/chat_storage.dart";
import "chat_screen.dart";

/// Admin uchun barcha chat xonalarini ko'rsatuvchi ekran
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<_ChatRoom> _rooms = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() => _loading = true);
    final storage = sl<ChatStorage>();
    final roomIds = await storage.getChatRooms();

    final rooms = <_ChatRoom>[];
    for (final roomId in roomIds) {
      final messages = await storage.loadMessages(roomId: roomId);
      final lastMessage = messages.isNotEmpty ? messages.last : null;
      final unreadCount = await storage.getUnreadCount(roomId);

      rooms.add(_ChatRoom(
        userId: roomId,
        userName: "User $roomId",
        lastMessage: lastMessage?["text"]?.toString() ?? "No messages",
        lastMessageTime: lastMessage != null
            ? DateTime.tryParse(lastMessage["timestamp"]?.toString() ?? "")
            : null,
        unreadCount: unreadCount,
      ));
    }

    // Mock: Agar xonalar bo'lmasa, test uchun qo'shamiz (faqat development uchun)
    if (rooms.isEmpty) {
      // Demo user chats
      rooms.addAll([
        _ChatRoom(
          userId: "demo_user_1",
          userName: "Alisher Usmonov",
          lastMessage: "Assalomu alaykum, buyurtmam qachon yetib keladi?",
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
          unreadCount: 0, // Backend'dan kelganidan keyin to'g'ri count bo'ladi
        ),
        _ChatRoom(
          userId: "demo_user_2",
          userName: "Dilnoza Karimova",
          lastMessage: "Mahsulot juda yoqdi, rahmat!",
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
          unreadCount: 0,
        ),
        _ChatRoom(
          userId: "demo_user_3",
          userName: "Bobur Ergashev",
          lastMessage: "Yana ranglari bormi?",
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
          unreadCount: 0,
        ),
      ]);
    }

    setState(() {
      _rooms = rooms;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(
                      t("chat_list_title"),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _loadRooms,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _rooms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  t("no_chats"),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg),
                            itemCount: _rooms.length,
                            itemBuilder: (context, index) {
                              final room = _rooms[index];
                              return _ChatRoomTile(
                                room: room,
                                onTap: () => _openChat(room),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(_ChatRoom room) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: room.userId,
          userName: room.userName,
        ),
      ),
    );
    // Reload rooms to update unread counts
    _loadRooms();
  }
}

class _ChatRoom {
  const _ChatRoom({
    required this.userId,
    required this.userName,
    required this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  final String userId;
  final String userName;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
}

class _ChatRoomTile extends StatelessWidget {
  const _ChatRoomTile({required this.room, required this.onTap});

  final _ChatRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeStr =
        room.lastMessageTime != null ? _formatTime(room.lastMessageTime!) : "";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(
                  room.userName.isNotEmpty
                      ? room.userName[0].toUpperCase()
                      : "?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.userName,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (timeStr.isNotEmpty)
                          Text(
                            timeStr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.lastMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (room.unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              room.unreadCount > 9
                                  ? "9+"
                                  : room.unreadCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return "Hozir";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min oldin";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} soat oldin";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} kun oldin";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
}
