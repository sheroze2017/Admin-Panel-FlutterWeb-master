// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_panel/helpers/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersPage> {
  final ReportController reportsController = Get.put(ReportController());

  @override
  void initState() {
    super.initState();
    reportsController.fetchPatientsReport();
  }

  DataRow _buildOrderRow(Data order) {
    return DataRow(
      cells: [
        DataCell(buildCell(order.id.toString())),
        DataCell(buildCell(order.isActive.toString())),
        DataCell(buildCell(order.amount.toString())),
        DataCell(buildCell(order.paymentLogPatient!.fullName.toString())),
        DataCell(buildCell(order.bookingLogId.toString())),
        DataCell(buildCell(order.createdAt.toString()))
      ],
    );
  }

  Widget buildCell(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.transparent),
      ),
      child: CustomText(text: text),
    );
  }

  Widget _buildActionButton(
      String label, void Function() onPressed, bool isDelivered) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isDelivered ? Colors.lightBlueAccent : light,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: CustomText(
          text: label,
          color: active.withOpacity(0.7),
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Order ID')),
      DataColumn(label: Text('isActive')),
      DataColumn(label: Text('Total')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('BookingLogID')),
      DataColumn(label: Text('Created At')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payments'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 6),
                  color: Colors.lightBlueAccent.withOpacity(.1),
                  blurRadius: 12),
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
                    child: reportsController.userPatients.length == 0
                        ? const CircularProgressIndicator()
                        : DataTable(
                            columns: columns,
                            rows: reportsController.userPatients
                                .map((order) => _buildOrderRow(order))
                                .toList(),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class reports {
  bool? status;
  String? message;
  Null? error;
  List<Data>? data;

  reports({this.status, this.message, this.error, this.data});

  reports.fromJson(Map<String, dynamic> json) {
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
  bool? isActive;
  int? amount;
  int? bookingLogId;
  String? createdAt;
  String? updatedAt;
  PaymentLogPatient? paymentLogPatient;

  Data(
      {this.id,
      this.isActive,
      this.amount,
      this.bookingLogId,
      this.createdAt,
      this.updatedAt,
      this.paymentLogPatient});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    amount = json['amount'];
    bookingLogId = json['booking_log_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentLogPatient = json['payment_log_patient'] != null
        ? new PaymentLogPatient.fromJson(json['payment_log_patient'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_active'] = this.isActive;
    data['amount'] = this.amount;
    data['booking_log_id'] = this.bookingLogId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.paymentLogPatient != null) {
      data['payment_log_patient'] = this.paymentLogPatient!.toJson();
    }
    return data;
  }
}

class PaymentLogPatient {
  int? id;
  String? fullName;

  PaymentLogPatient({this.id, this.fullName});

  PaymentLogPatient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    return data;
  }
}

class ReportController extends GetxController {
  var userPatients = <Data>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPatientsReport();
    super.onInit();
  }

  void fetchPatientsReport() async {
    print('nice');

    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = await prefs.getString('access_token');

      String url =
          '$baseUrl/admin/reports?type=Payment&from=2023-08-01&to=2024-08-31'; // Replace with your API endpoint
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
        prefs.setInt('paymentsMade', userPatients.length);
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
