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
  @override
  void initState() {
    super.initState();
  }

  String dateTime() {
    var date = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("ate ${dateTime()}"),
    );
  }
}
