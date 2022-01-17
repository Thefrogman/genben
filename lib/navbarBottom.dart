import 'package:flutter/material.dart';
import 'main.dart';


class Mybottomwidget extends StatefulWidget {
  const Mybottomwidget({Key? key}) : super(key: key);

  @override
  MybottomwidgetState createState() => MybottomwidgetState();
}

class MybottomwidgetState extends State<Mybottomwidget> {
  int _currentIndex = 0;
  var route;
  static var colordata = shrineColorScheme.background;
  static var colordata2 = shrineSupplimentry;
  static var colordata3 = fvarient1;
  static var colordata4 = fvarient2;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (_currentIndex) {
        case 0:
          Navigator.of(context).popUntil(ModalRoute.withName('/home'));
          break;
        case 1:
          Navigator.pushNamed(context, '/pills');
          break;
        case 2:
        if(route != Navigator.pushNamed(context, '/profile')) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
          break;
      }
      
    });
  }
  @override
  Widget build(BuildContext context) {
    route = ModalRoute.of(context)?.settings.name;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      backgroundColor: colordata,
      selectedItemColor: colorScheme.onSurface,
      unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
      selectedLabelStyle: textTheme.caption,
      unselectedLabelStyle: textTheme.caption,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home_filled),
        ),
        BottomNavigationBarItem(
          title: Text('Pills'),
          icon: Icon(Icons.medication),
        ),
        BottomNavigationBarItem(
          title: Text('Settings'),
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
const ColorScheme shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  background: shrineBackgroundWhite,
  surface: shrineBackgroundWhite2,
  error: shrineSupplimentry,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);
const Color shrineSurfaceWhite = Color.fromRGBO(80, 198, 227, 1);
const Color shrineBackgroundWhite = Color.fromRGBO(30, 154, 185, 1);
const Color shrineSupplimentry = Color.fromRGBO(30, 194, 185, 1);
const Color shrineBackgroundWhite2 = Color.fromRGBO(137, 79, 138, 1);
const Color shrineSupplimentry2 = Color.fromRGBO(167, 89, 138, 1);
const Color fvarient1 = Color.fromRGBO(224, 97, 186, 1);
const Color fvarient2 = Color.fromRGBO(235, 148, 208, 1);
const Color mvarient1 = Color.fromRGBO(116, 209, 233, 1);
const Color mvarient2 = Color.fromRGBO(164, 225, 240, 1);