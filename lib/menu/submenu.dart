import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/order/orderscreen.dart';
import 'package:untitled/user/loading.dart';
import 'package:untitled/order/orderdata.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:untitled/error screen/errorscreen.dart';

class SubMenu extends StatefulWidget {
  final String collectionKEY;
  final String menuname;
  orderlist newlist = new orderlist();
  final String docid;

  SubMenu(
      {Key? key,
      required this.collectionKEY,
      required this.newlist,
      required this.menuname,
      required this.docid})
      : super(key: key);

  @override
  SubMenuState createState() {
    return SubMenuState();
  }
}

class SubMenuState extends State<SubMenu> {
  late Stream<QuerySnapshot> usersStream;
  bool initialized = false;
  bool checknet = false;
  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }
  Future<void> initializeFlutterFire() async {
    await Firebase.initializeApp();
    usersStream = FirebaseFirestore.instance
        .collection(widget.collectionKEY)
        .doc(widget.docid)
        .collection(widget.docid)
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
                    title: Text(widget.menuname),
                    actions: <Widget>[
                      IconBadge(
                          icon: Icon(Icons.shopping_cart_rounded),
                          itemCount: widget.newlist.totalorders,
                          badgeColor: Colors.red,
                          itemColor: Colors.white,
                          hideZero: true,
                          onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, __, ___) =>
                                        OrderScreen(
                                          newlist: widget.newlist,
                                          collectionKEY: widget.collectionKEY,
                                        ),
                                    transitionDuration: Duration(seconds: 0),
                                  )).whenComplete(() => setState((){}));
                          }),
                    ],
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
                                      leading: IconButton(
                                        onPressed: () {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            elevation: 0,
                                            // width: 173,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                            content: Text(widget.newlist
                                                .removeorder(
                                                data['name'].toString(),
                                                data['price'].toInt())),
                                            duration: Duration(
                                                milliseconds: 150),
                                          ));
                                        },
                                        icon: Icon(Icons.do_disturb_on_rounded),
                                        color: Colors.blue,
                                      ),
                                      title: Text(data['name'].toString()),
                                      subtitle: Text(
                                          'Price Rs.${data['price']
                                              .toString()}'),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                            content: Text(
                                                widget.newlist.addorder(
                                                    data['name'].toString(),
                                                    data['price'].toInt())),
                                            duration: Duration(
                                                milliseconds: 150),
                                          ));
                                        },
                                        icon: Icon(Icons.add_circle),
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                )),
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
