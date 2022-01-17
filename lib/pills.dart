
import 'dart:ffi';

import 'package:first_app/home.dart';
import 'package:first_app/navbarBottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'genderStorage.dart';
import 'main.dart';

class Pills extends StatefulWidget {
  const Pills({Key? key, required this.storage}) : super(key: key);
  final GenderStorage storage;

  @override
  State<Pills> createState() => PillsState();
  
}

class PillsState extends State<Pills> {
  static String theme = "";
  static String amountofDays = "";
  static String name = "";
  static String themeType = "";
  int pillCount = 0;
  int f = 0;
  int checkonce = 0;
  List<String> timeList = [];
  List<DateTime> dateList = [];
  List<Widget> containerList = [];
  List<String> readData= [];
  
  String data = "";
  int value = 0;
  
  Future<String> _resolveFutureReadData() async {
    String i = await widget.storage.readCounterFullFrom(6);
    if(i.isEmpty) {
      debugPrint("empty string");
      return "";
    }
    readData = i.split("\n");
    debugPrint(readData.length.toString());
    timeList = readData;
    setState(() {
      value = timeList.length;
    });
    debugPrint(i);
    return "";
  }
  Future<String> _resolveFutureRead() async {
    String i = await widget.storage.readCounterFullTo(3);
    setState(() {
      data = i;
    });
   
    return "";
  }
  
  _addItem() {
    setState(() {
      timeList.add("12:00AM");
      
      value = value + 1;
    });
  }

  _removeItem() {
    setState(() {
      timeList.removeAt(timeList.length - 1);
      try{
      dateList.removeAt(dateList.length - 1);
      }
      catch(e){
        print("Datelist does not exist yet");
      }
      value = value - 1;
    });
  }

  _removeItemAt(index) {
    setState(() {
      timeList.removeAt(index);
      try{
      dateList.removeAt(index);
      }catch(e) {
        print("Datelist does not exist yet");
      }
      pillCount--;
      value = value - 1;
    });
  }

  void scheduleAlarm(DateTime v, int index) async {
    var scheduledNotificationDateTime = v;
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'icon',
      largeIcon: DrawableResourceAndroidBitmap('icon'),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(index, v.toString(), "eeee",
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  Widget returnWidget(index) {
    String f = "12:00 AM";
    TimeOfDay selectedTime = TimeOfDay.now();
    _selectTime(BuildContext context) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null && timeOfDay != selectedTime) {
        setState(() {
          selectedTime = timeOfDay;
          f = selectedTime.format(context);
          timeList[index] = f;
          DateTime date = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, selectedTime.hour, selectedTime.minute);
          dateList.add(date);
        });
      }
    }

    return Container(
        color: (index % 2 == 0)
            ? MybottomwidgetState.colordata3
            : MybottomwidgetState.colordata4,
        child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: Container(
              width: double.infinity,
              height: 20,
              color: (index % 2 == 0)
                  ? MybottomwidgetState.colordata3
                  : MybottomwidgetState.colordata4,
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 0),
                  child: Text("Pill alarm: " + index.toString(),
                      style: TextStyle(fontSize: 20)),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: 0, right: 10),
                  child: Text(timeList[index], style: TextStyle(fontSize: 20)),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 0, right: 2),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {
                        _selectTime(context);
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0, right: 5),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {
                        _removeItemAt(index);
                      },
                    ))
              ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
   
    String datetime = DateTime.now().toString();
    if(checkonce == 0) {
      _resolveFutureReadData();
      _resolveFutureRead();
      checkonce++;
      
    }
    final myController = TextEditingController();
    return Scaffold(
      
      appBar: AppBar(
        
          title: const Text('Alarms'),
          backgroundColor: MybottomwidgetState.colordata),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(HomeState.theme),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(color: MybottomwidgetState.colordata2),
              child: FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Amount of pills daily:",
                                textAlign: TextAlign.left),
                          )),
                      const Spacer(),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: MybottomwidgetState.colordata),
                              onPressed: () {
                                setState(() {
                                  pillCount--;
                                  _removeItem();
                                });
                              },
                              child: const Text("-"))),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          value.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: MybottomwidgetState.colordata),
                              onPressed: () {
                                setState(() {
                                  pillCount++;
                                  _addItem();
                                });
                              },
                              child: const Text("+"))),
                    ])
                  ])),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: value,
                  itemBuilder: (context, index) => returnWidget(index)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(color: MybottomwidgetState.colordata2),
              child: FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Column(
                    children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: MybottomwidgetState.colordata),
                              onPressed: () {
                              
                                String result = data;
                                flutterLocalNotificationsPlugin.cancelAll();
                                for (var i = 0; i < dateList.length; i++) {
                                scheduleAlarm(dateList[i], i);
                                }
                                result += timeList.length.toString() +"\n";
                                for(String time in timeList) {
                                  result += time + "\n";
                                }
                                GenderStorage().writeCounter(result, 0);
                              },
                              child: const Text("Save Alarms"))),
                    ])
                  ])),
            ),
          ])),
      bottomNavigationBar: Mybottomwidget(),
    );
  }
}
