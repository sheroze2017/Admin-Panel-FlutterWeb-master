// ignore_for_file: non_constant_identifier_names
import 'package:admin_panel/pages/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin_panel/pages/products/products.dart';
import 'package:admin_panel/pages/clients/widgets/clients_table.dart';

class OverviewPage extends StatelessWidget {
  final DoctorController doctorsController = DoctorController();
  final UserPatientController patientController = UserPatientController();
  final ReportController reportController = ReportController();

  OverviewPage({Key? key}) : super(key: key) {
    // Fetch products, customers, cars registered, book tickets, and appointments when the OverviewPage is created
    // doctorsController.fetchDoctors();
    //patientController.fetchUserPatients();
    //reportController.fetchPatientsReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          // Widgets at the very top of the screen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTopWidget(
                  "Total Doctors", doctorsController.doctors.length),
              _buildTopWidget(
                  "Total Patients", patientController.userPatients.length),
              _buildTopWidget(
                  "Total Payments", reportController.userPatients.length),
            ],
          ),

          // Expanded(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             const Padding(
          //               padding: EdgeInsets.all(16.0),
          //               child: Text(
          //                 'Top Rated Products and Packages',
          //                 style: TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //             Expanded(
          //               child: Obx(() {
          //                 final List<Products> sortedProducts =
          //                     productsController.products.toList()
          //                       ..sort((a, b) => b.rating.compareTo(a.rating));

          //                 final List<Products> limitedProducts =
          //                     sortedProducts.take(6).toList();

          //                 return ListView.builder(
          //                   itemCount: limitedProducts.length,
          //                   itemBuilder: (context, index) {
          //                     final product = limitedProducts[index];
          //                     return Card(
          //                       color: Colors.lightBlueAccent,
          //                       elevation: 5,
          //                       margin: const EdgeInsets.symmetric(
          //                           vertical: 8, horizontal: 16),
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(16.0),
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Text(
          //                               product.title,
          //                               style: const TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: 18,
          //                                 fontWeight: FontWeight.bold,
          //                               ),
          //                             ),
          //                             const SizedBox(height: 8),
          //                             Text(
          //                               "Rating: ${product.rating} stars",
          //                               style: const TextStyle(
          //                                   color: Colors.white70,
          //                                   fontWeight: FontWeight.bold,
          //                                   fontStyle: FontStyle.italic),
          //                             ),
          //                             Text(
          //                               "Price: \Rs.${product.price}",
          //                               style: const TextStyle(
          //                                   color: Colors.white),
          //                             ),
          //                             Text(
          //                               "Category: ${product.category}",
          //                               style: const TextStyle(
          //                                   color: Colors.white),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 );
          //               }),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const VerticalDivider(
          //         color: Colors.black,
          //         thickness: 5,
          //         indent: 20,
          //       ),
          //       Expanded(
          //         child: Container(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Obx(() {
          //             // Pass the controller values to the PieChartWidget
          //             return PieChartWidget(
          //               productsCount: productsController.products.length,
          //               customersCount: customersController.users.length,
          //               registeredCarsCount:
          //                   autoshowController.autoshowList.length,
          //               bookedTicketsCount:
          //                   bookTicketController.bookTicketList.length,
          //               appointmentsCount:
          //                   appointmentsController.appointments.length,
          //             );
          //           }),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTopWidget(String label, int count) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int count;
  final Color color;

  ChartData(this.category, this.count, this.color);
}

class PieChartWidget extends StatelessWidget {
  final int productsCount;
  final int customersCount;
  final int registeredCarsCount;
  final int bookedTicketsCount;
  final int appointmentsCount;

  const PieChartWidget({
    Key? key,
    required this.productsCount,
    required this.customersCount,
    required this.registeredCarsCount,
    required this.bookedTicketsCount,
    required this.appointmentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Products', productsCount, Colors.blue),
      ChartData('Customers', customersCount, Colors.green),
      ChartData('Cars Registered', registeredCarsCount, Colors.orange),
      ChartData('Tickets', bookedTicketsCount, Colors.red),
      ChartData('Appointments', appointmentsCount, Colors.purple),
    ];

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: _createPieChartData(chartData),
                borderData: FlBorderData(show: false),
                centerSpaceColor: Colors.white,
              ),
            ),
          ),
        ),
        // Legend
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildLegend(chartData),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createPieChartData(List<ChartData> chartData) {
    return chartData.map((data) {
      return PieChartSectionData(
        color: data.color,
        value: data.count.toDouble(),
        // title: data.category,
        radius: 80,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  List<Widget> _buildLegend(List<ChartData> chartData) {
    return chartData.map((data) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 16.0,
              height: 16.0,
              color: data.color,
            ),
            const SizedBox(width: 8.0),
            Text(data.category),
          ],
        ),
      );
    }).toList();
  }
}
