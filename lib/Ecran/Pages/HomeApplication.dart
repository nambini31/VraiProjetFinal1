// ignore_for_file: prefer_const_constructors

//import 'package:app/Ecran/authentification/login.dart';
import 'package:app/Ecran/Pages/ListesMagasin.dart';
import 'package:app/Ecran/Pages/index.dart';
import 'package:flutter/material.dart';

class HomeApplication extends StatefulWidget {
  const HomeApplication({super.key});

  @override
  State<HomeApplication> createState() => _HomeApplicationState();
}

class _HomeApplicationState extends State<HomeApplication> {
  @override
  Widget build(BuildContext context) {
    return Index(0);
  }
}
