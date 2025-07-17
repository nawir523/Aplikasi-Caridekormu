import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor_list_page.dart';
import 'order_list_page.dart';
import 'transaction_report_page.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<Map<String, dynamic>> getSummary() async {
    final vendorCount = await FirebaseFirestore.instance.collection('vendors').get();
    final productCount = await FirebaseFirestore.instance.collectionGroup('products').get();
    final ordersCount = await FirebaseFirestore.instance.collectionGroup('orders').get();

    return {
      'totalVendors': vendorCount.size,
      'totalProducts': productCount.size,
      'totalOrders': ordersCount.size,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EE), // seashell background
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        title: const Text('Dashboard Admin'),
          actions: [
            TextButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout, color: Color.fromARGB(255, 12, 12, 12), size: 18),
              label: const Text(
                'Log out',
                style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
              ),
            ),
          ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Ganti GridView jadi Row + Expanded
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                          Icons.store, 'Vendor', data['totalVendors'].toString()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCard(
                          Icons.inventory, 'Produk', data['totalProducts'].toString()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCard(
                          Icons.shopping_cart, 'Pesanan', data['totalOrders'].toString()),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildMenuCard(
                  context,
                  icon: Icons.verified_user,
                  title: "List & Verifikasi Vendor",
                  subtitle: "Lihat semua vendor dan kelola status",
                  page: const VendorListPage(),
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.shopping_cart,
                  title: "List Semua Pesanan",
                  subtitle: "Pantau & kelola pesanan",
                  page: const OrderListPage(),
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.bar_chart,
                  title: "Laporan Transaksi",
                  subtitle: "Pantau aktivitas penyewaan",
                  page: const TransactionReportPage(),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: Colors.pinkAccent.shade200),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon, required String title, required String subtitle, required Widget page}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.pinkAccent.shade200),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
