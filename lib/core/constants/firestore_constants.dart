class FirestoreConstants {
  FirestoreConstants._();

  // ── Collections ──
  static const String users = 'users';
  static const String forums = 'forums';
  static const String forumMembers = 'forum_members';
  static const String chatRooms = 'chat_rooms';
  static const String messages = 'messages';
  static const String stories = 'stories';
  static const String notifications = 'notifications';

  // ── Sub-collections ──
  static const String members = 'members';
  static const String items = 'items';
  static const String viewers = 'viewers';

  // ── User Fields ──
  static const String uid = 'uid';
  static const String name = 'name';
  static const String email = 'email';
  static const String avatarUrl = 'avatarUrl';
  static const String forumIds = 'forumIds';
  static const String badgeStatus = 'badgeStatus';
  static const String isForumHead = 'isForumHead';
  static const String forumHeadOf = 'forumHeadOf';
  static const String birthday = 'birthday';
  static const String formFilled = 'formFilled';
  static const String duesPaid = 'duesPaid';
  static const String role = 'role';
  static const String fcmToken = 'fcmToken';
  static const String createdAt = 'createdAt';
  static const String phone = 'phone';
  static const String department = 'department';
  static const String level = 'level';
  static const String bio = 'bio';

  // ── Forum Fields ──
  static const String forumName = 'name';
  static const String forumDescription = 'description';
  static const String forumHeadUserId = 'headUserId';
  static const String forumCreatedBy = 'createdBy';
  static const String forumCreatedAt = 'createdAt';
  static const String forumChatRoomId = 'chatRoomId';
  static const String forumMemberCount = 'memberCount';
  static const String forumIconUrl = 'iconUrl';

  // ── Chat Room Fields ──
  static const String roomName = 'name';
  static const String roomType = 'type';
  static const String roomForumId = 'forumId';
  static const String roomLastMessage = 'lastMessage';
  static const String roomLastMessageTime = 'lastMessageTime';
  static const String roomLastMessageSenderId = 'lastMessageSenderId';
  static const String roomMembers = 'members';

  // ── Message Fields ──
  static const String messageSenderId = 'senderId';
  static const String messageSenderName = 'senderName';
  static const String messageSenderAvatar = 'senderAvatar';
  static const String messageContent = 'content';
  static const String messageType = 'type';
  static const String messageMediaUrl = 'mediaUrl';
  static const String messageCreatedAt = 'createdAt';
  static const String messageReadBy = 'readBy';
  static const String messageDuration = 'duration'; // for voice notes

  // ── Story Fields ──
  static const String storyUserId = 'userId';
  static const String storyUserName = 'userName';
  static const String storyUserAvatar = 'userAvatar';
  static const String storyMediaUrl = 'mediaUrl';
  static const String storyCaption = 'caption';
  static const String storyType = 'type';
  static const String storyCreatedAt = 'createdAt';
  static const String storyExpiresAt = 'expiresAt';
  static const String storyViewers = 'viewers';

  // ── Notification Fields ──
  static const String notificationType = 'type';
  static const String notificationPayload = 'payload';
  static const String notificationRead = 'read';
  static const String notificationCreatedAt = 'createdAt';
  static const String notificationTitle = 'title';
  static const String notificationBody = 'body';

  // ── Badge Status Values ──
  static const String badgeNone = 'none';       // form not filled
  static const String badgeGrey = 'grey';       // form filled, dues not paid
  static const String badgeGold = 'gold';       // form filled, dues paid, admin verified

  // ── Role Values ──
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';
  static const String roleForumHead = 'forum_head';

  // ── Room Type Values ──
  static const String roomTypeGeneral = 'general';
  static const String roomTypeForum = 'forum';

  // ── Message Type Values ──
  static const String messageTypeText = 'text';
  static const String messageTypeVoice = 'voice';
  static const String messageTypeImage = 'image';

  // ── Story Type Values ──
  static const String storyTypeImage = 'image';
  static const String storyTypeText = 'text';

  // ── Notification Type Values ──
  static const String notificationTypeBirthday = 'birthday';
  static const String notificationTypeSabbath = 'sabbath';
  static const String notificationTypeDailyVerse = 'daily_verse';
  static const String notificationTypeVerification = 'verification';
  static const String notificationTypeNewMember = 'new_member';
  static const String notificationTypeGeneral = 'general';

  // ── Special Room IDs ──
  static const String generalChatRoomId = 'general_chat_room';
}