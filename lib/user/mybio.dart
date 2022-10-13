import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../validator.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);
  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {

  final _mybioKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _dateofbirthController = TextEditingController();
  late final username;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    username = await prefs.getString('username');
    var collection = FirebaseFirestore.instance.collection('users');
    collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        if(data['username'] == username){
          setState(() {
            _nameTextController.text = data['username'];
            _passwordTextController.text = data['password'];
            _dateofbirthController.text = data['dob'];
          });
        }
      }
    });
  }

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _mybioKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameTextController,
                            enabled: false,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "User Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            enabled: false,
                            controller: _passwordTextController,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            enabled: false,
                            controller: _dateofbirthController,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Date of Birth",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
        ),
      );
  }
}
