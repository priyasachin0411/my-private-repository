import 'package:flutter/material.dart';
import 'package:kstask/user/myproject.dart';
import 'mybio.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? adminaction;
    @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body:Center(
            child:
            Container(
              padding: EdgeInsets.fromLTRB(50, 250, 0, 0),
              child:
              Column(
                children: [
                  RadioListTile(
                    title: Text("My Bio"),
                    value: "mybio",
                    groupValue: adminaction,
                    onChanged: (value){
                      setState(() {
                        adminaction = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("My Project"),
                    value: "myproject",
                    groupValue: adminaction,
                    onChanged: (value){
                      setState(() {
                        adminaction = value.toString();
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if(adminaction == "mybio"){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MyBio();
                            },
                          ),
                        );
                      }
                      else{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MyProject();
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}