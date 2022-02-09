import 'package:untitled/gikarpool/my_offers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'error_screen.dart';
import 'loading.dart';

class OfferRides extends StatefulWidget {
  @override
  FormState createState() {
    return FormState();
  }
}

class FormState extends State<OfferRides> {
  bool checknet = true;
  String name='';
  String phone='';
  String regno='';
  DateTime? date;
  TimeOfDay? time;
  DateTime? dateTime;
  String dropDownValue = 'Select City';
  String dropDownValuecar = 'Select Car Type';
  bool? isFROMGIKIselected;
  bool? isMALEselected;
  int seatsOffered = 1;
  bool initialized=false;
  TextEditingController _carNamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getvalues().whenComplete(() => setState((){initialized=true;}));
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate == null) return;

    return newDate;
  }

  Future pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 16, minute: 20);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute)
          : initialTime,
    );

    if (newTime == null) return;

    return newTime;
  }

  String getText() {
    if (dateTime == null) {
      return 'Select Date And Time Of Departure';
    } else {
      return DateFormat.yMMMMEEEEd().add_jm().format(dateTime!);
    }
  }

  Future getvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    phone = prefs.getString('phone') ?? '';
    regno = prefs.getString('reg') ?? '';
    isMALEselected=prefs.getBool('isMALEselected') ?? null;
    await Firebase.initializeApp();
  }

  onPressedDate() => pickDateTime(context);

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(initialized) {
      return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shrinkWrap: true,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              const Icon(
                Icons.time_to_leave,
                size: 40,
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Offer a Ride',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
            ]),
            const SizedBox(height: 33),
            const Text(
              'Please Fill Up The Following Details To Offer a Ride:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFD3F2FD),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFF0277BD),
                    width: 3,
                  )),
              child: Column(
                children: <Widget>[
                  RadioListTile(
                    groupValue: isFROMGIKIselected,
                    title: const Text('I Am Travelling From GIKI'),
                    value: true,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isFROMGIKIselected = newValue!;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: isFROMGIKIselected,
                    title: const Text('I Am Travelling To GIKI'),
                    value: false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isFROMGIKIselected = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose The City You Are Travelling To/From:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFD3F2FD),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF0277BD),
                    width: 3,
                  )),
              child: DropdownButton(
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                isExpanded: true,
                borderRadius: BorderRadius.circular(15),
                icon: const Icon(Icons.location_city),
                iconEnabledColor: const Color(0xFF42A5F5),
                dropdownColor: const Color(0xFFD3F2FD),
                items:
                mainCityList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      child: Text(value), value: value);
                }).toList(),
                value: dropDownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownValue = newValue!;
                  });
                },
              ),
            ),
            // const SizedBox(height: 20),
            // const Text(
            //   'Your Gender:',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // Container(
            //     decoration: BoxDecoration(
            //         color: const Color(0xFFD3F2FD),
            //         borderRadius: BorderRadius.circular(25),
            //         border: Border.all(
            //           color: const Color(0xFF0277BD),
            //           width: 3,
            //         )),
            //     child: Column(
            //       children: <Widget>[
            //         RadioListTile(
            //           groupValue: isMALEselected,
            //           title: Row(children: const <Widget>[
            //             Text('Male'),
            //             Icon(
            //               Icons.male,
            //               color: Colors.blue,
            //             )
            //           ]),
            //           value: true,
            //           onChanged: (bool? newValue) {
            //             setState(() {
            //               isMALEselected = newValue!;
            //             });
            //           },
            //         ),
            //         RadioListTile(
            //           groupValue: isMALEselected,
            //           title: Row(children: const <Widget>[
            //             Text('Female'),
            //             Icon(
            //               Icons.female,
            //               color: Colors.pink,
            //             )
            //           ]),
            //           value: false,
            //           onChanged: (bool? newValue) {
            //             setState(() {
            //               isMALEselected = newValue!;
            //             });
            //           },
            //         ),
            //       ],
            //     )),
            const SizedBox(height: 20),
            const Text(
              'Type/Build Of Your Vehicle:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFD3F2FD),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF0277BD),
                    width: 3,
                  )),
              child: DropdownButton(
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                isExpanded: true,
                borderRadius: BorderRadius.circular(15),
                icon: const Icon(Icons.time_to_leave),
                iconEnabledColor: const Color(0xFF42A5F5),
                dropdownColor: const Color(0xFFD3F2FD),
                items:
                typesOfCars.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      child: Text(value), value: value);
                }).toList(),
                value: dropDownValuecar,
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownValuecar = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressedDate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                primary: Colors.blue.shade300,
              ),
              child: FittedBox(
                child: Text(
                  getText(),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Seats To Offer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(
                width: 10,
                padding:
                const EdgeInsets.symmetric(horizontal: 70, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFD3F2FD),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF0277BD),
                      width: 3,
                    )),
                child: NumberPicker(
                    minValue: 1,
                    maxValue: 16,
                    value: seatsOffered,
                    haptics: true,
                    onChanged: (value) =>
                        setState(() {
                          seatsOffered = value;
                        }))),
            const SizedBox(height: 20),
            const Text(
              'You may provide the Name/Model/Registration Number of Your Car:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(
                width: 10,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFD3F2FD),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF0277BD),
                      width: 3,
                    )),
                child: TextField(
                  controller: _carNamecontroller,
                  decoration: InputDecoration(hintText: 'Additional Details (optional)',),
                  onChanged: (value) {},
                ),),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(10, 40),
                      elevation: 6,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      textStyle: const TextStyle(fontSize: 18)),
                  child: const Text('Offer Ride'),
                  onPressed: (isFROMGIKIselected == null ||
                      isMALEselected == null ||
                      dropDownValue == 'Select City' ||
                      dropDownValuecar == 'Select Car Type' ||
                      dateTime == null)
                      ? null
                      : () async {
                    if (!await InternetConnectionChecker()
                        .hasConnection) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context,_,__) => const Error(),
                              transitionDuration: Duration(seconds: 0),));
                    } else {
                      FirebaseFirestore.instance
                          .collection('001')
                          .add(<String, dynamic>{
                        'Name': name,
                        'RegNo': regno,
                        'PhoneNo': phone,
                        'Gender': (isMALEselected!) ? 'Male' : 'Female',
                        'FromOrTo': isFROMGIKIselected,
                        'City': dropDownValue,
                        'DateAndTime': dateTime,
                        'NameOfCar': _carNamecontroller.text,
                        'Seats': seatsOffered,
                        'TypeOfCar': dropDownValuecar,
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder:
                                    (context, setState) {
                                  return SimpleDialog(
                                    children: [
                                      Center(
                                        child:Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 80,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Center(child: Text('Ride Offered',
                                      style: TextStyle(fontSize: 20),)),
                                      SizedBox(height: 30,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              onPressed:(){
                                                Navigator.pop(context);
                                              },
                                              child: Text('Go Back')),
                                          SizedBox(width: 20),
                                          Builder(
                                            builder: (context) =>
                                                ElevatedButton(
                                                  child: Text('My Offers'),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                            pageBuilder: (context,_,__) =>
                                                                MyOffers(Reg: regno),
                                                          transitionDuration: Duration(seconds: 0),));

                                                  },
                                                ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          });
                      setState((){
                        date=null;
                        time=null;
                        dateTime=null;
                        dropDownValue = 'Select City';
                        dropDownValuecar = 'Select Car Type';
                        isFROMGIKIselected=null;
                        isMALEselected=null;
                        seatsOffered = 1;
                        _carNamecontroller.clear();
                      });
                    }
                  }),
            ),
          ],
        );
    }
    else{
      return Loading();
    }
  }
}

final List<String> mainCityList = [
  'Select City',
  "Abbottabad",
  "Ahmedpur East",
  "Attock",
  "Bahawalnagar",
  "Bahawalpur",
  "Burewala",
  "Chakwal",
  "Chiniot",
  "Chishtian",
  "Dadu",
  "Daska",
  "Dera Ghazi Khan",
  "Dera Ismail Khan",
  "Faisalabad",
  "Ferozwala",
  "Gojra",
  "Gujranwala",
  "Gujrat",
  "Hafizabad",
  "Hub",
  "Hyderabad",
  "Islamabad",
  "Jacobabad",
  "Jaranwala",
  "Jhang",
  "Jhelum",
  "Kamalia",
  "Karachi",
  "Kasur",
  "Khairpur",
  "Khanewal",
  "Khanpur",
  "Khuzdar",
  "Kohat",
  "Kot Abdul Malik",
  "Kot Addu",
  "Kotri",
  "Kāmoke",
  "Lahore",
  "Larkana",
  "Layyah",
  "Mandi Bahauddin",
  "Mansehra",
  "Mardan",
  "Mingora",
  "Mirpur",
  "Mirpur Khas",
  "Multan",
  "Muridke",
  "Muzaffarabad",
  "Muzaffargarh",
  "Nawabshah",
  "Okara",
  "Pakpattan",
  "Peshawar",
  "Quetta",
  "Rahim Yar Khan",
  "Rawalpindi",
  "Sadiqabad",
  "Sahiwal",
  "Samundri",
  "Sargodha",
  "Sheikhupura",
  "Shikarpur",
  "Sialkot",
  "Sukkur",
  "Tando Adam",
  "Tando Allahyar",
  "Turbat",
  "Umerkot",
  "Vehari",
  "Wah Cantt",
  "Wazirabad",
];
final List<String> typesOfCars = [
  'Select Car Type',
  'Small Car',
  'Sedan',
  '5-seater SUV',
  '7-seater SUV',
  '5-seater hatchback',
  '7-seater hatchback',
  'Hi-ace',
  'Hi-roof/Bolan'
];
