import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unreal Engine Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('unreal_bridge');
  bool _isUnrealRunning = false;

  @override
  void initState() {
    super.initState();
    _checkUnrealStatus();
  }

  Future<void> _checkUnrealStatus() async {
    try {
      final bool isRunning = await platform.invokeMethod('isUnrealRunning');
      setState(() {
        _isUnrealRunning = isRunning;
      });
    } on PlatformException catch (e) {
      print("Failed to check Unreal status: '${e.message}'.");
    }
  }

  Future<void> _launchUnrealLevel(String levelName) async {
    try {
      final bool result = await platform.invokeMethod('launchUnrealLevel', {
        'levelName': levelName,
      });
      
      if (result) {
        setState(() {
          _isUnrealRunning = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unreal Engine launched with level: $levelName')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to launch Unreal: ${e.message}')),
      );
    }
  }

  Future<void> _stopUnreal() async {
    try {
      final bool result = await platform.invokeMethod('stopUnreal');
      
      if (result) {
        setState(() {
          _isUnrealRunning = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unreal Engine stopped')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop Unreal: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unreal Engine Integration'),
        backgroundColor: _isUnrealRunning ? Colors.green : Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _isUnrealRunning ? Icons.play_arrow : Icons.stop,
              size: 100,
              color: _isUnrealRunning ? Colors.green : Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              _isUnrealRunning ? 'Unreal Engine Running' : 'Unreal Engine Stopped',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _launchUnrealLevel('MainMenu'),
              icon: Icon(Icons.play_arrow),
              label: Text('Launch MainMenu'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _launchUnrealLevel('Beach'),
              icon: Icon(Icons.beach_access),
              label: Text('Launch Beach'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _stopUnreal,
              icon: Icon(Icons.stop),
              label: Text('Stop Unreal'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 