import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spring_superior/services/member_services.dart';
import 'package:spring_superior/services/notification_services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'models/member_model.dart';
import 'pages/home.dart';

const simplePeriodicTask = 'simplePeriodicTask';
MemberServices memberServices = MemberServices();

void _showNotification(fltrNotification) async {

  var androidSettings = AndroidNotificationDetails(
      'Expiry Id', 'Expiry', 'Expired',
      playSound: true, enableVibration: true,
      importance: Importance.max, priority: Priority.max);
  var iosSettings = IOSNotificationDetails();
  var notifDetails =  NotificationDetails(android: androidSettings, iOS: iosSettings);

  await fltrNotification.show(
      '1',
      'Subscription Notification',
      'Good morning! Time to check for updates',
      notifDetails,
      androidAllowWhileIdle: true);

}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  await Workmanager.registerPeriodicTask(
    '5',
    simplePeriodicTask,
    frequency: Duration(minutes: 15),
    initialDelay: Duration(seconds: 10)
  );

  runApp(MyApp());
}

void callbackDispatcher(){
  print('dispatch -----------------------------------------------------------------');
  Workmanager.executeTask((taskName, inputData) async{
    FlutterLocalNotificationsPlugin fltrNotification = FlutterLocalNotificationsPlugin();
    var androidInitialize = new AndroidInitializationSettings('exercise_icon');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initializationSettings);

    _showNotification(fltrNotification);
    print('execute ___________________________________________________________');

    return Future.value(true);
  });
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xFF070707),
          accentColor: Colors.purple[800]
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }

}


