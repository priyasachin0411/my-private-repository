import 'package:flutter/material.dart';
import 'package:kstask/admin/admin_create_project.dart';
import 'admin_create_user.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
                    title: Text("Create User"),
                    value: "user",
                    groupValue: adminaction,
                    onChanged: (value){
                      setState(() {
                        adminaction = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Create Project"),
                    value: "project",
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
                      if(adminaction == "user"){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AdminCreateUser();
                            },
                          ),
                        );
                      }
                      else{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AdminCreateProject();
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