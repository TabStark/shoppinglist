import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/providerfile.dart';
import 'splashscreen.dart';
import 'itemslist.dart';
import 'providerfile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColorLight: Colors.amber.shade300),
        home: const SplashScreen(),
      ),
    );
  }
}

class createCollection extends StatefulWidget {
  const createCollection({super.key});

  @override
  State<createCollection> createState() => _createCollectionState();
}

class _createCollectionState extends State<createCollection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _collectionPathController =
      TextEditingController();

  // Future<void> getData() async {
  //   QuerySnapshot querySnapshot = await _collectionReference.get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData);
  // }

  @override
  Widget build(BuildContext context) {
    final provi = Provider.of<WordProvider>(context);
    final CollectionNameList = provi.namewords;

    _newCollection() async {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                      controller: _collectionPathController,
                      decoration: InputDecoration(
                          labelText: "Collection Name",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      style:
                          const TextStyle(fontSize: 21, fontFamily: 'Poppins')),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_collectionPathController.text.isNotEmpty) {
                            var newCollectionName =
                                _collectionPathController.text;

                            FirebaseFirestore.instance
                                .collection(newCollectionName)
                                .add({"name": "Example", "quantity": 1})
                                .then((_) => print("New Collection created"))
                                .catchError((_) => print("Error occured"));

                            provi.getName(newCollectionName);
                            setState(() {});
                            Navigator.of(context).pop();
                            _collectionPathController.text = "";
                          }
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Poppins'),
                        )),
                  )
                ],
              ),
            );
          });
    }

    return Scaffold(
        //  APPBAR
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Shopping List",
            style: TextStyle(
                fontFamily: 'KaushanScript',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _newCollection();
              // provider.getName(_collectionPathController.text);
            });
          },
          label: Text(
            'Create a New Package',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: GridView.count(
                crossAxisCount: 2,
                children: CollectionNameList.map((value) => Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HomePage(value),
                                ));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            child: IconButton(
                                                onPressed: () {
                                                  provi.delete(value);
                                                  _callfutureMethod(value);
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(Icons.delete)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  // color: Colors.amber,
                                  height: 105,
                                  child: Center(
                                      child: Text(
                                    "${value}",
                                    style: TextStyle(fontSize: 18),
                                  ))),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 10)
                            ]),
                      ),
                    )).toList())));
  }

  Future<void> _callfutureMethod(String vel) async {
    HomePage myClassInstance = HomePage(vel);
    await myClassInstance.deleteCollection(vel);
  }
}
