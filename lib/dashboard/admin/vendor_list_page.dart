import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorListPage extends StatelessWidget {
  const VendorListPage({super.key});

  Future<void> updateVendorStatus(BuildContext context, String vendorId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .update({'status': newStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status vendor diupdate menjadi: $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Vendor')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada vendor'));
          }

          final vendors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final doc = vendors[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(data['nama'] ?? '-'),
                  subtitle: Text('Status: ${data['status'] ?? 'unknown'}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'aktif') {
                        updateVendorStatus(context, doc.id, 'aktif');
                      } else if (value == 'blokir') {
                        updateVendorStatus(context, doc.id, 'blokir');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'aktif',
                        child: Text('Verifikasi (Aktifkan)'),
                      ),
                      const PopupMenuItem(
                        value: 'blokir',
                        child: Text('Blokir'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
