// // ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unrelated_type_equality_checks, unused_local_variable

// import 'dart:convert';

// import 'package:app/Ecran/Pages/AucuneDonnes.dart';
// import 'package:app/Ecran/Pages/ListesTop1000.dart';
// import 'package:app/Ecran/Pages/index.dart';
// import 'package:app/Ecran/Pages/staticNavigation.dart';
// import 'package:app/Ecran/Pages/two_letter_icon.dart';
// import 'package:app/Ecran/modele/dataPreparation.dart';
// import 'package:app/Ecran/modele/dataTop1000.dart';
// import 'package:app/Ecran/modele/database_Helper.dart';
// import 'package:app/Ecran/modele/magasin.dart';
// import 'package:app/Ecran/modele/preparation.dart';
// import 'package:app/Ecran/modele/top1000.dart';
// import 'package:app/Ecran/modele/top1000.dart';
// import 'package:app/Ecran/modele/zone.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:http/http.dart' as http;

// class ListesPreparation extends StatefulWidget {
//   @override
//   State<ListesPreparation> createState() => _ListesPreparationState();
// }

// class _ListesPreparationState extends State<ListesPreparation> {
//   List<Preparation> listesToutes = [];
//   List<Preparation> listesAttente = [];
//   List<Preparation> listesValider = [];
//   List<Preparation> listesTransferer = [];

//   // String news = "";
//   // String news1 = "";
//   // int id = 0;
//   bool top = false;
//   bool etat = false;
//   String ip = "197.7.2.146";
//   int i = 0;

 

//   Future recuperer() async {
//     await DataPreparation().SelectAll().then((value) {
//       // //print()
//       setState(() {
//         listesToutes = value;
//       });
//     });
//     await DataPreparation().SelectAttente().then((value) {
//       // //print()
//       setState(() {
//         listesAttente = value;
//       });
//     });
//     await DataPreparation().SelectValider().then((value) {
//       // //print()
//       setState(() {
//         listesValider = value;
//       });
//     });
//     await DataPreparation().SelectTransferer().then((value) {
//       // //print()
//       setState(() {
//         listesTransferer = value;
//       });
//     });
//   } // //print

  

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     recuperer();
//     print(Navigation.variable);
//   }

//   Future search(String txt) async {
//     if (i == 0) {
//       await DataPreparation().SearchAll(txt).then((value) {
//         // //print()
//         setState(() {
//           listesToutes = value;
//         });
//       });
//     } else if (i == 1) {
//       await DataPreparation().SearchAttente(txt).then((value) {
//         // //print()
//         setState(() {
//           listesAttente = value;
//         });
//       });
//     } else if (i == 2) {
//       await DataPreparation().SearchValider(txt).then((value) {
//         // //print()
//         setState(() {
//           listesValider = value;
//         });
//       });
//     } else {
//       await DataPreparation().SearchTransferer(txt).then((value) {
//         // //print()
//         setState(() {
//           listesTransferer = value;
//         });
//       });
//     }
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return WillPopScope(
//   //     onWillPop: () => ,
//   //     child: Center(
//   //       child: preparation(),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => exitApp(),
//       child: GestureDetector(
//           onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//           child: Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: Text("Relever de prix"),
//               actions: [
//                 IconButton(
//                     onPressed: () async {
//                       await DataPreparation().Charger(ip);

//                       recuperer();
//                     },
//                     icon: Icon(Icons.get_app_sharp))
//               ],
//               automaticallyImplyLeading: false,
//             ),
//             body: DefaultTabController(
//               length: 4,
//               initialIndex: 0,
//               child: Scaffold(
//                 appBar: PreferredSize(
//                   preferredSize: Size.fromHeight(110),
//                   child: AppBar(
//                     automaticallyImplyLeading: false,
//                     titleSpacing: 15,
//                     title: Container(
//                       height: 40,
//                       margin: EdgeInsets.only(top: 10),
//                       child: TextFormField(
//                         onChanged: (value) {
//                           setState(() {
//                             search(value);
//                           });
//                         },
//                         keyboardType: TextInputType.visiblePassword,
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.all(2),
//                           prefixIcon: Icon(Icons.search),
//                           prefixIconColor: Colors.grey,
//                           hintText: "Rechercher",
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
//                         ),
//                       ),
//                     ),
//                     bottom: TabBar(
//                         onTap: (value) {
//                           setState(() {
//                             i = value;
//                           });
//                         },
//                         // ignore: prefer_const_literals_to_create_immutables
//                         tabs: [
//                           Tab(
//                             text: "Tous",
//                           ),
//                           Tab(
//                             text: "Attente",
//                           ),
//                           Tab(
//                             text: "Valider",
//                           ),
//                           Tab(
//                             text: "Transferer",
//                           )
//                         ]),
//                   ),
//                 ),
//                 body: Container(
//                   margin: EdgeInsets.only(top: 10),
//                   child: TabBarView(physics: BouncingScrollPhysics(), children: [
//                     preparationToutes(),
//                     preparationAttente(),
//                     preparationValider(),
//                     preparationTransferer(),
//                   ]),
//                 ),
//               ),
//             ),
//           )),
//     );
//   }

  

 

  
  
//   Future<bool> exitApp() async {
//     bool appExit = await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: ((BuildContext context) {
//           return AlertDialog(
//             title: Text("Voulez vous vraiment quitter ?"),
//             actionsAlignment: MainAxisAlignment.end,
//             actions: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 100,
//                       child: TextButton(
//                           style: ButtonStyle(
//                               foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
//                           onPressed: () {
//                             Navigator.pop(context, false);
//                           },
//                           child: Text("Annuler")),
//                     ),
//                     SizedBox(
//                       width: 30,
//                     ),
//                     Container(
//                       width: 100,
//                       child: TextButton(
//                           style: ButtonStyle(
//                               foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
//                           onPressed: () {
//                             Navigator.pop(context);
//                             // DataPreparation().DeletePreparation(prep.id_prep);
//                             // recuperer();
//                             Navigator.of(context).pop(true);
//                           },
//                           child: Text("Oui")),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           );
//         }));
//     return appExit;
//   }
// }
