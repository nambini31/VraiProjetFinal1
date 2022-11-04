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
  const Acceuil({super.key});

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

  Future getData() async {
    // Stream ping = Ping("197.7.2.146", count: 2).stream;

    // final subscription = ping.listen(null);
    // PingData rep;
    // subscription.onData((data) {
    //   rep = data;
    //   if (rep.error.toString() == "unknownHost") {
    //     print("error");
    //   } else {
    //     print("not error");
    //   }
    //   subscription.cancel();
    // });

    // try {
    //   final response = await http.get(Uri.parse("http://192.168.137.22/app/lib/php/select.php"));
    //   print("object");

    //   if (response.statusCode == 200) {

    //     print("avy a");
    //     setState(() {
    //       produitlist = json.decode(response.body);
    //     });
    //     print(produitlist[0]);
    //   } else {
    //     print("tsy avy");
    //   }
    // } catch (e) {
    //   print("erreur");
    // }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ACCEUIL"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Text("ate ${dateTime()}"),
            ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: Text("Charger"))
          ],
        ),
      ),
    );
  }
}
