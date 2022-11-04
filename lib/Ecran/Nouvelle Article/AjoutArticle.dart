import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Article_Concurent extends StatefulWidget {
  const Article_Concurent({super.key});

  @override
  State<Article_Concurent> createState() => _Article_ConcurentState();
}

class _Article_ConcurentState extends State<Article_Concurent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          //key: formValide,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            //padding: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.width / 15, 30, MediaQuery.of(context).size.width / 15),
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              height: MediaQuery.of(context).size.height,
              //color: Colors.black,

              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset(
                          "lib\\image\\varika1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Text(
                        "Utilisateur",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(221, 44, 42, 42)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 19),
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only (top: 19),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(29)),
                          //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                          //labelText: "Nom",
                          hintText: "Entrer votre matricule",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre nom" : null,
                        onSaved: (newValue) {},
                        //onSubmitted: submit,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 19),
                        onChanged: (value) {},
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre mot de passe" : null,
                        onSaved: (newValue) {},
                        decoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(top: 20),

                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(29)),

                            //labelText: "mot de passe",
                            hintText: "Entrer votre mot de passe",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {},
                              child: false
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                    ),
                            )),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 243, 63, 146))),
                            child: Text("Connecter", style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 40)),
                      Container(
                        width: 140,
                        decoration: BoxDecoration(color: Color.fromARGB(255, 3, 31, 52), borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                          "lib\\image\\logoinfo.png",
                          fit: BoxFit.none,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
