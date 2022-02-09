import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/user/loading.dart';
import 'package:untitled/error screen/errorscreen.dart';
import 'package:untitled/menu/menu.dart';
import 'contactdirectory.dart';

class TuckList extends StatefulWidget {
  @override
  TuckListState createState() {
    return TuckListState();
  }
}

class TuckListState extends State<TuckList> {
  late Stream<QuerySnapshot> usersStream;
  bool initialized = false;
  bool checknet=false;


  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }

  Future<void> initializeFlutterFire() async {
    await Firebase.initializeApp();
    usersStream = FirebaseFirestore.instance.collection('tucklist').snapshots();

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
                    actions: [
                      IconButton(
                          onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, _, __) => Contacts(),
                                    transitionDuration: Duration(seconds: 0),
                                  ));
                          },
                          icon: Icon(
                            Icons.contact_phone,
                            color: Colors.white,
                          ))
                    ],
                    title: Text('Tuck Shops'),
                  ),
                  body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                              return InkWell(
                                splashColor: Colors.blue,
                                child: Card(
                                    color: Colors.blue.shade50,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24)),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          //leading: geticon(data['name'].toString()),
                                          title: Text(data['name'].toString()),
                                          subtitle: Text(
                                              'Tap to see ${data['name']
                                                  .toString()} Menu'),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, _, __) =>
                                              Menu(
                                                shopkey: data['password']
                                                    .toString(),
                                                name: data['name'].toString(),
                                              ),
                                          transitionDuration:
                                          Duration(seconds: 0),
                                        ));
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      )));
            },
          );
        }
        else {
          return Error();
        }
      }
      return Loading();
    }
    // return Loading();
    // }
}
