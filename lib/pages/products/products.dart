// ignore_for_file: use_build_context_synchronously
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:admin_panel/helpers/custom_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductsTableState createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsPage> {
  final doctorController = Get.put(DoctorController());

  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  //File? image;
  @override
  void initState() {
    super.initState();
    doctorController.fetchDoctors();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var columns = const [
      // DataColumn(label: Text('Id')),
      DataColumn(label: Text('Id')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Mobile')),
      DataColumn(label: Text('Gender')),
      DataColumn(label: Text('Age')),
      DataColumn(label: Text('DOB')),
      //DataColumn(label: Text('Is-Active')),
      DataColumn(label: Text('Category')),
      DataColumn(label: Text('Affilation')),
      DataColumn(label: Text('Qualification')),
      DataColumn(label: Text('Experience')),
      DataColumn(label: Text('Onsite Fee')),
      DataColumn(label: Text('Online Fee')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Doctors'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child:
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              AdaptiveScrollbar(
            underColor: Colors.blueGrey.withOpacity(0.3),
            sliderDefaultColor:
                Colors.lightBlueAccent.withOpacity(0.7), // Change to light blue
            sliderActiveColor: Colors.lightBlueAccent, // Change to light blue
            controller: verticalScrollController,
            child: AdaptiveScrollbar(
              controller: horizontalScrollController,
              position: ScrollbarPosition.bottom,
              underColor: lightGray.withOpacity(0.3),
              sliderDefaultColor: Colors.lightBlueAccent
                  .withOpacity(0.7), // Change to light blue
              sliderActiveColor: Colors.lightBlueAccent, // Change to light blue
              width: 13.0,
              sliderHeight: 100.0,
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: doctorController.doctors.length == 0
                        ? const Center(child: CircularProgressIndicator())
                        : DataTable(
                            columns: columns,
                            rows: List<DataRow>.generate(
                              doctorController.doctors.length,
                              (index) {
                                final doctor = doctorController.doctors[index];
                                return DataRow(
                                  cells: [
                                    // DataCell(CustomText(
                                    //   text: product.id.toString(),
                                    // )),
                                    DataCell(CustomText(
                                      text: doctor.id.toString(),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.fullName,
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.mobile,
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.gender,
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.age.toString(),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.dob.toString(),
                                    )),
                                    // DataCell(CustomText(
                                    //   text: doctor.isActive.toString(),
                                    // )),
                                    DataCell(CustomText(
                                      text: doctor.categories!
                                          .map((category) => category.name!)
                                          .join(', '),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.doctorUser!.affilation!
                                          .join(", "),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.doctorUser!.qualification!
                                          .join(', '),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor.doctorUser!.yearsOfExperience
                                          .toString(),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor
                                          .doctorUser!.onsiteConsultationFee
                                          .toString()
                                          .toString(),
                                    )),
                                    DataCell(CustomText(
                                      text: doctor
                                          .doctorUser!.onlineConsultationFee
                                          .toString()
                                          .toString(),
                                    )),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          //   ],
          // ),
        ),
      );
    });
  }
}

class Doctors {
  bool? status;
  String? message;
  Null? error;
  List<Data>? data;

  Doctors({this.status, this.message, this.error, this.data});

  Doctors.fromJson(Map<String, dynamic> json) {
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
  DoctorUser? doctorUser;
  List<Categories>? categories;
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
      this.doctorUser,
      this.categories,
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
    doctorUser = json['doctor_user'] != null
        ? new DoctorUser.fromJson(json['doctor_user'])
        : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
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
    if (this.doctorUser != null) {
      data['doctor_user'] = this.doctorUser!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? name;

  Categories({this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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

class DoctorUser {
  int? id;
  int? userId;
  String? licenseNumber;
  Null? availability;
  List<String>? affilation;
  List<String>? qualification;
  int? yearsOfExperience;
  int? onsiteConsultationFee;
  int? onlineConsultationFee;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  DoctorUser(
      {this.id,
      this.userId,
      this.licenseNumber,
      this.availability,
      this.affilation,
      this.qualification,
      this.yearsOfExperience,
      this.onsiteConsultationFee,
      this.onlineConsultationFee,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  DoctorUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    licenseNumber = json['license_number'];
    availability = json['availability'];
    affilation = json['affilation'].cast<String>();
    qualification = json['qualification'].cast<String>();
    yearsOfExperience = json['years_of_experience'];
    onsiteConsultationFee = json['onsite_consultation_fee'];
    onlineConsultationFee = json['online_consultation_fee'];
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
    data['license_number'] = this.licenseNumber;
    data['availability'] = this.availability;
    data['affilation'] = this.affilation;
    data['qualification'] = this.qualification;
    data['years_of_experience'] = this.yearsOfExperience;
    data['onsite_consultation_fee'] = this.onsiteConsultationFee;
    data['online_consultation_fee'] = this.onlineConsultationFee;
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

class DoctorController extends GetxController {
  var doctors = <Data>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    //isLoading.value = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = await prefs.getString('access_token');

    try {
      String url = '$baseUrl/admin/users/all-doctors';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        doctors.clear();
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status']) {
          var data = jsonResponse['data'] as List;
          doctors.assignAll(data.map((e) => Data.fromJson(e)));
        }
        prefs.setInt('doctorsNo', doctors.length);
      } else {
        Get.snackbar('Error', 'Invalid Data');
      }
    } catch (error) {
      // Handle errors here
      print('Error fetching doctors: $error');
      Get.snackbar('Error', 'Failed to fetch doctors. Please try again later.');
    } finally {
      //  isLoading.value = true;
    }
  }
}

List<String> extractNames(String jsonString) {
  List<String> names = [];

  // Split the input string by space to get individual JSON strings
  List<String> jsonStrings = jsonString.split(' ');

  // Parse each JSON string and extract the name value
  for (String jsonStr in jsonStrings) {
    Map<String, dynamic> jsonObject = jsonDecode(jsonStr.trim());
    String? name = jsonObject['name'];
    if (name != null) {
      names.add(name);
    }
  }

  return names;
}
