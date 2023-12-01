import 'package:Serve_ios/src/models/user.dart';

class Notification {
  int _id;
  int _senderId;
  User _getSender;
  int _adsId;
  int _type;
  String _message;
  String _createdAt;

  int get id => _id;
  int get senderId => _senderId;
  User get getSender => _getSender;
  int get adsId => _adsId;
  int get type => _type;
  String get message => _message;
  String get createdAt => _createdAt;

  Notification(this._id, this._senderId, this._getSender, this._adsId,
      this._type, this._message, this._createdAt);

  Notification.map(dynamic obj) {
    this._id = obj["id"];
    this._senderId = obj["sender_id"];
    this._getSender =
        obj["get_sender"] == null ? null : User.fromJson(obj["get_sender"]);
    this._adsId = obj["ads_id"];
    this._type = obj["type"];
    this._message = obj["message"];
    this._createdAt = obj["created_at"];
//    _getSender.(_senderId);
  }

  Notification.fromPush(dynamic obj) {
    this._adsId = obj['notification_data'] == null
        ? null
        : (obj['notification_data']["ads_id"] is String
            ? int.parse(obj['notification_data']["ads_id"])
            : obj['notification_data']["ads_id"]);
    this._id = obj['notification_data'] == null
        ? null
        : obj['notification_data']["id"];
    this._senderId = obj['notification_data'] == null
        ? null
        : obj['notification_data']["user_id"];
    this._getSender = obj['notification_data'] == null
        ? null
        : obj['notification_data']['get_sender'] == null
            ? null
            : User.fromJson(obj['notification_data']['get_sender']);
    this._senderId = _senderId == null
        ? _getSender == null
            ? 0
            : _getSender.id
        : _senderId;
    this._message = obj["notification_message"];
    this._createdAt = obj['notification_data'] == null
        ? null
        : obj['notification_data']["created_at"];
    this._type = obj["notification_type"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["senderId"] = _senderId;
    map["getSender"] = _getSender;
    map["adsId"] = _adsId;
    map["type"] = _type;
    map["message"] = _message;
    map["createdAt"] = _createdAt;
    return map;
  }
}
