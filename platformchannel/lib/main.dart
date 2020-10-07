import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Channel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: PlatformTestBody(),
    );
  }
}

class PlatformTestBody extends StatefulWidget {
  @override
  PlatformTestBodyState createState() {
    return new PlatformTestBodyState();
  }
}

class PlatformTestBodyState extends State<PlatformTestBody> {
  MethodChannel platformMethodChannel;
  String nativeMessage = '';

  vibrate() async {
    try {
      await platformMethodChannel.invokeMethod('vibrate');
      setState(() {
        nativeMessage = "Vibration success";
      });
    } on PlatformException catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    platformMethodChannel = const MethodChannel('com.test/test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Platform channel vibration")),
      body: new Container(
        color: Colors.pinkAccent,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 200.0),
              child: new Text(
                'Tap the button to change your life!',
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 23.0),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 102.0),
              child: new RaisedButton(
                child: new Text('Vibrate!'),
                onPressed: () => vibrate(),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 102.0),
              child: new Text(
                nativeMessage,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 23.0),
              ),
            )
          ],
        ),
      ),
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
  static const MethodChannel methodChannel =
      MethodChannel('samples.flutter.io/battery');
  static const EventChannel eventChannel =
      EventChannel('samples.flutter.io/charging');
  String _batteryLevel = '';
  String _chargingStatus = '';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = result.toString();
    } on PlatformException {
      batteryLevel = 'Error';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    setState(() {
      _chargingStatus = "${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError() {
    setState(() {
      _chargingStatus = 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Battery Level: $_batteryLevel',
                key: const Key('Battery level label'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                    onPressed: _getBatteryLevel, child: const Text('Refresh')),
              )
            ],
          ),
          Text('Charging Status: $_chargingStatus')
        ],
      ),
    );
  }
}
