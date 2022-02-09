import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RideDetailCard extends StatefulWidget {
  final String name;
  final String regno;
  final String phone;
  final bool fromOrTo;
  final String gender;
  final String city;
  final DateTime date;
  final String nameOfCar;
  final int seats;
  final String type;

  const RideDetailCard({
    Key? key,
    required this.date,
    required this.gender,
    required this.name,
    required this.phone,
    required this.fromOrTo,
    required this.city,
    required this.nameOfCar,
    required this.seats,
    required this.type,
    required this.regno,
  }) : super(key: key);

  @override
  RideDetailsState createState() => RideDetailsState();
}

class RideDetailsState extends State<RideDetailCard> {
  String notGiven = 'Not Specified';

  @override
  Widget build(BuildContext context) {
    return Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 0,
                child: Container(
                    child: Column(
                      children: <Widget>[
                        (widget.fromOrTo)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'GIKI ',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                  ),
                                  const Icon(Icons.arrow_forward_outlined,size: 25,color: Colors.blue,),
                                  Text(
                                    ' ${widget.city}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                  )
                                ])
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${widget.city} ',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,color: Colors.blue,),
                                  ),
                                  const Icon(Icons.arrow_forward_outlined,size:25,color: Colors.blue,),
                                  const Text(' GIKI',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,color: Colors.blue,)),
                                ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat.yMMMMEEEEd().add_jm().format(widget.date),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15,color: Colors.blue,),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Ride Details:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Name: ${widget.name}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Phone: ${widget.phone}',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Reg No: ${widget.regno}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Gender: ${widget.gender}',
                          style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Car Type: ${widget.type}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (widget.nameOfCar == "")
                            ? Text(
                          'Details: $notGiven',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        )
                            : Text(
                          'Details: ${widget.nameOfCar}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Seats: ${widget.seats} Available',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        Center(
                          child: TextButton.icon(
                            label:Text('Call Now',style: TextStyle(color: Colors.blue,fontSize: 25),),
                            onPressed: () {
                              launch('tel://${widget.phone}');
                            },
                            icon: const Icon(
                              Icons.phone_in_talk_rounded,
                              size: 45,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    )),
              );
  }
}