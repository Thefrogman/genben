import 'package:first_app/navbarBottom.dart';
import 'package:flutter/material.dart';
import 'genderStorage.dart';
class Home extends StatefulWidget {
  const Home({Key? key, required this.storage}) : super(key: key);
  final GenderStorage storage;
  @override
  State<Home> createState() => HomeState();
  
}

class HomeState extends State<Home> {
  static String theme = "";
  static String amountofDays = "";
  static String name = "";
  static String themeType = "";  
  @override
  Widget build(BuildContext context) {
   String datetime = DateTime.now().toString();
   debugPrint(datetime);
    final myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Setup'),
          backgroundColor: MybottomwidgetState.colordata),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(theme),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 40),
                                child: Text(
                                  'Welcome back ' + name,
                                  style: TextStyle(
                                      fontSize: 24, fontFamily: 'Roberto'),
                                ))),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 40,top:40),
                                child: Text(
                          'Your currently on day ' +
                              amountofDays +
                              " of hormones.",
                          style: TextStyle(fontSize: 16, fontFamily: 'Roberto'),
                          textAlign: TextAlign.left,
                        ))),
                      ])),
            ],
          )),
      bottomNavigationBar: Mybottomwidget(),
    );
  }
}
