
import 'package:flutter/material.dart';
import 'package:MccFlutterSmash/sockethelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter RTS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: McCann(),
    );
  }
}



class McCann extends StatefulWidget {
  McCann({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _McCannState createState() => _McCannState();
}

class _McCannState extends State<McCann> {
  SocketHelper socketHelper;
  final ipController = TextEditingController(text: '10.0.2.2');
  final portController = TextEditingController(text: '4567');
  final nameController = TextEditingController(text: 'Bob');
  
  void submit() {
    print('submit called');
    socketHelper.tryToConnect(ipController.text, int.tryParse(portController.text), nameController.text);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ipController.dispose();
    portController.dispose();
    nameController.dispose();
    socketHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    socketHelper = SocketHelper(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      labelText: "Server IP Address",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: portController,
                    decoration: InputDecoration(
                      labelText: "Server Port",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "User Name",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    submit();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.grey)
                  ),
                  color: Colors.white,
                  textColor: Colors.blue,
                  child: const Text(
                    'Join',
                    style: TextStyle(fontSize: 20)
                  ),
                ),
              ],
            )
          )
        );
      }
    );
  }
}


