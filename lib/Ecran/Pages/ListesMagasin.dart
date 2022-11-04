// // ignore_for_file: prefer_const_constructors, non_constant_identifier_names

// import 'dart:io';
// import 'package:app/Ecran/Pages/AucuneDonnes.dart';
// import 'package:app/Ecran/Pages/ListesNouveauArticle.dart';
// import 'package:app/Ecran/Ajout/AjoutNouveauArticle.dart';
// import 'package:app/Ecran/Pages/index.dart';
// import 'package:app/Ecran/modele/dataMagasin.dart';
// import 'package:app/Ecran/modele/database_Helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:image_picker/image_picker.dart';
// import 'two_letter_icon.dart';
// import '../modele/magasin.dart';

// class ListesMagasin extends StatefulWidget {
//   const ListesMagasin({super.key});

//   @override
//   State<ListesMagasin> createState() => _PagesListeState();
// }

// enum Actions { Update, Delete }

// class _PagesListeState extends State<ListesMagasin> {
//   TextEditingController nom = TextEditingController();
//   TextEditingController nom1 = TextEditingController();
//   List<Item> listes = [];

//   String news = "";
//   String news1 = "";

//   void recuperer() async {
//     await dataItem().SelectAll().then((value) {
//       listes = value;
//       setState(() => listes);
//     });
//   }

//   //SlidableController final  =  SlidableController ();

//   @override
//   void initState() {
//     // TODO: implement initStatess
//     super.initState();
//     recuperer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Listes des Magasins"),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ListesNouveauArticle(),
//                     ));
//               },
//               icon: IconButton(onPressed: alert, icon: Icon(Icons.add))),
//         ],
//       ),
//       body: GestureDetector(
//           onTap: () {
//             //print("clicked");
//             //Slidable.of(context)!.close(duration: Duration(seconds: 0));
//           },
//           child: SlidableAutoCloseBehavior(
//             closeWhenOpened: true,
//             closeWhenTapped: true,
//             child: Center(
//               child: (listes.isEmpty)
//                   ? AucuneDonnes()
//                   : ListView.builder(
//                       itemCount: listes.length,
//                       itemBuilder: (context, index) {
//                         Item item = listes[index];
//                         return SingleChildScrollView(
//                           child: Slidable(
//                             endActionPane: ActionPane(motion: ScrollMotion(), extentRatio: 0.5, children: [
//                               SlidableAction(
//                                 onPressed: (context) {
//                                   alerte1(item);
//                                 },
//                                 label: "Delete",
//                                 backgroundColor: Colors.red,
//                                 icon: Icons.delete,
//                               ),
//                               Padding(padding: EdgeInsets.all(2)),
//                               SlidableAction(
//                                 onPressed: (context) {
//                                   nom1.text = item.design_enseigne;
//                                   alertmodif(item);
//                                 },
//                                 label: "Update",
//                                 backgroundColor: Colors.blue,
//                                 icon: Icons.update,
//                               )
//                             ]),
//                             child: ListTile(
//                                 onTap: () {},
//                                 title: Text(item.design_enseigne),
//                                 subtitle: Text(item.id_enseigne.toString()),
//                                 leading: TwoLetterIcon(
//                                   item.design_enseigne,
//                                 ),
//                                 trailing: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward))),
//                           ),
//                         );
//                       }),
//             ),
//           )),
//     );
//   }

//   Future alert() async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: Container(
//           //width: 100,
//           height: 120,
//           padding: EdgeInsets.fromLTRB(0, 10, 0, 0),

//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 45,
//                 child: TextFormField(
//                   onChanged: (value) {
//                     setState(() {
//                       news = value;
//                     });
//                   },
//                   controller: nom,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(2),
//                       filled: true,
//                       prefixIcon: Icon(Icons.article),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton.icon(
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStatePropertyAll(Colors.blue), foregroundColor: MaterialStatePropertyAll(Colors.white)),
//                       onPressed: () {
//                         Item item = Item();
//                         item.design_enseigne = news;
//                         dataItem().AjoutItem(item);

//                         recuperer();
//                         Navigator.pop(context);
//                         setState(() {
//                           nom.text = "";
//                         });
//                       },
//                       icon: Icon(Icons.add_outlined),
//                       label: Text("Ajouter")),
//                   Padding(padding: EdgeInsets.all(5)),
//                   TextButton.icon(
//                       style:
//                           ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red), foregroundColor: MaterialStatePropertyAll(Colors.white)),
//                       onPressed: () {
//                         setState(() {
//                           nom.text = "";
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.cancel),
//                       label: Text("Annuler")),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future alertmodif(Item item) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => SimpleDialog(
//         children: [
//           Container(
//             padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 45,
//                   child: TextFormField(
//                     onChanged: (value) {
//                       setState(() {
//                         news1 = value;
//                       });
//                     },
//                     controller: nom1,
//                     keyboardType: TextInputType.visiblePassword,
//                     decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(2),
//                         filled: true,
//                         prefixIcon: Icon(Icons.person),
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               item.design_enseigne = news1;
//                               dataItem().UpdateItem(item);
//                               //print("Modif");
//                               //print(news1);
//                               recuperer();
//                             },
//                             child: Text("Update")),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text(
//                               "Cancel",
//                             ))
//                       ],
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future alerte1(Item item) async {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: ((BuildContext context) {
//           return SimpleDialog(
//             title: Text(
//               "simple dialog",
//               style: TextStyle(),
//             ),
//             contentPadding: EdgeInsets.all(10),
//             children: [
//               Text("Suppression definitive"),
//               SizedBox(
//                 width: 5,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         dataItem().DeleteItem(item.id_enseigne);
//                         recuperer();
//                       },
//                       child: Text("OUI")),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   ElevatedButton(
//                       style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Non",
//                       ))
//                 ],
//               )
//             ],
//           );
//         }));
//   }
// }
