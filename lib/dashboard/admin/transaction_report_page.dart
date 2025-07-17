import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionReportPage extends StatelessWidget {
  const TransactionReportPage({super.key});

  Future<Map<String, int>> getReport() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final monthStart = DateTime(now.year, now.month, 1);

    // Ambil semua pesanan dari semua vendor
    final allOrders = await FirebaseFirestore.instance
        .collectionGroup('orders')
        .get();

    int totalToday = 0;
    int totalMonth = 0;

    for (var doc in allOrders.docs) {
      final data = doc.data();
      final timestamp = data['created_at'];

      if (timestamp != null && timestamp is Timestamp) {
        final date = timestamp.toDate();
        if (date.isAfter(todayStart)) {
          totalToday++;
        }
        if (date.isAfter(monthStart)) {
          totalMonth++;
        }
      }
    }

    return {
      'totalToday': totalToday,
      'totalMonth': totalMonth,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Transaksi')),
      body: FutureBuilder<Map<String, int>>(
        future: getReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ringkasan Transaksi", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: [
                    _buildCard(Icons.today, 'Pesanan Hari Ini', data['totalToday'].toString()),
                    _buildCard(Icons.calendar_month, 'Pesanan Bulan Ini', data['totalMonth'].toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
