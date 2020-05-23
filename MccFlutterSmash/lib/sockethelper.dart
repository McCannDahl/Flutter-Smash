import 'dart:io';
import 'package:flutter/material.dart';
import 'package:MccFlutterSmash/lobby.dart';
import 'package:MccFlutterSmash/shared/models.dart';

class SocketHelper {
  Socket socket;
  String ip;
  int port;
  String name;
  BuildContext context;

  List<UserInfo> userInfos;
  GameInfo gameInfo;

  SocketHelper(BuildContext this.context) {
    print('socketHelper constructor');
  }

  void tryToConnect(String ip, int port, String name) {
    print('tryToConnect ${ip}:${port} ${name}');
    this.ip = ip;
    this.port = port;
    this.name = name;
    try {
      Socket.connect(ip, port)
      .then((Socket sock) {
        socket = sock;
        socket.listen(dataHandler, 
          onError: errorHandler, 
          onDone: doneHandler, 
          cancelOnError: false);
      })
      .catchError((Object e) {
        print('Unable to connect: $e');
        showError('Server not running');
      });
    } catch (exception) {
      showError('Server not running');
      print(exception);
    }
  }

  void tryToReconnect() {
    print('tryToReconnect ${ip}:${port} ${name}');
    Socket.connect(ip, port)
      .then((Socket sock) {
        socket = sock;
        socket.listen(dataHandler, 
          onError: errorHandler, 
          onDone: doneHandler, 
          cancelOnError: false);
      })
      .catchError((Object e) {
        print('Unable to connect: $e');
        showError('Server not running');
      });
  }

  void showError(String err) {
    if (context != null) {
      final snackBar = SnackBar(content: Text(err));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void goToLobby() {
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LobbyScreen(socketHelper: this),
        ),
      );
    }
  }

  void dataHandler(data) {
    SocketMessage sm = SocketMessage.fromString(String.fromCharCodes(data).trim());
    print('recieved ${sm}');
    switch(sm.action) { 
      case SocketAction.PleaseSendName: { 
        print("sendName");
        socket.write(SocketMessage(SocketAction.AddUser,name));
      } 
      break;
      case SocketAction.UserAdded: { 
        // bool userAdded = sm.value.toLowerCase() == 'true';
        if (sm.value) {
          goToLobby();
        } else {
          // name taken
          showError('Name taken.');
        }
      } 
      break;
      case SocketAction.UserInfo: { 
        print("UserInfo");
        List<dynamic> dlist = sm.value;
        userInfos = dlist.map((e) =>  UserInfo.fromString(e));
        print(userInfos);
      } 
      break;
      case SocketAction.GameInfo: { 
        gameInfo = GameInfo.fromString(sm.value);
      } 
      break;

      default: { 
          //statements;  
      }
      break; 
    } 
  }

  void errorHandler(error, StackTrace trace){
    print("errorHandler");
    print(error);
    showError('Socket error');
  }

  void doneHandler(){
    print("doneHandler");
    socket.destroy();
  }

  void dispose() {
    print("dispose");
    socket.destroy();
  }

  void leaveLobby() {
    socket.write(SocketMessage(SocketAction.RemoveMe,null));
  }


}
