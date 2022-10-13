import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../validator.dart';

class MyProject extends StatefulWidget {
  const MyProject({Key? key}) : super(key: key);

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  final _myProjectKey = GlobalKey<FormState>();
  final _projectnameTextController = TextEditingController();
  final _companyTextController = TextEditingController();
  final _websiteTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  double latitude = 12.0, latitude1 = 12.0, longitude = 15.0, longitude1 = 15.0;

  late final username;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    username = await prefs.getString('username');
    var collection = FirebaseFirestore.instance.collection('myprojects');
    collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        if (data['assign_user'] == username) {
          setState(() {
            _projectnameTextController.text = data['project_name'];
            _companyTextController.text = data['company_name'];
            _websiteTextController.text = data['website'];
            _locationTextController.text = data['lat_lng'];
            var latlong = _locationTextController.text.split(',');
            latitude = latitude1 = double.parse(latlong[0].trim().toString());
            longitude = longitude1 = double.parse(latlong[1].trim().toString());
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
    return GestureDetector(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _myProjectKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _projectnameTextController,
                        enabled: false,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
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
                        controller: _companyTextController,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
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
                        controller: _websiteTextController,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
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
                      Container(
                        child: FlutterMap(
                          options: MapOptions(
                              center: LatLng(latitude, longitude), zoom: 12),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  point: LatLng(latitude1, longitude1),
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
