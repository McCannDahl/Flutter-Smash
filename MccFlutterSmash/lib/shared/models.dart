import 'dart:convert';

class SocketMessage {
  SocketAction action;
  dynamic value;

  SocketMessage(SocketAction a, dynamic v) {
    action = a;
    value = v;
  }

  SocketMessage.fromString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    action = SocketAction.values.firstWhere((e) => e.toString() == json['action']);
    value = json['value'];
  }

  Map<String, dynamic> tojson() {
    return {
      'action': action.toString(),
      'value': value
    };
  }

  @override
  String toString() {
    return jsonEncode(tojson());
  }
}

enum SocketAction {
  PleaseSendName,
  AddUser,
  UserAdded,
  Reconnected,
  RemoveMe,
  UserInfo,
  GameInfo
}

enum SocketResponse {
  UserAdded,
  NameInUse
}

class UserInfo {
  String name;
  UserInfo({this.name});
  UserInfo.fromString(jsonString){
    Map<String, dynamic> json = jsonDecode(jsonString);
    this.name = json['name'];
  }
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
  };
}

class GameInfo {
  String name;

  GameInfo({this.name});
  GameInfo.fromString(jsonString){
    Map<String, dynamic> json = jsonDecode(jsonString);
    this.name = json['name'];
  }

  @override
  String toString() {
    return jsonEncode({
      'name': name
    });
  }
}