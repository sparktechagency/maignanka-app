
class ConversationModelData {
  String? sId;
  String? updatedAt;
  String? participantName;
  String? participantEmail;
  String? receiverID;
  String? profilePicture;
  String? lastMessage;
  String? lastMessageCreatedAt;
  String? messageType;
  String? lastActive;

  ConversationModelData(
      {this.sId,
        this.updatedAt,
        this.participantName,
        this.participantEmail,
        this.receiverID,
        this.profilePicture,
        this.lastMessage,
        this.lastMessageCreatedAt,
        this.messageType,
        this.lastActive});

  ConversationModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    participantName = json['participantName'];
    participantEmail = json['participantEmail'];
    receiverID = json['receiverID'];
    profilePicture = json['profilePicture'];
    lastMessage = json['lastMessage'];
    lastMessageCreatedAt = json['lastMessageCreatedAt'];
    messageType = json['messageType'];
    lastActive = json['lastActive'];
  }
}
