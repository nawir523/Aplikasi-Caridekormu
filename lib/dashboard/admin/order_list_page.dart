import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  Future<void> updateOrderStatus(
      BuildContext context, String vendorId, String orderId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders')
        .doc(orderId)
        .update({'status': newStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status pesanan diupdate menjadi: $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Semua Pesanan')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('orders')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada pesanan'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;

              // Dapatkan vendorId dari path: vendors/{vendorId}/orders/{orderId}
              final pathSegments = doc.reference.path.split('/');
              final vendorId = pathSegments.length > 1 ? pathSegments[1] : '-';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    data['nama_produk'] ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Penyewa: ${data['nama_penyewa'] ?? '-'}'),
                        Text('Vendor ID: $vendorId'),
                        Text('Tanggal Sewa: ${data['tanggal_sewa'] ?? '-'}'),
                        Text('Status: ${data['status'] ?? 'pending'}'),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'setujui') {
                        updateOrderStatus(context, vendorId, doc.id, 'disetujui');
                      } else if (value == 'tolak') {
                        updateOrderStatus(context, vendorId, doc.id, 'ditolak');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'setujui',
                        child: Text('Setujui'),
                      ),
                      const PopupMenuItem(
                        value: 'tolak',
                        child: Text('Tolak'),
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
