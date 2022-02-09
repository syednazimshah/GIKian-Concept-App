import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'orderdata.dart';
import 'package:untitled/user/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orderhistory.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:untitled/error screen/errorscreen.dart';

class OrderScreen extends StatefulWidget {
  orderlist newlist = new orderlist();
  final String collectionKEY;

  OrderScreen({Key? key, required this.newlist, required this.collectionKEY})
      : super(key: key);

  @override
  OrderScreenState createState() {
    return OrderScreenState();
  }
}

class OrderScreenState extends State<OrderScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _reg = TextEditingController();
  bool initialized = false;
  bool checknet = false;

  @override
  void initState() {
    super.initState();
    netcheck().whenComplete(() => getvalues().whenComplete(() => setState(() {
          initialized = true;
        })));
  }
  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }
  String order() {
    var temp = StringBuffer();
    widget.newlist.datalist.forEach((element) {
      temp.write('\n');
      temp.write(element.number.toString());
      temp.write(' ');
      temp.write(element.name);
    });
    return temp.toString().replaceFirst('\n', '', 0);
  }

  Future getvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name.text = prefs.getString('name') ?? '?';
    _phone.text = prefs.getString('phone') ?? '?';
    _address.text = prefs.getString('address') ?? '?';
    _reg.text = prefs.getString('reg') ?? '?';
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
      if (initialized) {
        if(checknet) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Place your Order'),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                      color: (_name.text == '?' ||
                          _phone.text == '?' ||
                          _address.text == '?' ||
                          _reg.text == '?')?Colors.red:Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                      child: (_name.text == '?' ||
                                  _phone.text == '?' ||
                                  _address.text == '?' ||
                                  _reg.text == '?')
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
                            'Missing User Info!',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Name: ${_name.text}',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Contact: ${_phone.text}',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Reg: ${_reg.text}',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Address: ${_address.text}',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 5,
                        )
                      ])
                          :Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Name: ${_name.text}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Contact: ${_phone.text}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Reg: ${_reg.text}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Address: ${_address.text}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ), ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Your Order Below',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            order(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Total: Rs.${widget.newlist.totalprice}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.newlist.datalist.clear();
                            widget.newlist.totalorders = 0;
                            widget.newlist.totalprice = 0;
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Cancel Order')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Back')),
                      Builder(
                        builder: (context) =>
                            ElevatedButton(
                              child: Text('Place Order'),
                              onPressed: (_name.text == '?' ||
                                  _phone.text == '?' ||
                                  _address.text == '?' ||
                                  order().isEmpty ||
                                  order() == '' ||
                                  !checknet ||
                                  _reg.text == '?')
                                  ? null
                                  : () async {
                                await FirebaseFirestore.instance
                                    .collection(widget.collectionKEY)
                                    .doc('orders')
                                    .collection('orders')
                                    .add(<String, dynamic>{
                                  'text': order(),
                                  'timestamp': DateTime.now(),
                                  'location': _address.text,
                                  'phone': _phone.text,
                                  'reg': _reg.text,
                                  'name': _name.text,
                                  'price': widget.newlist.totalprice,
                                  'received': false,
                                }).whenComplete(() {
                                  widget.newlist.datalist.clear();
                                  widget.newlist.totalprice = 0;
                                  widget.newlist.totalorders = 0;
                                });
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, __, ___) =>
                                          OrderHistory(
                                            collectionKEY: widget
                                                .collectionKEY,
                                          ),
                                      transitionDuration:
                                      Duration(seconds: 0),
                                    ));


                                }
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        else{
          return Error();
        }
      }
      return Loading();
  }
}
