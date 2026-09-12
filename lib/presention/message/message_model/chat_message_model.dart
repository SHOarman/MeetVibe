class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    String sId = '';
    String sName = 'Unknown User';
    String sAvatar = '';
    
    if (json['sender'] is Map) {
      sId = json['sender']['id'] ?? json['sender']['_id'] ?? '';
      sName = json['sender']['name'] ?? json['sender']['username'] ?? 'Unknown User';
      sAvatar = json['sender']['image'] ?? json['sender']['profileImage'] ?? '';
    } else {
      sId = json['sender']?.toString() ?? '';
    }

    return ChatMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      senderId: sId,
      senderName: sName,
      senderAvatar: sAvatar,
      content: json['message'] ?? json['content'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isRead: json['isRead'] == true || json['isRead'] == 'true',
    );
  }
}
