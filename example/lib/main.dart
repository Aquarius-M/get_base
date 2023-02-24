import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:example/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_base/get_base.dart';

Repository repository = Repository();

void main() {
  ClientConfig.beforeRequest = _check;
  ClientConfig.toastCall = (msg) {
    SmartDialog.showToast(msg);
  };
  runApp(const MyApp());
}

Future<NetworkException?> _check()async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return NetworkException(HttpExceptionCode.netError, "网络异常，请检查你的网络！");
  }
  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      navigatorObservers: [
        FlutterSmartDialog.observer,
      ],
      builder: FlutterSmartDialog.init(builder: (ctx, child) {
        return MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                //点击空白收起键盘
                FocusScopeNode currentFocus = FocusScope.of(ctx);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: child,
            ),
          ),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    repository.pwdLogin();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
