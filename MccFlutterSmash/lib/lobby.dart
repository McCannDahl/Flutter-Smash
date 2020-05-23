
import 'package:MccFlutterSmash/shared/models.dart';
import 'package:MccFlutterSmash/sockethelper.dart';

import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  final SocketHelper socketHelper;

  LobbyScreen({Key key, @required this.socketHelper}) : super(key: key);

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {

  void startGame() {

  }

  @override
  void dispose() {
    print("disposing lobby");
    widget.socketHelper.leaveLobby();
    widget.socketHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.socketHelper.tryToReconnect();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      'Game Settings',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      'Players',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.socketHelper.userInfos != null ? widget.socketHelper.userInfos.map((e) => UserInfoDisplay(e)).toList() : [],
                  ),
                  RaisedButton(
                    onPressed: () {
                      startGame();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.grey)
                    ),
                    color: Colors.white,
                    textColor: Colors.blue,
                    child: Text(
                      'Start Game',
                      style: TextStyle(fontSize: 20)
                    ),
                  ),
                ],
              )
            )
          );
        }
      )
    );
  }
}


class UserInfoDisplay extends StatelessWidget {
  UserInfo ui;
  UserInfoDisplay(this.ui);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: double.infinity,
      child: Text(
        ui.name,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}