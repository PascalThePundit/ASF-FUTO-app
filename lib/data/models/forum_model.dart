import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_constants.dart';

class ForumModel {
  final String id;
  final String name;
  final String description;
  final String? headUserId;
  final String createdBy;
  final DateTime createdAt;
  final String chatRoomId;
  final int memberCount;
  final String? iconUrl;

  const ForumModel({
    required this.id,
    required this.name,
    required this.description,
    this.headUserId,
    required this.createdBy,
    required this.createdAt,
    required this.chatRoomId,
    this.memberCount = 0,
    this.iconUrl,
  });

  factory ForumModel.fromMap(String id, Map<String, dynamic> map) {
    return ForumModel(
      id: id,
      name: map[FirestoreConstants.forumName] ?? '',
      description: map[FirestoreConstants.forumDescription] ?? '',
      headUserId: map[FirestoreConstants.forumHeadUserId],
      createdBy: map[FirestoreConstants.forumCreatedBy] ?? '',
      createdAt: map[FirestoreConstants.forumCreatedAt] != null
          ? (map[FirestoreConstants.forumCreatedAt] as Timestamp).toDate()
          : DateTime.now(),
      chatRoomId: map[FirestoreConstants.forumChatRoomId] ?? '',
      memberCount: map[FirestoreConstants.forumMemberCount] ?? 0,
      iconUrl: map[FirestoreConstants.forumIconUrl],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.forumName: name,
      FirestoreConstants.forumDescription: description,
      FirestoreConstants.forumHeadUserId: headUserId,
      FirestoreConstants.forumCreatedBy: createdBy,
      FirestoreConstants.forumCreatedAt: Timestamp.fromDate(createdAt),
      FirestoreConstants.forumChatRoomId: chatRoomId,
      FirestoreConstants.forumMemberCount: memberCount,
      FirestoreConstants.forumIconUrl: iconUrl,
    };
  }

  ForumModel copyWith({
    String? id,
    String? name,
    String? description,
    String? headUserId,
    String? createdBy,
    DateTime? createdAt,
    String? chatRoomId,
    int? memberCount,
    String? iconUrl,
  }) {
    return ForumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      headUserId: headUserId ?? this.headUserId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      memberCount: memberCount ?? this.memberCount,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ForumModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ForumModel(id: $id, name: $name)';
}