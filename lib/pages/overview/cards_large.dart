// import 'package:admin_panel/constants/constants.dart';
// import 'package:admin_panel/pages/clients/widgets/clients_table.dart';
// import 'package:admin_panel/pages/overview/info_card.dart';
// import 'package:admin_panel/pages/products/products.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OverviewCardsLargeScreen extends StatefulWidget {
//   const OverviewCardsLargeScreen({
//     super.key,
//   });

//   @override
//   State<OverviewCardsLargeScreen> createState() =>
//       _OverviewCardsLargeScreenState();
// }

// class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
//   final UserPatientController customersController = Get.find();
//   final DoctorController productsController = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     productsController.fetchDoctors();
//     customersController.fetchUserPatients();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         InfoCard(
//           title: Constants.productsCount,
//           value: productsController.doctors.length,
//           topColor: Colors.redAccent,
//           onTap: () {},
//         ),
//         InfoCard(
//           title: Constants.customerCount,
//           value: customersController.users.length,
//           onTap: () {},
//         ),
//       ],
//     );
//   }
// }
