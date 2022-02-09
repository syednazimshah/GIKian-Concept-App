import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/user/loading.dart';
import 'package:untitled/menu/submenu.dart';
import 'package:untitled/order/orderdata.dart';
import 'package:untitled/order/orderhistory.dart';
import 'package:untitled/order/orderscreen.dart';
import 'package:untitled/error screen/errorscreen.dart';
import 'package:untitled/user/userform.dart';

class Menu extends StatefulWidget {
  final String shopkey;
  final String name;

  Menu({Key? key, required this.shopkey, required this.name}) : super(key: key);

  @override
  MenuState createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  late Stream<QuerySnapshot> usersStream;
  bool initialized = false;
  bool checknet = false;
  orderlist newlist = new orderlist();

  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }
  Future<void> initializeFlutterFire() async {
    await Firebase.initializeApp();
    usersStream = FirebaseFirestore.instance
        .collection(widget.shopkey)
        .where('available', isNotEqualTo: false)
        .snapshots();
  }

  void initState() {
    super.initState();
    netcheck().whenComplete(() => initializeFlutterFire().whenComplete(() => setState(() {
          initialized = true;
        })));
  }

  @override
  Widget build(BuildContext context) {
      if (initialized) {
        if(checknet) {
          return StreamBuilder<QuerySnapshot>(
            stream: usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Error();
              }
              if (snapshot.connectionState == ConnectionState.none) {
                return Error();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'Order History') {

                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, __, ___) =>
                                        OrderHistory(
                                          collectionKEY: widget.shopkey,
                                        ),
                                    transitionDuration: Duration(seconds: 0),
                                  ));
                          }
                          if (result == 'My Order') {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, __, ___) =>
                                        OrderScreen(
                                          newlist: newlist,
                                          collectionKEY: widget.shopkey,
                                        ),
                                    transitionDuration: Duration(seconds: 0),
                                  ));
                          }
                          if (result == 'Settings') {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, __, ___) => UserForm(),
                                  transitionDuration: Duration(seconds: 0),
                                ));
                          }
                        },
                        elevation: 100,
                        itemBuilder: (BuildContext context) {
                          return {'Order History', 'My Order', 'Settings'}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                    title: Text(widget.name),
                  ),
                  body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: ListView(
                        shrinkWrap: true,
                        children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                          return InkWell(
                            splashColor: Colors.blue,
                            child: Card(
                                color: Colors.blue.shade50,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(data['name'].toString()),
                                      subtitle: Text(
                                          'Tap to see items on ${data['name']
                                              .toString()} Menu'),
                                    ),
                                  ],
                                )),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, _, __) =>
                                          SubMenu(
                                            collectionKEY: widget.shopkey,
                                            newlist: newlist,
                                            menuname: data['name'].toString(),
                                            docid: document.id,
                                          ),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
                            },
                          );
                        }).toList(),
                      )));
            },
          );
        }
        else{
          return Error();
        }
      }
      return Loading();
    }
}
