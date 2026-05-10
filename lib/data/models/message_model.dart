/// NicheSphere — Message Model (Section 4)
class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String content;
  final MessageType type;
  final String? imageUrl;
  final DateTime sentAt;
  final List<String> readBy;
  final Map<String, String> reactions;

  const MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.content,
    this.type = MessageType.text,
    this.imageUrl,
    required this.sentAt,
    this.readBy = const [],
    this.reactions = const {},
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      chatRoomId: json['chatRoomId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      content: json['content'] as String? ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      imageUrl: json['imageUrl'] as String?,
      sentAt: DateTime.parse(json['sentAt'] as String),
      readBy: List<String>.from(json['readBy'] ?? []),
      reactions: Map<String, String>.from(json['reactions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatRoomId': chatRoomId,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatarUrl': senderAvatarUrl,
        'content': content,
        'type': type.name,
        'imageUrl': imageUrl,
        'sentAt': sentAt.toIso8601String(),
        'readBy': readBy,
        'reactions': reactions,
      };
}

enum MessageType { text, image, eventShare, system }
