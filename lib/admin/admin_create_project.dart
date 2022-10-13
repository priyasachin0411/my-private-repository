import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../constants/apiconnection_get.dart';
import '../model/userdata.dart';
import '../validator.dart';

class AdminCreateProject extends StatefulWidget {
  const AdminCreateProject({Key? key}) : super(key: key);

  @override
  State<AdminCreateProject> createState() => _AdminCreateProjectState();
}

class _AdminCreateProjectState extends State<AdminCreateProject> {
  final _projectKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  final _nameTextController = TextEditingController();
  final _websiteTextController = TextEditingController();
  final _locationTextController = TextEditingController();

  final connection = ApiConnection();
  double latitude = 15.00, longitude = 12.00;

  String? dropdownvalue_company;

  String? dropdownvalue_user;

  List<String> assign_user = [];

  List<String> company = [];
  List<UserModel>? _userModel = [];

  bool _isProcessing = false;

  final _fireStore = FirebaseFirestore.instance;
  final CollectionReference myprojects =
      FirebaseFirestore.instance.collection('myprojects');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();
    final allDatas =
        querySnapshot.docs.map((doc) => doc.get('username')).toList();
    for (int i = 0; i <= allDatas.length; i++) {
      assign_user.add(allDatas[i]);
    }
  }

  void initState() {
    getListUsers();
    getData();
    super.initState();
  }

  getListUsers() async {
    _userModel = (await ApiConnection().getUsers())!;
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
    for (int i = 0; i < _userModel!.length; i++) {
      print(_userModel![i].id.toString());
      print(_userModel![i].company.name);
      company.add(_userModel![i].company.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create Project",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                SizedBox(height: 40.0),
                Form(
                  key: _projectKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        decoration: InputDecoration(
                          hintText: "Project Name",
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
                          readOnly: true,
                          obscureText: false,
                          controller: dateCtl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Project Date: dd/mm/yyyy',
                            hintText: 'Project Date: dd/mm/yyyy',
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
                      SizedBox(height: 25.0),
                      DropdownButtonFormField(
                        hint: Text("Company Name"),
                        value: dropdownvalue_company,
                        isExpanded: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            border: OutlineInputBorder(),
                            hintText: "Company Name"),
                        items: company.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue_company = newValue!;
                            for (int i = 0; i < _userModel!.length; i++) {
                              if (dropdownvalue_company ==
                                  _userModel![i].company.name) {
                                _websiteTextController.text =
                                    _userModel![i].website;
                                _locationTextController.text =
                                    _userModel![i].address.geo.lat +
                                        " , " +
                                        _userModel![i].address.geo.lng;
                                latitude = double.parse(
                                    _userModel![i].address.geo.lat);
                                longitude = double.parse(
                                    _userModel![i].address.geo.lng);
                              }
                            }
                          });
                        },
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        enabled: false,
                        controller: _websiteTextController,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Website",
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
                        controller: _locationTextController,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Location",
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
                      DropdownButtonFormField(
                        hint: Text("Assign user"),
                        value: dropdownvalue_user,
                        isExpanded: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            border: OutlineInputBorder(),
                            hintText: "Assign user"),
                        items: assign_user.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue_user = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 32.0),
                      Container(
                        child: FlutterMap(
                          options: MapOptions(
                              center: LatLng(latitude, longitude), zoom: 14),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  point: LatLng(latitude, longitude),
                                  width: 80,
                                  height: 50,
                                  builder: (context) =>
                                      Icon(Icons.pin_drop, size: 40),
                                ),
                              ],
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(20),
                        height: 300,
                        width: 500,
                      ),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final String projectname =
                                          _nameTextController.text;
                                      final String projectdate = dateCtl.text;
                                      final String? companyname =
                                          dropdownvalue_company;
                                      final String website =
                                          _websiteTextController.text;
                                      final String? assign_user =
                                          dropdownvalue_user;
                                      final String location =
                                          _locationTextController.text;
                                      if (projectname.isNotEmpty &&
                                          projectdate.isNotEmpty &&
                                          companyname != null &&
                                          website.isNotEmpty &&
                                          location.isNotEmpty &&
                                          assign_user != null ) {
                                        await myprojects.add({
                                          "project_name": projectname,
                                          "project_date": projectdate,
                                          "company_name": companyname,
                                          "website": website,
                                          "lat_lng": location,
                                          "assign_user": assign_user
                                        });
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              'Project created Sucessfully'),
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
          )),
        ),
      ),
    );
  }
}
