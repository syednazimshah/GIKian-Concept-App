import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading.dart';

class UserForm extends StatefulWidget {
  @override
  FormState createState() {
    return FormState();
  }
}

class FormState extends State<UserForm> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _reg = TextEditingController();
  bool initialized = false;
  bool? isMALEselected;

  @override
  void initState() {
    super.initState();
    getvalues().whenComplete(() => setState(() {
          initialized = true;
        }));
  }

  Future getvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name.text = prefs.getString('name') ?? '';
    _phone.text = prefs.getString('phone') ?? '';
    _address.text = prefs.getString('address') ?? '';
    _reg.text = prefs.getString('reg') ?? '';
    isMALEselected=prefs.getBool('isMALEselected') ?? null;
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Enter your Info'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle_rounded),
                  suffixIcon: _name.text.isEmpty
                      ? Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        )
                      : null,
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                  errorText:
                      _name.text.isEmpty ? 'Please enter your Name' : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: RadioListTile(
                          groupValue: isMALEselected,
                          title: Row(children: const <Widget>[
                            Text('Male'),
                            Icon(Icons.male,)
                          ]),
                          value: true,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isMALEselected = newValue!;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: RadioListTile(
                          groupValue: isMALEselected,
                          title: Row(children: const <Widget>[
                            Text('Female'),
                            Icon(Icons.female,)
                          ]),
                          value: false,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isMALEselected = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
              ),
              TextFormField(
                controller: _reg,
                decoration: InputDecoration(
                  icon: Icon(Icons.app_registration_rounded),
                  suffixIcon: _reg.text.isEmpty
                      ? Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        )
                      : null,
                  border: UnderlineInputBorder(),
                  labelText: 'Registration/Faculty Number',
                  errorText: _reg.text.isEmpty
                      ? 'Please enter your Registration/Faculty Number'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.local_phone_rounded),
                  suffixIcon: _phone.text.isEmpty
                      ? Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        )
                      : null,
                  border: UnderlineInputBorder(),
                  labelText: 'Phone#',
                  errorText: _phone.text.isEmpty
                      ? 'Please Enter your Phone Number'
                      : null,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _address,
                decoration: InputDecoration(
                  icon: Icon(Icons.location_on_outlined),
                  suffixIcon: _address.text.isEmpty
                      ? Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        )
                      : null,
                  border: UnderlineInputBorder(),
                  labelText: 'Address/Hostel',
                  errorText: _address.text.isEmpty
                      ? 'Please enter your Address/Hostel'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: (_name.text.isEmpty ||
                              _phone.text.isEmpty ||
                              _address.text.isEmpty ||
                              _reg.text.isEmpty||(isMALEselected==null))
                          ? Text('Cancel')
                          : Text('Go Back')),
                  Builder(
                    builder: (context) => ElevatedButton(
                      child: Text('Submit'),
                      onPressed: (_name.text.isEmpty ||
                              _phone.text.isEmpty ||
                              _address.text.isEmpty ||
                              _reg.text.isEmpty||(isMALEselected==null))
                          ? null
                          : () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('name', _name.text);
                              await prefs.setString('phone', _phone.text);
                              await prefs.setString('address', _address.text);
                              await prefs.setString('reg', _reg.text);
                              await prefs.setBool('isMALEselected',isMALEselected??true);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                content: Text('Saved Successfully'),
                                duration: Duration(milliseconds: 650),
                              ));
                            },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    return Loading();
  }
}
