import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/user/loading.dart';
import 'package:untitled/error screen/errorscreen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';
class Contacts extends StatefulWidget {
  @override
  ContactsState createState() {
    return ContactsState();
  }
}

class ContactsState extends State<Contacts> {

  bool initialized = false;
  bool checknet=false;
  Future getvalues() async {
    await Firebase.initializeApp();
    checknet = await InternetConnectionChecker().hasConnection;
  }

  void initState() {
    super.initState();
    getvalues().whenComplete(() => (setState(() {
          initialized = true;
        })));
  }

  @override
  Widget build(BuildContext context) {
      if (initialized) {
        if(checknet) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tucklist').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    title: Text('Contacts Directory'),
                  ),
                  body: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                          return InkWell(
                            splashColor: Colors.deepOrange,
                            child: Card(
                                color: Colors.blue.shade50,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(data['name'].toString()),
                                      subtitle: Text('${data['phone']
                                          .toString()}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.phone),
                                        onPressed: () {
                                          launch('tel://${data['phone']
                                              .toString()}');
                                        },
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
