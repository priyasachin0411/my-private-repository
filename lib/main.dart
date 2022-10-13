import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kstask/admin/adminscreen.dart';
import 'package:kstask/user/userscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'validator.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() => print('complete sync................'));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isProcessing = false;
  bool credentials = false;

  Future<void> getData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    final prefs = await SharedPreferences.getInstance();
    collection.snapshots().listen((querySnapshot)  {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        if(data['username'] == _usernameTextController.text && data['password'] == _passwordTextController.text){
          credentials = true;
          prefs.setString('username',_usernameTextController.text );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return UserScreen();
              },
            ),
          );
        }
      }
    });
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
                    key: _loginKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _usernameTextController,
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
                          controller: _passwordTextController,
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
                        SizedBox(height: 32.0),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(_usernameTextController.text.isNotEmpty && _passwordTextController.text.isNotEmpty){
                                    if(_usernameTextController.toString() == "Admin@kssmart.co" && _passwordTextController.text == "123456"){
                                      credentials =  true;
                                      _isProcessing = false;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AdminScreen();
                                          },
                                        ),
                                      );
                                    }
                                    else{
                                      _isProcessing = false;
                                      getData();
                                    }
                                    if(!credentials){
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Incorrect User Name or Password'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                  else{
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          'Please fill User Name and Password'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Text(
                                  'Login',
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
            )
          ),
        ),
      );
  }
}