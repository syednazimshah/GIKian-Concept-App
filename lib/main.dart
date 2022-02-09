import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/menu/tucklist.dart';
import 'package:untitled/user/userform.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/gikarpool/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(title: 'GIKian', home: Myscreen()));
}

class Myscreen extends StatefulWidget {
  @override
  _MyscreenState createState() => _MyscreenState();
}

class _MyscreenState extends State<Myscreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _reg = TextEditingController();
  bool? isMALEselected;
  bool initialized = false;
  bool infocardtuck = true;
  bool infocardpool = true;

  Future getvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name.text = prefs.getString('name') ?? '';
    _phone.text = prefs.getString('phone') ?? '';
    _address.text = prefs.getString('address') ?? '';
    _reg.text = prefs.getString('reg') ?? '';
    isMALEselected=prefs.getBool('isMALEselected') ?? null;
    infocardtuck = prefs.getBool('infocardtuck') ?? true;
    infocardpool = prefs.getBool('infocardpool') ?? true;
  }

  @override
  void initState() {
    super.initState();
    getvalues().whenComplete(() => setState(() {
          initialized = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, __, ___) => UserForm(),
                transitionDuration: Duration(seconds: 0),
              )).whenComplete(() => setState(() {
                getvalues();
              }));
        },
        elevation: 0,
        focusElevation: 0,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        highlightElevation: 0,
        hoverElevation: 0,
        child: Icon(
          Icons.account_circle_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Card(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              child: (_name.text.isEmpty ||
                      _phone.text.isEmpty ||
                      _address.text.isEmpty ||
                      _reg.text.isEmpty||(isMALEselected==null))
                  ? Column(children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(
                          'Please update your info by tapping the top right icon',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'The buttons are disabled!',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ])
                  : null),
          Builder(
            builder: (context) => ElevatedButton.icon(
              icon: Icon(
                Icons.restaurant,
              ),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(145, 45)),
                  elevation: MaterialStateProperty.all(12),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.white)))),
              onPressed: () {
                if (_name.text.isEmpty ||
                    _phone.text.isEmpty ||
                    _address.text.isEmpty ||
                    _reg.text.isEmpty||(isMALEselected==null)) {
                } else {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, __, ___) => TuckList(),
                          transitionDuration: Duration(seconds: 0),
                        ));
                    if (infocardtuck) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                scrollable: true,
                                backgroundColor: Colors.blue,
                                actions: [
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          elevation:
                                              MaterialStateProperty.all(12),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ))),
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setBool('infocardtuck', false);
                                        setState(() {
                                          infocardtuck = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Exit',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                title: Center(
                                    child: Text(
                                  'Welcome',
                                  style: TextStyle(color: Colors.white),
                                )),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Text(
                                    '-> You can only order from one shop at a time\n\n-> Cart is cleared when you leave a shop\n\n-> Orders from different shops are placed individually\n'
                                    "\n-> You can view Your Order History (Last 25 orders) in each shop's menu\n\n-> Order history of each shop is separate\n\n->You cannot remove your order once its received by the Shop\n"
                                    "\n-> Contact numbers of Shops are available in the top right corner",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              );
                            });
                          });
                  }
                }
              },
              label: Text(
                'Tuck',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Builder(
            builder: (context) => ElevatedButton.icon(
              icon: Icon(
                Icons.time_to_leave,
              ),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(145, 45)),
                  elevation: MaterialStateProperty.all(12),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.white)))),
              onPressed: () {
                if (_name.text.isEmpty ||
                    _phone.text.isEmpty ||
                    _address.text.isEmpty ||
                    _reg.text.isEmpty||(isMALEselected==null)) {
                } else {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, __, ___) => CarpoolApp(),
                          transitionDuration: Duration(seconds: 0),
                        ));
                    if (infocardpool) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    scrollable: true,
                                    backgroundColor: Colors.blue,
                                    actions: [
                                      Center(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                              elevation:
                                              MaterialStateProperty.all(12),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(25.0),
                                                  ))),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                            prefs.setBool(
                                                'infocardpool', false);
                                            setState(() {
                                              infocardpool = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Exit',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24)),
                                    title: Center(
                                        child: Text(
                                          'Welcome',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      child: Text(
                                        "-> You can find the options to 'Find Rides' and 'Offer Rides' at the bottom of the page\n\n-> You can fill in the details requested on the relevant pages to find or offer rides\n\n-> You may view details of available rides and call the person offering\n"
                                            "\n-> You may view your offered rides in the 'My Offers' page by clicking the icon at the top right corner\n\n-> You may edit the number of seats available in the ride you have offered\n"
                                            "\n-> Delete your offer once all the seats have been booked!",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  );
                                });
                          });
                    }
                }
              },
              label: Text(
                'GIKarpool',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 90,
          ),
          RichText(
            text: TextSpan(text: 'for gikians by',style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 20,),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: FaIcon(FontAwesomeIcons.instagram,color: Colors.white,size:14),
                ),
                TextSpan(
                    text: '/@syed.nazim.shah',
                    style: TextStyle(fontSize: 14),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://www.instagram.com/syed.nazim.shah/');
                      }
                )
              ],

            ),
          ),
          SizedBox(height: 10,),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: FaIcon(FontAwesomeIcons.instagram,color: Colors.white,size:14),
                ),
                TextSpan(
                  text: '/@maaz.tariq29',
                  style: TextStyle(fontSize: 14),
                    recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://www.instagram.com/maaz.tariq29/');
                  }
                )
              ],

               ),
          ),
        ]),
      ),
    );
  }
}
