import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              adminProvider.fetchPlayers();
            },
          ),
        ],
      ),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Name",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black
            ),)),
            DataColumn(label: Text("Place",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
            DataColumn(label: Text("Phone",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
            DataColumn(label: Text("Day 1 Score",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
            DataColumn(label: Text("Day 2 Score",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
            DataColumn(label: Text("Day 3 Score",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
            DataColumn(label: Text("Day 4 Score",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
            DataColumn(label: Text("Total Score",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ))),
          ],
          rows: adminProvider.players.map((player) {
            return DataRow(cells: [
              DataCell(Text(player['name'])),
              DataCell(Text(player['place'])),
              DataCell(Text(player['phone'])),
              DataCell(Text(player['day1Score'].toString())),
              DataCell(Text(player['day2Score'].toString())),
              DataCell(Text(player['day3Score'].toString())),
              DataCell(Text(player['day4Score'].toString())),
              DataCell(Text(player['totalScore'].toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}