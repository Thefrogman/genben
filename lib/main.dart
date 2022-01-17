// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:first_app/pills.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home.dart';
import 'genderStorage.dart';
import 'navbarBottom.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      home: SecondScreen(storage: GenderStorage()),
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => Home(storage: GenderStorage()),
        '/profile': (context) => ProfileScreen(storage: GenderStorage()),
        '/pills': (context) => Pills(storage: GenderStorage()),
      },
    ),
  );
}

const String mtf = "assets/images/MTFTheme.png";
const String ftm = "assets/images/FTMTheme.png";
const String either = "assets/images/EitherTheme.png";
const String mtfWelcome = "assets/images/MTFWelcome.png";
const String ftmWelcome = "assets/images/FTMWelcome.png";
const String eitherWelcome = "assets/images/EitherWelcome.png";
const Color shrinePink50 = Color.fromRGBO(162, 162, 162, 1);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);
const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);
const Color shrineErrorRed = Color(0xFFC5032B);
const Color shrineSurfaceWhite = Color.fromRGBO(80, 198, 227, 1);
const Color shrineBackgroundWhite = Color.fromRGBO(30, 154, 185, 1);
const Color shrineBackgroundWhite2 = Color.fromRGBO(137, 79, 138, 1);

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);
  void scheduleAlarm() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, 'Office', "eeee",
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    scheduleAlarm();
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Press to Start',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.storage}) : super(key: key);
  final GenderStorage storage;

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  String data = 'Either';
  var f = either;
  String prefix = "";
  int checkonce = 0;
  _resolveFutureRead() async {
    prefix = await GenderStorage().readCounterFullFrom(4);
    setState(() {
      prefix = prefix;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkonce == 0) {
      _resolveFutureRead();
      checkonce++;
    }
    if (HomeState.themeType == 'Male to Female') {
      f = mtf;
      MybottomwidgetState.colordata = shrineBackgroundWhite2;
    }
    if (HomeState.themeType == 'Female to Male') {
      f = ftm;
      MybottomwidgetState.colordata = shrineBackgroundWhite;
    }
    if (HomeState.themeType == 'Either') {
      f = either;
      MybottomwidgetState.colordata = shrinePink50;
    }
    final myController = TextEditingController();
    final myControllerinputNum = TextEditingController();
    if (HomeState.themeType != "") {
      data = HomeState.themeType;
    }
    myController.text = HomeState.name;
    myControllerinputNum.text = HomeState.amountofDays;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: MybottomwidgetState.colordata),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(f),
            fit: BoxFit.cover,
          )),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        DropdownButton<String>(
                            isExpanded: true,
                            value: data,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            items: <String>[
                              'Male to Female',
                              'Female to Male',
                              'Either'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                child: FractionallySizedBox(
                                  widthFactor: 5,
                                  child:
                                      Text(value, textAlign: TextAlign.center),
                                ),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue == 'Male to Female') {
                                  f = mtf;
                                  MybottomwidgetState.colordata =
                                      shrineBackgroundWhite2;
                                  MybottomwidgetState.colordata2 =
                                      shrineSupplimentry2;
                                  MybottomwidgetState.colordata3 = fvarient1;
                                  MybottomwidgetState.colordata4 = fvarient2;
                                }
                                if (newValue == 'Female to Male') {
                                  f = ftm;

                                  MybottomwidgetState.colordata =
                                      shrineBackgroundWhite;
                                  MybottomwidgetState.colordata2 =
                                      shrineSupplimentry;
                                  MybottomwidgetState.colordata3 = mvarient1;
                                  MybottomwidgetState.colordata4 = mvarient2;
                                }
                                if (newValue == 'Either') {
                                  f = either;
                                  MybottomwidgetState.colordata = shrinePink50;
                                  MybottomwidgetState.colordata2 = Colors.grey;

                                  MybottomwidgetState.colordata3 =
                                      Color.fromRGBO(198, 203, 204, 1);
                                  MybottomwidgetState.colordata4 =
                                      Color.fromRGBO(222, 225, 226, 1);
                                }
                                HomeState.themeType = newValue!;
                                data = newValue;
                              });
                            }),
                        Text(
                          'Enter your name.',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextField(
                          controller: myController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          "Number of days on hormones",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          controller: myControllerinputNum,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          'I understand that this application does not offer any professional medical advice, and should contact a medical professional if unsure about when I should use any medications. ',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ])),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  String ready = myController.text +
                      "\n" +
                      data +
                      "\n" +
                      myControllerinputNum.text +
                      "\n" +
                      DateTime.now().toString();
                  ready += "\n" + prefix;
                  widget.storage.writeCounter(ready, 0);
                  HomeState.theme = data;
                  HomeState.amountofDays = myControllerinputNum.text;
                  HomeState.timeBetween = DateTime.now().toString();
                  ;
                  HomeState.name = myController.text;
                  HomeState.themeType = f;
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ],
          ))),
      bottomNavigationBar: Mybottomwidget(),
    );
  }
}

class TextInput {}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key, required this.storage}) : super(key: key);
  final GenderStorage storage;
  @override
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondScreen> {
  String t = "";
  String data = "";
  String f = "";
  String name = "";
  String amountofDays = "";
  String timeBetween = "";
  String result = "";
  int j = 0;
  Future<String> getData(int num) {
    return widget.storage.readCounter(num);
  }

  Future<void> getInfo() async {
    result = await getData(1);
    if ("Female to Male" == result) {
      f = ftmWelcome;
      MybottomwidgetState.colordata = shrineBackgroundWhite;
      MybottomwidgetState.colordata2 = shrineSupplimentry;
      MybottomwidgetState.colordata3 = mvarient1;
      MybottomwidgetState.colordata4 = mvarient2;
    } else if ("Male to Female" == result) {
      f = mtfWelcome;
      MybottomwidgetState.colordata = shrineBackgroundWhite2;
      MybottomwidgetState.colordata2 = shrineSupplimentry2;
      MybottomwidgetState.colordata3 = fvarient1;
      MybottomwidgetState.colordata4 = fvarient2;
    } else {
      f = either;
      MybottomwidgetState.colordata = shrinePink50;
      MybottomwidgetState.colordata2 = Colors.grey;
      MybottomwidgetState.colordata3 = Color.fromRGBO(198, 203, 204, 1);
      MybottomwidgetState.colordata4 = Color.fromRGBO(222, 225, 226, 1);
    }
    name = await getData(0);
    amountofDays = await getData(2);
    timeBetween = await getData(3);
    if (j == 0) {
      j++;
      updateData(f);
    }
  }

  void updateData(r) {
    setState(() {
      t = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeState.theme = f;
    HomeState.amountofDays = amountofDays;
    HomeState.timeBetween = timeBetween;
    HomeState.name = name;
    HomeState.themeType = result;
    getInfo();
    return Scaffold(
        appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: MybottomwidgetState.colordata),
        body: GestureDetector(
            onTap: () => {
                  widget.storage.readCounter(0).then((value) {
                    if (value != "") {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }
                  })
                },
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(t),
                  fit: BoxFit.cover,
                )),
                child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                      FractionallySizedBox(
                          // Within the SecondScreen widget
                          ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 40),
                            child: Text(
                              "Welcome " + name,
                              style: TextStyle(
                                  fontSize: 24, fontFamily: 'Roberto'),
                            ),
                          ))
                    ])))));
  }
}
