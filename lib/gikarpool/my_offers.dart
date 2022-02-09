import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'error_screen.dart';
import 'package:intl/intl.dart';
import 'loading.dart';
import 'package:firebase_core/firebase_core.dart';

class MyOffers extends StatefulWidget {
  final String Reg;

  const MyOffers({
    Key? key,
    required this.Reg,
  }) : super(key: key);

  @override
  _MyOffersState createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  bool checknet = false;
  bool initialized = false;
  int newSeats = 1;

  Future netcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    netcheck().whenComplete(
        () => Firebase.initializeApp().whenComplete(() => setState(() {
              initialized = true;
            })));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      if (checknet) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('001')
              .orderBy("DateAndTime", descending: true)
              .where('RegNo', isEqualTo: widget.Reg)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Error();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            if (snapshot.data!.docs.isEmpty) {
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    title: const Text('My Offered rides'),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.error_outline_rounded),
                        SizedBox(
                          height: 5,
                        ),
                        Text('No Rides Offered')
                      ],
                    ),
                  ));
            }
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: const Text('My Offered rides'),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    final docId = document.id;
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                        child: Card(
                            color: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            elevation: 5,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Center(
                                    child: Column(
                                      children: <Widget>[
                                        (data['FromOrTo'])
                                            ? Row(children: <Widget>[
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'GIKI  ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const Icon(Icons
                                                    .arrow_forward_outlined),
                                                Text(
                                                  '  ${data['City'].toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ])
                                            : Row(children: <Widget>[
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${data['City'].toString()}  ',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const Icon(Icons
                                                    .arrow_forward_outlined),
                                                const Text('  GIKI',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600))
                                              ]),
                                        const SizedBox(height: 10),
                                        Text(
                                          DateFormat.yMMMMEEEEd()
                                              .add_jm()
                                              .format(
                                                  data['DateAndTime'].toDate()),
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () async{
                                            if (!await InternetConnectionChecker()
                                                .hasConnection) {
                                              Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                      pageBuilder:
                                                          (context, _, __) =>
                                                              const Error(),
                                                      transitionDuration:
                                                          Duration(
                                                              seconds: 0)));
                                            } else {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        SimpleDialog(
                                                  title: Center(
                                                      child: Text(
                                                          'Confirm Remove Offer?')),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24)),
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    '001')
                                                                .doc(docId)
                                                                .delete();
                                                          },
                                                          child: const Text(
                                                            'YES!',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }),
                                      IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () async {
                                            if (!await InternetConnectionChecker()
                                                .hasConnection) {
                                              Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder:
                                                        (context, _, __) =>
                                                            const Error(),
                                                    transitionDuration:
                                                        Duration(seconds: 0),
                                                  ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return SimpleDialog(
                                                        title: Center(
                                                          child: Text(
                                                              'Seats Available: ${data['Seats']}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24)),
                                                        children: [
                                                          Center(
                                                              child: Column(
                                                            children: <Widget>[
                                                              const Text(
                                                                  'Pick new available seats',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              const SizedBox(
                                                                height: 50,
                                                              ),
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed: () => (newSeats <=
                                                                                1)
                                                                            ? null
                                                                            : setState(
                                                                                () {
                                                                                newSeats--;
                                                                              }),
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size:
                                                                              30,
                                                                        )),
                                                                    Text(
                                                                      newSeats
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30),
                                                                    ),
                                                                    IconButton(
                                                                        onPressed: () => (newSeats >=
                                                                                16)
                                                                            ? null
                                                                            : setState(
                                                                                () {
                                                                                newSeats++;
                                                                              }),
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              30,
                                                                        )),
                                                                  ]),
                                                              const SizedBox(
                                                                  height: 30),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'Cancel')),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (!await InternetConnectionChecker()
                                                                            .hasConnection) {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const Error()));
                                                                        } else {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  '001')
                                                                              .doc(
                                                                                  docId)
                                                                              .update({
                                                                            'Seats':
                                                                                newSeats
                                                                          });

                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {
                                                                            newSeats =
                                                                                1;
                                                                          });
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return StatefulBuilder(builder: (context, setState) {
                                                                                  return SimpleDialog(
                                                                                    title: Center(
                                                                                        child: Text(
                                                                                      'Successful!',
                                                                                      style: TextStyle(color: Colors.blue),
                                                                                    )),
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                                                                    children: [
                                                                                      Column(
                                                                                        children: <Widget>[
                                                                                          Center(
                                                                                            child: Icon(
                                                                                              Icons.check_circle_outline_rounded,
                                                                                              size: 80,
                                                                                              color: Colors.green,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                          Center(
                                                                                              child: Text(
                                                                                            'Seats Updated!',
                                                                                            style: TextStyle(fontSize: 20),
                                                                                          )),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                });
                                                                              });
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          'Update'))
                                                                ],
                                                              ),
                                                            ],
                                                          ))
                                                        ],
                                                      );
                                                    });
                                                  });
                                            }
                                          })
                                    ],
                                  ),
                                ])));
                  }).toList(),
                ),
              ),
            );
          },
        );
      } else {
        return Error();
      }
    }
    return Loading();
  }
}
