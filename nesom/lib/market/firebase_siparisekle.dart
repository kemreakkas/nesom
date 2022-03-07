// main.dart
// ignore_for_file: unused_element

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebasekuryekabul extends StatefulWidget {
  const Firebasekuryekabul({Key? key}) : super(key: key);

  @override
  _FirebasekuryekabulState createState() => _FirebasekuryekabulState();
}

class _FirebasekuryekabulState extends State<Firebasekuryekabul> {
  String? _timeString;
  final TextEditingController _restaurantController = TextEditingController();

  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _tutarController = TextEditingController();
  final TextEditingController _posnakitController = TextEditingController();

  final CollectionReference _siparis =
      FirebaseFirestore.instance.collection('siparisler');
  final CollectionReference _sipariskayit =
      FirebaseFirestore.instance.collection('siparişkayitli');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _restaurantController.text = documentSnapshot['restaurant'];
      _adresController.text = documentSnapshot['adres'];
      _telefonController.text = documentSnapshot['telefon'].toString();
      _tutarController.text = documentSnapshot['tutar'].toString();
      _posnakitController.text = documentSnapshot['ödemeşekli'];
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
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _restaurantController,
                  decoration:
                      const InputDecoration(labelText: 'Restaurant adı'),
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  controller: _adresController,
                  decoration: const InputDecoration(labelText: 'Adres'),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: _telefonController,
                  decoration: const InputDecoration(labelText: 'Telefon no'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _tutarController,
                  decoration: const InputDecoration(labelText: 'tutar'),
                ),
                TextField(
                  controller: _posnakitController,
                  decoration: const InputDecoration(labelText: 'Pos/nakit'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? restaurantname = _restaurantController.text;
                    final String? adres = _adresController.text;
                    final String? telefon = _telefonController.text;
                    final String? posnakit = _posnakitController.text;
                    final String? tutar = _tutarController.text;
                    // final double? tutar =
                    //    double.tryParse(_tutarController.text);
                    if (restaurantname != null &&
                        adres != null &&
                        telefon != null &&
                        tutar != null) {
                      if (action == 'create') {
                        await _siparis.add({
                          "restaurant": restaurantname,
                          "adres": adres,
                          "telefon": telefon,
                          "tutar": tutar,
                          "ödemeşekli": posnakit,
                          "tarih": _timeString
                        });
                        await _sipariskayit.add({
                          "restaurant": restaurantname,
                          "adres": adres,
                          "telefon": telefon,
                          "tutar": tutar,
                          "ödemeşekli": posnakit,
                          "tarih": _timeString
                        });
                      }

                      if (action == 'update') {
                        await _siparis.doc(documentSnapshot!.id).update({
                          "restaurant": restaurantname,
                          "adres": adres,
                          "telefon": telefon,
                          "tutar": tutar,
                          "ödemeşekli": posnakit,
                          "tarih": _timeString
                        });
                      }

                      _restaurantController.text = '';
                      _adresController.text = '';

                      _telefonController.text = '';
                      _tutarController.text = '';
                      _posnakitController.text = '';

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
    await //_siparis.doc(productId).delete();
        _siparis.doc(productId).update({"siparişdurumu": 'alındı'});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Siparişi aldınız.')));
  }

  Future<void> _finishedProduct(String productId) async {
    await //_siparis.doc(productId).delete();
        _siparis.doc(productId).update({"siparişdurumu": 'teslimedildi'});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Siparişi aldınız.')));
  }

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 221, 180),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 172, 65),
        title: const Text('Sipariş ekle'),
      ),
      body: StreamBuilder(
        stream: _siparis.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shadowColor: Colors.transparent,
                  child: ListTile(
                    title: Text(documentSnapshot['restaurant']),
                    subtitle: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('adres: '),
                            Text(
                              documentSnapshot['adres'].toString(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Telefon: '),
                            Text(documentSnapshot['telefon'].toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tutar: '),
                            Text(documentSnapshot['tutar'].toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ödeme: '),
                            Text(documentSnapshot['ödemeşekli'].toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(documentSnapshot['tarih'].toString()),
                            Text(documentSnapshot['siparişdurumu'].toString()),
                          ],
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                _finishedProduct(documentSnapshot.id);
                              }),
                          IconButton(
                              icon: const Icon(Icons.motorcycle),
                              onPressed: () {
                                _deleteProduct(documentSnapshot.id);
                              }),
                        ],
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

      /*floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 243, 172, 65),
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),*/
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM hh:mm').format(dateTime);
  }
}
