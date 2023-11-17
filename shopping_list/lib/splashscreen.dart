import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'itemslist.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => createCollection(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColorLight,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag,
                color: Colors.black,
                size: 60,
              ),
              Text(
                "Shopping List",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontFamily: "KaushanScript",
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
