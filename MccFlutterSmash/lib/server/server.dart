import 'dart:convert';
import 'dart:io';

import 'package:MccFlutterSmash/shared/models.dart';

ServerSocket server;
List<Connection> connections = [];
List<User> users = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 4567)
    .then((ServerSocket socket) {
      print("got socket");
      server = socket;
      server.listen((client) {
        print("got client");
        handleConnection(client);
      });
    });
  print("Im listening on port 4567");
  readLine().listen(processLine);
}


Stream<String> readLine() => stdin
    .transform(utf8.decoder)
    .transform(const LineSplitter());

void processLine(String line) {
  if (line == 'e') {
    exit();
  }
}

void exit() {
  print("Exiting");
  connections.forEach((c) {
    c.disconnect();
  });
}

void handleConnection(Socket client){
  print('Connection from '
    '${client.remoteAddress.address}:${client.remotePort}');

  connections.add(Connection(client));
}

/*
void distributeMessage(User client, SocketMessage sm){
  for (User c in users) {
    if (c != client){
      c.write(sm);
    }
  }
}
*/

void addNewUser(String name, Connection connection) {
  users.add(User(connection, name));
}

void removeUser(User user){
  users.remove(user);
}
void removeUserWithConnection(Connection connection) {
  User userToRemove;
  users.forEach((u) {
    if (u.connection == connection) {
      userToRemove = u;
    }
  });
  if (userToRemove != null) {
    users.remove(userToRemove);
  }
}

void removeConnection(Connection connection){
  connections.remove(connection);
}

class Connection {
  Socket _socket;
  String _address;
  int _port;
  
  Connection(Socket s){
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.listen(messageHandler,
        onError: errorHandler,
        onDone: finishedHandler);
    print("sending SocketAction.PleaseSendName");
    write(SocketMessage(SocketAction.PleaseSendName, null));
  }

  void messageHandler(List<int> data){
    String jsonString = String.fromCharCodes(data).trim();
    SocketMessage sm = SocketMessage.fromString(jsonString);
    handleMessage(sm);
    //distributeMessage(this, '${_address}:${_port} Message: $json');
  }

  void errorHandler(error){
    print('${_address}:${_port} Error: $error');
    disconnect();
  }

  void finishedHandler() {
    print('${_address}:${_port} Disconnected');
    disconnect();
  }

  void write(SocketMessage sm){
    print('writing ${sm.toString()}');
    _socket.write(sm.toString());
  }

  void handleMessage(SocketMessage sm) {
    switch(sm.action) { 
      case SocketAction.AddUser: { 
        print("revieved SocketAction.AddUser");
        String name = sm.value;
        User existing = nameExists(name);
        if (existing != null) {
          if (ipMatches(existing, this)) {
            print("setting new connection");
            existing.setConnection(this);
            write(SocketMessage(SocketAction.Reconnected, true));
            write(SocketMessage(SocketAction.UserInfo, getUserInfo()));
            write(SocketMessage(SocketAction.GameInfo, getGameInfo()));
          } else {
            print("name is taken");
            write(SocketMessage(SocketAction.UserAdded, false)); // name is taken
          }
        } else {
          print("adding user");
          addNewUser(name, this);
          write(SocketMessage(SocketAction.UserAdded, true));
        }
      } 
      break; 
      case SocketAction.RemoveMe: { 
        print("revieved SocketAction.RemoveMe");
        removeUserWithConnection(this);
      } 
      break; 
          
      default: { 
          //statements;  
      }
      break; 
    } 
  }

  void disconnect() {
    _socket.close();
    _port = null;
  }
}

bool ipMatches(User existing, Connection connection) {
  if (existing.connection._address == connection._address) {
    return true;
  }
  return false;
}

User nameExists(String name) {
  User returnVal = null;
  users.forEach((u) {
    if (u.name == name) {
      returnVal = u;
    }
  });
  return returnVal;
}

List<UserInfo> getUserInfo() {
  List<UserInfo> returnVal = [];
  users.forEach((u) {
    returnVal.add(u.toUserInfo());
  });
  return returnVal;
}

GameInfo getGameInfo() {
  GameInfo gi;
  return gi;
}

class User {
  Connection connection;
  String name;
  
  User(Connection c, String n){
    connection = c;
    name = n;
  }

  setConnection(Connection c) {
    connection = c;
  }

  disconnect() {
    connection.disconnect();
  }

  UserInfo toUserInfo() {
    return UserInfo(name: name);
  }
}


