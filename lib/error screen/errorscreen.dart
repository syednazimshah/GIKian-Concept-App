import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            color: Colors.red[700],
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      'Error Occured!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(height: 40,),
                    Text(
                      'Check your connection',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      'Try again later',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    )

                  ],
                )
            ),
          ),
        );
  }
}