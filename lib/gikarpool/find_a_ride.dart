import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'rides_found.dart';

class FindRides extends StatefulWidget {
  const FindRides({Key? key}) : super(key: key);

  @override
  FormState createState() {
    return FormState();
  }
}

class FormState extends State<FindRides> {
  bool checknet = true;
  String dropDownValue = "Select City";
  bool? isFROMGIKIselected;
  String? isMALEselected;
  DateTime? date;
  DateTime? tempDateTime = DateTime.now();
  bool dateOrNot = false;

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  onPressedDate() => pickDate(context);

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.hail,
                  size: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Find a Ride',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                )
              ]),
          const SizedBox(height: 33),
          const Text(
            'Please Fill Up The Following Details To Find a Ride:',
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
                  title: const Text('I Want To Travel From GIKI'),
                  value: true,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isFROMGIKIselected = newValue!;
                    });
                  },
                ),
                RadioListTile(
                  groupValue: isFROMGIKIselected,
                  title: const Text('I Want To Travel To GIKI'),
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
              items: mainCityList.map<DropdownMenuItem<String>>((String value) {
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
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Preferred Gender To Carpool With:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
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
                    groupValue: isMALEselected,
                    title: Row(children: const <Widget>[
                      Text('Male'),
                      Icon(
                        Icons.male,
                        color: Colors.blue,
                      )
                    ]),
                    value: 'Male',
                    onChanged: (String? newValue) {
                      setState(() {
                        isMALEselected = newValue!;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: isMALEselected,
                    title: Row(children: const <Widget>[
                      Text('Female'),
                      Icon(
                        Icons.female,
                        color: Colors.pink,
                      )
                    ]),
                    value: 'Female',
                    onChanged: (String? newValue) {
                      setState(() {
                        isMALEselected = newValue!;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: isMALEselected,
                    title: Row(
                      children: const <Widget>[
                        Text('Any  '),
                        Icon(
                          Icons.male,
                          color: Colors.blue,
                        ),
                        Text('/'),
                        Icon(Icons.female, color: Colors.pink)
                      ],
                    ),
                    value: 'Any',
                    onChanged: (String? newValue) {
                      setState(() {
                        isMALEselected = newValue!;
                      });
                    },
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFD3F2FD),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF0277BD),
                    width: 3,
                  )),
              child: Column(children: <Widget>[
                SwitchListTile(
                  title: const Text(
                    'Find Rides On a Specific Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  value: dateOrNot,
                  onChanged: (bool value) {
                    setState(() {
                      dateOrNot = value;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today_rounded,
                      color: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: (dateOrNot) ? onPressedDate : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    minimumSize: const Size.fromHeight(40),
                    primary: Colors.blue.shade300,
                  ),
                  child: Text(
                    getText(),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ])),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(10, 40),
                    elevation: 6,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    textStyle: const TextStyle(fontSize: 18)),
                child: const Text('Find Rides'),
                onPressed: (isMALEselected == null ||
                        isFROMGIKIselected == null ||
                        dropDownValue == 'Select City' ||
                        (dateOrNot == true && date == null))
                    ? null
                    : () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, _, __) => RidesFound(
                                dropDownValue: dropDownValue,
                                isMALEselected: isMALEselected!,
                                isFROMGIKIselected: isFROMGIKIselected!,
                                dateOrNot: dateOrNot,
                                date: date,
                              ),
                              transitionDuration: Duration(seconds: 0),
                            ));
                      }),
          ),
        ],
      ),
    );
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
