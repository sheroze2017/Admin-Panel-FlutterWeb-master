import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_panel/helpers/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class ClientsTable extends StatefulWidget {
  const ClientsTable({super.key});

  @override
  State<ClientsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ClientsTable> {
  final patientController = Get.put(UserPatientController());

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Id')),
      DataColumn(label: Text('Full Name')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('Gender')),
      DataColumn(label: Text('Age')),
      DataColumn(label: Text('City')),
      DataColumn(label: Text('DOB')),
      DataColumn(label: Text('Blood Type')),
      DataColumn(label: Text('Weight')),
      DataColumn(label: Text('Height')),
      DataColumn(label: Text('Allergies')),
      DataColumn(label: Text('Disease')),
      DataColumn(label: Text('Visit Doctor')),
      DataColumn(label: Text('Created Date')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: active.withOpacity(.4), width: .5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 6),
                color: Colors.lightBlueAccent.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 30),
        child: AdaptiveScrollbar(
          underColor: Colors.blueGrey.withOpacity(0.3),
          sliderDefaultColor:
              Colors.lightBlueAccent.withOpacity(0.7), // Change to light blue
          sliderActiveColor: Colors.lightBlueAccent, // Change to light blue
          controller: verticalScrollController,
          child: AdaptiveScrollbar(
            controller: horizontalScrollController,
            position: ScrollbarPosition.bottom,
            underColor: lightGray.withOpacity(0.3),
            sliderDefaultColor:
                Colors.lightBlueAccent.withOpacity(0.7), // Change to light blue
            sliderActiveColor: Colors.lightBlueAccent, // Change to light blue
            width: 13.0,
            sliderHeight: 100.0,
            child: SingleChildScrollView(
              controller: verticalScrollController,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: patientController.userPatients.length == 0
                        ? const CircularProgressIndicator()
                        : DataTable(
                            columns: columns,
                            rows: List<DataRow>.generate(
                              patientController.userPatients.length,
                              (index) => DataRow(cells: [
                                DataCell(CustomText(
                                  text: patientController.userPatients[index].id
                                      .toString(),
                                )),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].fullName
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].mobile
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].gender
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].age)),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].cities![0].name
                                        .toString()
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].dob
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController.userPatients[index]
                                        .userPatient!.bloodType
                                        .toString()
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].userPatient!.weight
                                        .toString()
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController
                                        .userPatients[index].userPatient!.height
                                        .toString()
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController.userPatients[index]
                                        .userPatient!.allergies!
                                        .join(" ")
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController.userPatients[index]
                                        .userPatient!.disease!
                                        .join(' '))),
                                DataCell(CustomText(
                                    text: patientController.userPatients[index]
                                        .userPatient!.sinceVisit
                                        .toString())),
                                DataCell(CustomText(
                                    text: patientController.userPatients[index]
                                        .userPatient!.createdAt
                                        .toString())),
                                // DataCell(
                                //   IconButton(
                                //     icon: const Icon(
                                //       Icons.delete,
                                //       color: Colors.red,
                                //     ),
                                //     onPressed: () {
                                //       _deleteCustomer(
                                //           patientController.userPatients[index]);
                                //     },
                                //   ),
                                // ),
                              ]),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class patient {
  bool? status;
  String? message;
  Null? error;
  List<Data>? data;

  patient({this.status, this.message, this.error, this.data});

  patient.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? fullName;
  Null? email;
  String? mobile;
  String? gender;
  String? age;
  String? dob;
  bool? isActive;
  bool? isDeactivated;
  List<UserRoles>? userRoles;
  UserPatient? userPatient;
  List<Cities>? cities;

  Data(
      {this.id,
      this.fullName,
      this.email,
      this.mobile,
      this.gender,
      this.age,
      this.dob,
      this.isActive,
      this.isDeactivated,
      this.userRoles,
      this.userPatient,
      this.cities});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
    gender = json['gender'];
    age = json['age'];
    dob = json['dob'];
    isActive = json['is_active'];
    isDeactivated = json['is_deactivated'];
    if (json['user_roles'] != null) {
      userRoles = <UserRoles>[];
      json['user_roles'].forEach((v) {
        userRoles!.add(new UserRoles.fromJson(v));
      });
    }
    userPatient = json['user_patient'] != null
        ? new UserPatient.fromJson(json['user_patient'])
        : null;
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['dob'] = this.dob;
    data['is_active'] = this.isActive;
    data['is_deactivated'] = this.isDeactivated;
    if (this.userRoles != null) {
      data['user_roles'] = this.userRoles!.map((v) => v.toJson()).toList();
    }
    if (this.userPatient != null) {
      data['user_patient'] = this.userPatient!.toJson();
    }
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserRoles {
  String? name;

  UserRoles({this.name});

  UserRoles.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class UserPatient {
  int? id;
  int? userId;
  String? bloodType;
  String? weight;
  String? height;
  List<String>? allergies;
  List<String>? disease;
  String? sinceVisit;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  UserPatient(
      {this.id,
      this.userId,
      this.bloodType,
      this.weight,
      this.height,
      this.allergies,
      this.disease,
      this.sinceVisit,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  UserPatient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bloodType = json['blood_type'];
    weight = json['weight'];
    height = json['height'];
    allergies = json['allergies'].cast<String>();
    disease = json['disease'].cast<String>();
    sinceVisit = json['since_visit'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['blood_type'] = this.bloodType;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['allergies'] = this.allergies;
    data['disease'] = this.disease;
    data['since_visit'] = this.sinceVisit;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Cities {
  int? id;
  String? name;

  Cities({this.id, this.name});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class UserPatientController extends GetxController {
  var userPatients = <Data>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchUserPatients();
    super.onInit();
  }

  void fetchUserPatients() async {
    print('nice');

    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = await prefs.getString('access_token');

      String url =
          '$baseUrl/admin/users/all-patients'; // Replace with your API endpoint
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 200) {
        userPatients.clear();
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status']) {
          var data = jsonResponse['data'] as List;
          print(data);
          userPatients.assignAll(data.map((e) => Data.fromJson(e)));
        }
        prefs.setInt('patientsNo', userPatients.length);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user patients: $error');
    } finally {
      isLoading(false);
    }
  }
}
