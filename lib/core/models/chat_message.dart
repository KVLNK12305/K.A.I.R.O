class ChatMessage {
  String text;
  bool isUser;
  String? attachmentPath;
  String? attachmentType; // 'image', 'pdf', 'file'
  String? base64Data;

  ChatMessage(
    this.text,
    this.isUser, {
    this.attachmentPath,
    this.attachmentType,
    this.base64Data,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'attachmentPath': attachmentPath,
    'attachmentType': attachmentType,
    'base64Data': base64Data,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    json['text'] as String? ?? '',
    json['isUser'] as bool? ?? false,
    attachmentPath: json['attachmentPath'] as String?,
    attachmentType: json['attachmentType'] as String?,
    base64Data: json['base64Data'] as String?,
  );
}

class ChatSession {
  String id;
  String title;
  DateTime updatedAt;
  List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'updatedAt': updatedAt.toIso8601String(),
    'messages': messages.map((m) => m.toJson()).toList(),
  };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
    title: json['title'] as String? ?? 'Untitled Session',
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    messages: (json['messages'] as List<dynamic>? ?? [])
        .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
        .toList(),
  );
}
