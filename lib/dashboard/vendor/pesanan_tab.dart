import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detail_pesanan_page.dart';

class PesananTab extends StatelessWidget {
  const PesananTab({super.key});

  Future<void> updateStatus(BuildContext context, String orderId, String status) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(uid)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan diupdate menjadi: $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Container(
      color: const Color(0xFFFFF5EE), // seashell
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .doc(uid)
            .collection('orders')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada pesanan'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'pending';

              // Pilih warna chip berdasarkan status
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

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    data['nama_produk'] ?? 'Produk',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Penyewa: ${data['nama_penyewa'] ?? '-'}'),
                      Text('Tanggal sewa: ${data['tanggal_sewa'] ?? '-'}'),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(status, style: const TextStyle(fontSize: 12)),
                        backgroundColor: chipColor,
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'setujui') {
                        updateStatus(context, doc.id, 'disetujui');
                      } else if (value == 'tolak') {
                        updateStatus(context, doc.id, 'ditolak');
                      } else if (value == 'detail') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPesananPage(
                              data: data,
                              orderId: doc.id,
                            ),
                          ),
                        );
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
                      const PopupMenuItem(
                        value: 'detail',
                        child: Text('Lihat Detail'),
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
