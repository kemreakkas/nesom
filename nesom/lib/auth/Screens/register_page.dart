// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nesom/HomePage.dart';
import 'package:nesom/auth/utils/fire_auth.dart';
import 'package:nesom/auth/utils/validator.dart';
import 'package:nesom/constant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //////////////////////////////firebase ekle

  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('kullanici');

  DocumentSnapshot? documentSnapshot;

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameTextController.text = documentSnapshot['kullaniciadi'];
      _emailTextController.text = documentSnapshot['kullanicimail'];
      role = documentSnapshot['role'];
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
                  controller: _nameTextController,
                  decoration: const InputDecoration(labelText: 'Kullancı adı'),
                ),
                TextField(
                  controller: _nameTextController,
                  decoration: const InputDecoration(
                    labelText: 'kullanicimail',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? kullaniciadi = _nameTextController.text;
                    final String? kullanicimail = _emailTextController.text;
                    if (kullaniciadi != null && kullanicimail != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _productss.add({
                          "kullaniciadi": kullaniciadi,
                          "kullanicimail": kullanicimail,
                          "profilresmi": urlphoto,
                          "role": "a"
                        });
                      }
                      if (action == 'update') {
                        // Update the product
                        await _productss.doc(documentSnapshot!.id).update({
                          "name": kullaniciadi,
                          "kullanicimail": kullanicimail,
                          //"role": "kullanıcı"
                        });
                      }
                      // Clear the text fields
                      _nameTextController.text = '';
                      _emailTextController.text = '';
                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  //////////////////////////////////////////////////////////
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 172, 65),
          title: const Text("Nesom'a Kayıt ol"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset('assets/CoffeenHood1.png'),
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Adınız",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email Adresiniz",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "En az 6 haneli şifreniz",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        _isProcessing
                            ? const CircularProgressIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        /////////////////////////////////
                                        final String? kullaniciadi =
                                            _nameTextController.text;
                                        final String? kullanicimail =
                                            _emailTextController.text;
                                        if (kullaniciadi != null &&
                                            kullanicimail != null) {
                                          // Persist a new product to Firestore
                                          await _productss.add({
                                            "kullaniciadi": kullaniciadi,
                                            "kullanicimail": kullanicimail,
                                            "role": "a"
                                          });
                                        }
                                        setState(() {
                                          _isProcessing = true;
                                        });
                                        if (_registerFormKey.currentState!
                                            .validate()) {
                                          User? user = await FireAuth
                                              .registerUsingEmailPassword(
                                            name: _nameTextController.text,
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text,
                                          );
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                          if (user != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage()),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 243, 172, 65),
                                          textStyle: const TextStyle(
                                              //fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      child: const Text(
                                        'Kayıt Ol',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
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
