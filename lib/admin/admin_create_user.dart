import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../validator.dart';

class AdminCreateUser extends StatefulWidget {
  const AdminCreateUser({Key? key}) : super(key: key);
  @override
  State<AdminCreateUser> createState() => _AdminCreateUserState();
}

class _AdminCreateUserState extends State<AdminCreateUser> {
  final _userKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  final CollectionReference userCollection =  FirebaseFirestore.instance.collection('users');
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _userKey,
                      child: Column(
                        children: <Widget>[
                          Text("Create User",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                          SizedBox(height: 40.0),
                          TextFormField(
                            controller: _usernameTextController,
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
                              readOnly: true,
                              obscureText: false,
                              controller: dateCtl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date of Birth: dd/mm/yyyy',
                                hintText: 'Date of Birth: dd/mm/yyyy',
                              ),
                              onTap: () async {
                                DateTime? date = DateTime(1900);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                dateCtl.text = date!.toString().substring(0, 10);
                                if (date != null) {
                                  setState(() => {
                                    dateCtl.text =
                                        date.toString().substring(0, 10)
                                  });
                                }
                              }),
                          SizedBox(height: 32.0),
                          _isProcessing
                              ? CircularProgressIndicator()
                              : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final String name = _usernameTextController.text;
                                    final String designation =_passwordTextController.text;
                                    final String date = dateCtl.text;
                                    if (name.isNotEmpty && designation.isNotEmpty && date.isNotEmpty) {
                                        await userCollection.add({"username": name, "password": designation, "dob":date});
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              'User created Successfully'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.of(context).pop();
                                    }
                                    else{
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Please fill all the fields'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Text(
                                    'Submit',
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