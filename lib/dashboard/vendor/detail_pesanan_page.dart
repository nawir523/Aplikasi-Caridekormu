import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPesananPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String orderId;

  const DetailPesananPage({super.key, required this.data, required this.orderId});

  @override
  Widget build(BuildContext context) {
    String tanggalBuat = '';
    if (data['created_at'] != null && data['created_at'] is Timestamp) {
      DateTime date = (data['created_at'] as Timestamp).toDate();
      tanggalBuat = '${date.day}-${date.month}-${date.year}';
    }

    final status = data['status'] ?? 'pending';
    Color chipColor;
    switch (status) {
      case 'disetujui':
        chipColor = Colors.green.shade200;
        break;
      case 'ditolak':
        chipColor = Colors.red.shade200;
        break;
      default:
        chipColor = Colors.grey.shade300;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        backgroundColor: Colors.pink.shade100, // header pink lembut
      ),
      backgroundColor: const Color(0xFFFFF5EE), // seashell
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Produk: ${data['nama_produk'] ?? '-'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text('Penyewa: ${data['nama_penyewa'] ?? '-'}'),
                    const SizedBox(height: 4),
                    Text('Tanggal Sewa: ${data['tanggal_sewa'] ?? '-'}'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Status: '),
                        Chip(
                          label: Text(status),
                          backgroundColor: chipColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Tanggal dibuat: $tanggalBuat'),
                    const SizedBox(height: 12),
                    Text(
                      'Catatan tambahan:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(data['catatan'] ?? 'Tidak ada catatan'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection('vendors')
                          .doc(uid)
                          .collection('orders')
                          .doc(orderId)
                          .update({'status': 'disetujui'});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Status diupdate menjadi disetujui')),
                      );
                      Navigator.pop(context); // kembali agar refresh
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Setujui'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection('vendors')
                          .doc(uid)
                          .collection('orders')
                          .doc(orderId)
                          .update({'status': 'ditolak'});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Status diupdate menjadi ditolak')),
                      );
                      Navigator.pop(context); // kembali agar refresh
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Tolak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
