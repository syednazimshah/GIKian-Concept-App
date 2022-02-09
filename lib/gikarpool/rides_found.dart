import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'error_screen.dart';
import 'loading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import'ride detail.dart';

class RidesFound extends StatefulWidget {
  final String dropDownValue;
  final bool isFROMGIKIselected;
  final String isMALEselected;
  final bool dateOrNot;
  final DateTime? date;

  const RidesFound({
    Key? key,
    required this.date,
    required this.isMALEselected,
    required this.dateOrNot,
    required this.dropDownValue,
    required this.isFROMGIKIselected,
  }) : super(key: key);

  @override
  RidesFoundState createState() {
    return RidesFoundState();
  }
}

class RidesFoundState extends State<RidesFound> {
  bool checknet=true;
  bool initialized=false;
  Future internetcheck() async {
    checknet = await InternetConnectionChecker().hasConnection;
  }

  DateTime nextDate() {
    DateTime tempNext;
    tempNext = widget.date!.add(const Duration(days: 1));
    return tempNext;
  }
  void initState(){
    super.initState();
    internetcheck().whenComplete(() => Firebase.initializeApp().whenComplete(() => setState((){initialized=true;})));
  }
  @override
  Widget build(BuildContext context) {
    if(initialized) {
      if(checknet) {
        return StreamBuilder<QuerySnapshot>(
          stream: (widget.dateOrNot)
              ? (widget.isMALEselected == 'Any')
              ? FirebaseFirestore.instance
              .collection('001')
              .orderBy("DateAndTime", descending: true)
              .where('FromOrTo', isEqualTo: widget.isFROMGIKIselected)
              .where('City', isEqualTo: widget.dropDownValue)
              .where('DateAndTime', isGreaterThanOrEqualTo: widget.date)
              .where('DateAndTime', isLessThan: nextDate())
              .snapshots()
              : FirebaseFirestore.instance
              .collection('001')
              .orderBy("DateAndTime", descending: true)
              .where('FromOrTo', isEqualTo: widget.isFROMGIKIselected)
              .where('Gender', isEqualTo: widget.isMALEselected)
              .where('City', isEqualTo: widget.dropDownValue)
              .where('DateAndTime', isGreaterThanOrEqualTo: widget.date)
              .where('DateAndTime', isLessThan: nextDate())
              .snapshots()
              : (widget.isMALEselected == 'Any')
              ? FirebaseFirestore.instance
              .collection('001')
              .orderBy("DateAndTime", descending: true)
              .where('FromOrTo', isEqualTo: widget.isFROMGIKIselected)
              .where('City', isEqualTo: widget.dropDownValue)
              .snapshots()
              : FirebaseFirestore.instance
              .collection('001')
              .orderBy("DateAndTime", descending: true)
              .where('Gender', isEqualTo: widget.isMALEselected)
              .where('FromOrTo', isEqualTo: widget.isFROMGIKIselected)
              .where('City', isEqualTo: widget.dropDownValue)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Error();
            }
            if (!checknet) {
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
                    title: const Text('Available Rides'),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.error_outline_rounded),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Sorry, No Rides Available :(')
                      ],
                    ),
                  ));
            } else {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: const Text('Available Rides'),
                ),
                body: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: ListView(
                    shrinkWrap: true,
                    children:
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                      return InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return SimpleDialog(
                                    backgroundColor: Colors.amber.shade50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24)),
                                    children: [
                                      RideDetailCard(
                                        name: data['Name'],
                                        gender: data['Gender'],
                                        regno: data['RegNo'],
                                        phone: data['PhoneNo'],
                                        fromOrTo: data['FromOrTo'],
                                        city: data['City'],
                                        date: data['DateAndTime'].toDate(),
                                        nameOfCar: data['NameOfCar'],
                                        seats: data['Seats'],
                                        type: data['TypeOfCar'],
                                      )
                                    ],
                                  );
                                });
                          });
                        },
                        splashColor: Colors.blue,
                        child: Card(
                          color: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 5,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 10),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                title: (widget.isFROMGIKIselected)
                                    ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text('GIKI ', style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),),
                                      const Icon(
                                        Icons.arrow_forward_outlined,
                                        size: 25,),
                                      Text(' ${data['City'].toString()}',
                                        style: const TextStyle(fontSize: 25,
                                            fontWeight: FontWeight.w600),)
                                    ])
                                    : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('${data['City'].toString()} ',
                                        style: const TextStyle(fontSize: 25,
                                            fontWeight: FontWeight.w600),),
                                      const Icon(
                                          Icons.arrow_forward_outlined,
                                          size: 25),
                                      const Text(' GIKI', style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600))
                                    ]),
                                subtitle: Column(children: <Widget>[
                                  const SizedBox(height: 10),
                                  Text(
                                    '${DateFormat.yMMMMEEEEd().add_jm().format(
                                        data['DateAndTime'].toDate())}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Tap to see Details',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
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
