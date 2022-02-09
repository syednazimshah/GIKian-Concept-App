import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/user/loading.dart';
import 'package:untitled/error screen/errorscreen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class OrderHistory extends StatefulWidget {
  final String collectionKEY;

  OrderHistory({Key? key, required this.collectionKEY}) : super(key: key);

  @override
  OrderHistoryState createState() {
    return OrderHistoryState();
  }
}

class OrderHistoryState extends State<OrderHistory> {
  bool initialized = false;
  bool checknet = false;
  TextEditingController _reg = TextEditingController();

  Future getvalues() async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _reg.text = prefs.getString('reg') ?? '';
  }

  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }

  void initState() {
    super.initState();
    netcheck().whenComplete(() => getvalues().whenComplete(() => (setState(() {
          initialized = true;
        }))));
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      if (checknet) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.collectionKEY)
              .doc('orders')
              .collection('orders')
              .orderBy("timestamp", descending: true)
              .where('reg', isEqualTo: _reg.text)
              .limit(25)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Error();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text('Order History'),
                ),
                body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        final doc_id = document.id;
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return InkWell(
                          splashColor: Colors.blue,
                          child: Card(
                              color: Colors.blue.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              elevation: 5,
                              //clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                      leading: Icon(
                                        (data['received'])
                                            ? Icons.check_circle
                                            : Icons.more_horiz_rounded,
                                        color: (data['received'])
                                            ? Colors.green
                                            : Colors.blueGrey,
                                        size: 40,
                                      ),
                                      title: Text(data['text'].toString()),
                                      subtitle: Text(
                                          'Total: Rs.${data['price'].toString()}'),
                                      trailing: (data['received'])
                                          ? null
                                          : IconButton(
                                              onPressed: () async {
                                                if (!await InternetConnectionChecker()
                                                    .hasConnection) {
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder:
                                                            (context, _, __) =>
                                                                Error(),
                                                        transitionDuration:
                                                            Duration(
                                                                seconds: 0),
                                                      ));
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return SimpleDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24)),
                                                            title: Center(
                                                                child: Text(
                                                                    'Confirm Cancel?')),
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      )),
                                                                  TextButton(
                                                                    child: Text(
                                                                      'YES!',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .collectionKEY)
                                                                          .doc(
                                                                              'orders')
                                                                          .collection(
                                                                              'orders')
                                                                          .doc(
                                                                              doc_id)
                                                                          .delete();
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          );
                                                        });
                                                      });
                                                }
                                              },
                                              icon: Icon(Icons.delete),
                                            )),
                                ],
                              )),
                        );
                      }).toList(),
                    )));
          },
        );
      } else {
        return Error();
      }
    }
    return Loading();
  }
}
