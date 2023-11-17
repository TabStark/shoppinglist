import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  late final String productName;
  // HomePage({Key? key, @required this.productName}) : super(key: key);
  HomePage(this.productName);
  @override
  State<HomePage> createState() => _HomePageState();

  Future<void> deleteCollection(_products) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(_products);

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference _products =
        FirebaseFirestore.instance.collection("${widget.productName}");

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

    //Create
    Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
      _nameController.text = "";
      _quantityController.text = "";
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    style: const TextStyle(fontSize: 21, fontFamily: 'Poppins'),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _quantityController,
                    decoration: const InputDecoration(
                        labelText: "quantity",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    style: const TextStyle(fontSize: 21, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final int? quantity =
                            int.tryParse(_quantityController.text);

                        if (quantity != null) {
                          await _products
                              .add({"name": name, "quantity": quantity});
                          Navigator.of(context).pop();
                          _nameController.text = "";
                          _quantityController.text = "";
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight),
                    ),
                  )
                ],
              ),
            );
          });
    }

    //Update
    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _nameController.text = documentSnapshot['name'];
        _quantityController.text = documentSnapshot['quantity'].toString();
      }

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
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    style: const TextStyle(fontSize: 21, fontFamily: 'Poppins'),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _quantityController,
                    decoration: const InputDecoration(
                        labelText: "quantity",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    style: const TextStyle(fontSize: 21, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final int? quantity =
                            int.tryParse(_quantityController.text);

                        if (quantity != null) {
                          await _products
                              .doc(documentSnapshot!.id)
                              .update({"name": name, "quantity": quantity});
                          Navigator.of(context).pop();
                          _nameController.text = "";
                          _quantityController.text = "";
                        }
                      },
                      child: Text("Update",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight),
                    ),
                  )
                ],
              ),
            );
          });
    }

    // Delete
    Future<void> _delete(String productId) async {
      await _products.doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have successfully deleted a product")));
    }

    return Scaffold(

        //  APPBAR
        appBar: AppBar(
          title: Text(
            widget.productName,
            style: TextStyle(
                fontFamily: 'KaushanScript',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
        ),

        //ADD DATA FLOATING BUTTON
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        //  BODY
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          documentSnapshot['name'],
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'Poppins'),
                        ),
                        subtitle: Text(
                          documentSnapshot['quantity'].toString(),
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'Poppins'),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => _update(documentSnapshot),
                                icon: const Icon(
                                  Icons.edit,
                                  size: 25,
                                ),
                              ),
                              IconButton(
                                  onPressed: () => _delete(documentSnapshot.id),
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 25,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
