// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/Ecran/modele/dataMagasin.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Acceuil extends StatefulWidget {
  double start = 0;
  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  List produitlist = [];
  late Socket socket;

  String dateTime() {
    var date = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  // int start = 0;
  //
  // late Timer time;
  // void startTime() {
  //   time = Timer.periodic(
  //     Duration(seconds: 1),
  //     (timer) {
  //       if (start == 1) {
  //         setState(() {
  //           end = false;
  //           start = 0;
  //         });
  //         time.cancel();
  //       } else {
  //         start++;
  //         setState(() {
  //           end = true;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("ghghh"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [Text("ate ${dateTime()}"), ElevatedButton(onPressed: () {}, child: Text("Charger"))],
          ),
        ),
      ),
    );
  }

  Future<bool> exitApp() async {
    bool appExit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text("Voulez vous vraiment quitter ?"),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("Annuler")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            // DataPreparation().DeletePreparation(prep.id_prep);
                            // recuperer();
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Oui")),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
    return appExit;
  }
}
