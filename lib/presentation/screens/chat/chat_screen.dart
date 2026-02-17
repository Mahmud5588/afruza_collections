import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:web_socket_channel/web_socket_channel.dart";
import "package:image_picker/image_picker.dart";
import "package:file_picker/file_picker.dart";

import "../../../core/app_config.dart";
import "../../../core/ui_constants.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/di.dart";
import "../../../data/local/chat_storage.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.userId, this.userName});

  final String? userId;
  final String? userName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_ChatMessage> _messages = [];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final WebSocketChannel _channel;
  late final StreamSubscription _subscription;
  late final String _clientId;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _clientId = DateTime.now().millisecondsSinceEpoch.toString();
    _loadHistory();
    _connect();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    final storage = sl<ChatStorage>();
    final roomId = widget.userId ?? "admin";
    await storage.markAsRead(roomId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _channel.sink.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _connect() {
    try {
      // Convert HTTP(S) to WS(S) properly
      final wsBase = AppConfig.apiBaseUrl
          .replaceFirst("https://", "wss://")
          .replaceFirst("http://", "ws://");
      final roomId = widget.userId ?? "admin";

      // Properly construct WebSocket URL without port issues
      final wsUrl = "$wsBase/ws/chat/$roomId?client_id=$_clientId";

      // Parse URI carefully to avoid port issues
      final uri = Uri.parse(wsUrl);

      _channel = WebSocketChannel.connect(uri);
      _subscription = _channel.stream.listen(
        (event) {
          _handleIncoming(event);
        },
        onError: (error) {
          if (mounted) {
            setState(() => _connected = false);
          }
          // Optional: show error to user
          // _showMessage(_t("chat_failed"));
        },
        onDone: () {
          if (mounted) {
            setState(() => _connected = false);
          }
        },
      );
      setState(() => _connected = true);
    } catch (e) {
      // WebSocket connection xatosi - foydalanuvchiga xabar bermaslik
      if (mounted) {
        setState(() => _connected = false);
      }
    }
  }

  Future<void> _loadHistory() async {
    final storage = sl<ChatStorage>();
    final roomId = widget.userId ?? "admin";
    final saved = await storage.loadMessages(roomId: roomId);
    if (!mounted) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(saved.map(_ChatMessage.fromJson));
    });
  }

  void _handleIncoming(dynamic event) {
    if (event is! String) {
      return;
    }
    try {
      final data = jsonDecode(event) as Map<String, dynamic>;
      final sender = data["sender"]?.toString() ?? "";
      if (sender == _clientId) {
        return;
      }
      final type = data["type"]?.toString() ?? "text";
      final message = data["message"]?.toString() ?? "";
      final lat = (data["lat"] as num?)?.toDouble();
      final lng = (data["lng"] as num?)?.toDouble();
      final mediaUrl = data["media_url"]?.toString();
      final mediaType = data["media_type"]?.toString();
      final id = data["id"]?.toString() ??
          data["timestamp"]?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString();
      _addMessage(
        _ChatMessage(
          id: id,
          type: type,
          text: message,
          isMe: false,
          lat: lat,
          lng: lng,
          mediaUrl: mediaUrl,
          mediaType: mediaType,
        ),
      );
      // Don't increment unread count when chat is open
      // User is already viewing the message
    } catch (_) {
      _addMessage(_ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: event,
        isMe: false,
      ));
    }
  }

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    _controller.clear();
    _sendPayload({"type": "text", "message": text});
  }

  Future<void> _sendLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied) {
        _showMessage(_t("location_denied"));
        return;
      }
    }
    if (await Geolocator.isLocationServiceEnabled() == false) {
      _showMessage(_t("location_disabled"));
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _sendPayload({
      "type": "location",
      "message": _t("location_shared"),
      "lat": position.latitude,
      "lng": position.longitude,
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) return;

    // Mock mode: faqat file nomini saqlash, real upload yo'q
    _sendPayload({
      "type": "media",
      "message": _t("image_sent"),
      "media_url": result.path,
      "media_type": "image",
    });
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final result = await picker.pickVideo(source: ImageSource.gallery);
    if (result == null) return;

    _sendPayload({
      "type": "media",
      "message": _t("video_sent"),
      "media_url": result.path,
      "media_type": "video",
    });
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null || result.files.isEmpty) return;

    _sendPayload({
      "type": "media",
      "message": _t("audio_sent"),
      "media_url": result.files.first.path ?? "",
      "media_type": "audio",
    });
  }

  Future<void> _showAttachMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(_t("send_image")),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(_t("send_video")),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: Text(_t("send_audio")),
              onTap: () {
                Navigator.pop(context);
                _pickAudio();
              },
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(_t("send_location")),
              onTap: () {
                Navigator.pop(context);
                _sendLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendPayload(Map<String, dynamic> payload) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final message = <String, dynamic>{
      ...payload,
      "sender": _clientId,
      "id": id,
      "timestamp": DateTime.now().toIso8601String(),
    };
    _channel.sink.add(jsonEncode(message));
    _addMessage(
      _ChatMessage(
        id: id,
        type: payload["type"]?.toString() ?? "text",
        text: payload["message"]?.toString() ?? "",
        isMe: true,
        lat: payload["lat"] as double?,
        lng: payload["lng"] as double?,
        mediaUrl: payload["media_url"]?.toString(),
        mediaType: payload["media_type"]?.toString(),
      ),
    );
  }

  void _addMessage(_ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _persistMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _persistMessages() async {
    final storage = sl<ChatStorage>();
    final roomId = widget.userId ?? "admin";
    await storage.saveMessages(
      _messages.map((m) => m.toJson()).toList(),
      roomId: roomId,
    );
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName ?? t("chat"),
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.userId != null)
                            Text(
                              "User ID: ${widget.userId}",
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!_connected)
                      const Icon(Icons.wifi_off, size: 18)
                    else
                      const Icon(Icons.wifi, size: 18),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _ChatBubble(
                      message: message,
                      onToggleLike: () => _toggleLike(message.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _showAttachMenu,
                      icon: const Icon(Icons.attach_file),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendText(),
                        decoration: InputDecoration(
                          hintText: t("chat_input"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _sendText,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _t(String key) {
    return AppLocalizations.of(context).t(key);
  }

  void _toggleLike(String id) {
    final index = _messages.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    setState(() {
      final message = _messages[index];
      _messages[index] = message.copyWith(liked: !message.liked);
    });
    _persistMessages();
  }
}

class _ChatMessage {
  _ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    this.type = "text",
    this.lat,
    this.lng,
    this.liked = false,
    this.mediaUrl,
    this.mediaType,
  });

  final String id;
  final String text;
  final bool isMe;
  final String type;
  final double? lat;
  final double? lng;
  final bool liked;
  final String? mediaUrl;
  final String? mediaType; // "image", "video", "audio"

  _ChatMessage copyWith({
    bool? liked,
  }) {
    return _ChatMessage(
      id: id,
      text: text,
      isMe: isMe,
      type: type,
      lat: lat,
      lng: lng,
      liked: liked ?? this.liked,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "is_me": isMe,
      "type": type,
      "lat": lat,
      "lng": lng,
      "liked": liked,
      "media_url": mediaUrl,
      "media_type": mediaType,
    };
  }

  static _ChatMessage fromJson(Map<String, dynamic> json) {
    return _ChatMessage(
      id: json["id"]?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      text: json["text"] as String? ?? "",
      isMe: json["is_me"] as bool? ?? false,
      type: json["type"] as String? ?? "text",
      lat: (json["lat"] as num?)?.toDouble(),
      lng: (json["lng"] as num?)?.toDouble(),
      liked: json["liked"] as bool? ?? false,
      mediaUrl: json["media_url"] as String?,
      mediaType: json["media_type"] as String?,
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.onToggleLike});

  final _ChatMessage message;
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.isMe
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;
    final textColor = message.isMe
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Show media if available
            if (message.mediaType == "image" && message.mediaUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(message.mediaUrl!),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (message.mediaType == "video" && message.mediaUrl != null) ...[
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_outline,
                      size: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (message.mediaType == "audio" && message.mediaUrl != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.audiotrack, size: 24),
                    SizedBox(width: 8),
                    Text("Audio file"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                ),
                IconButton(
                  onPressed: onToggleLike,
                  iconSize: 18,
                  color: message.liked ? Colors.redAccent : textColor,
                  icon: Icon(
                    message.liked ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ],
            ),
            if (message.type == "location" &&
                message.lat != null &&
                message.lng != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "${message.lat!.toStringAsFixed(5)}, ${message.lng!.toStringAsFixed(5)}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: textColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
