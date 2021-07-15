import 'package:flutter/material.dart';
import 'package:sekolahku/screens/home_screen.dart';
import 'package:sekolahku/service/app_service.dart';
import 'package:sekolahku/util/lifecycle_event_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool databaseIsReady = false;
  late LifecycleEventHandler _lifecycleEventHandler;

  @override
  void initState() {
    super.initState();
    AppService.open().then((database) {
      setState(() {
        databaseIsReady = true;
      });
    });
    _lifecycleEventHandler = LifecycleEventHandler(onResume: (state) async {
      return AppService.open().then((database) {
        setState(() {
          databaseIsReady = true;
        });

        return databaseIsReady;
      });
    }, onSuspend: (state) async {
      return AppService.close().then((val) {
        setState(() {
          databaseIsReady = false;
        });

        return databaseIsReady;
      });
    });
    WidgetsBinding.instance!.addObserver(_lifecycleEventHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(_lifecycleEventHandler);
    AppService.close().then((val) {
      setState(() {
        databaseIsReady = false;
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('databaseIs ready? $databaseIsReady');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sekolahku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: databaseIsReady
          ? HomeScreen()
          : Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
