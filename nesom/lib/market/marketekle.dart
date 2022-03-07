// main.dart
// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebasemarketekle extends StatefulWidget {
  const Firebasemarketekle({Key? key}) : super(key: key);

  @override
  _FirebasemarketekleState createState() => _FirebasemarketekleState();
}

class _FirebasemarketekleState extends State<Firebasemarketekle> {
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _puanController = TextEditingController();

  final CollectionReference _noktaadi =
      FirebaseFirestore.instance.collection('marketler');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _puanController.text = documentSnapshot['puan'].toString();
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
                  decoration: const InputDecoration(labelText: 'Market adı'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    const double? puan =
                        5; //double.tryParse(_puanController.text);
                    if (name != null) {
                      if (action == 'create') {
                        await _noktaadi.add({"name": name, "puan": puan});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _noktaadi
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "puan": puan});
                      }
                      _nameController.text = '';
                      _puanController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    await _noktaadi.doc(productId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Kafenizi sildiniz.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Ekle'),
      ),
      body: StreamBuilder(
        stream: _noktaadi.snapshots(),
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
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['puan'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: const [],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
