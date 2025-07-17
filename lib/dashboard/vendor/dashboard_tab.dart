import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  Future<Map<String, dynamic>> getSummary() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final vendorDoc = await FirebaseFirestore.instance.collection('vendors').doc(uid).get();
    final products = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(uid)
        .collection('products')
        .get();
    final pendingOrders = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(uid)
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .get();
    final unavailableDates = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(uid)
        .collection('calendar')
        .get();

    return {
      'nama': vendorDoc.data()?['nama'] ?? '-',
      'totalProduk': products.size,
      'totalPesananPending': pendingOrders.size,
      'totalTanggalLibur': unavailableDates.size,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF5EE), // seashell background
      child: FutureBuilder<Map<String, dynamic>>(
        future: getSummary(),
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
                    _buildCard(Icons.inventory, 'Produk Saya', data['totalProduk'].toString()),
                    _buildCard(Icons.shopping_cart, 'Pesanan Pending', data['totalPesananPending'].toString()),
                    _buildCard(Icons.calendar_today, 'Tanggal Libur', data['totalTanggalLibur'].toString()),
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
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4, // shadow sedikit lebih tebal biar elegan
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.pink.shade200), // aksen pink lembut
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
