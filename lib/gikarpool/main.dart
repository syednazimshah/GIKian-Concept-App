import 'package:untitled/gikarpool/offer_a_ride.dart';
import 'package:flutter/material.dart';
import 'find_a_ride.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading.dart';
import 'package:untitled/gikarpool/my_flutter_app_icons.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'error_screen.dart';
import 'my_offers.dart';

class CarpoolApp extends StatefulWidget {
  @override
  State<CarpoolApp> createState() => CarpoolAppState();
}

class CarpoolAppState extends State<CarpoolApp> {
  int pageinit = 0;
  String name = '';
  String phone = '';
  String regno = '';
  bool initialized = false;
  bool checknet = false;

  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }

  Future getvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    phone = prefs.getString('phone') ?? '';
    regno = prefs.getString('reg') ?? '';
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue);

  final List<Widget> _widgetOptions = <Widget>[
    FindRides(),
    OfferRides(),
  ];

  void initState() {
    super.initState();
    netcheck().whenComplete(() => getvalues().whenComplete(() => setState(() {
          initialized = true;
        })));
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      if (checknet) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('GIKarpool'),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, _, __) => MyOffers(Reg: regno),
                          transitionDuration: Duration(seconds: 0),
                        ));
                  },
                  icon: Icon(
                    MyFlutterApp.offer,
                    color: Colors.white,
                  ),
                  tooltip: 'My Offers',
                ),
              ),
            ],
          ),
          body: Center(
            child: (name == '' || phone == '' || regno == '')
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Please Fill the Registration Form Given At the Home Page',
                          style: optionStyle,
                          textAlign: TextAlign.center,
                        ),
                      ]))
                : _widgetOptions.elementAt(pageinit),
          ),
          bottomNavigationBar: BottomNavigationBar(
              elevation: 5,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.hail),
                  label: 'Find a Ride',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.time_to_leave),
                  label: 'Offer a Ride',
                ),
              ],
              currentIndex: pageinit,
              selectedItemColor: Colors.blue,
              onTap: (value) {
                setState(() {
                  pageinit = value;
                });
              }),
        );
      } else {
        return Error();
      }
    }

    return Loading();
  }
}
