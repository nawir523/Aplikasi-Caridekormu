import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String productId;
  final String vendorId;

  const ProductDetailPage({
    super.key,
    required this.productData,
    required this.productId,
    required this.vendorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productData['nama'] ?? 'Detail Produk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          productData['fotoUrl'] != null
              ? Image.network(
                  productData['fotoUrl'],
                  height: 200,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 100),
                ),
          const SizedBox(height: 16),
          Text(
            productData['nama'] ?? '-',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Rp${productData['harga'] ?? '-'}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            productData['deskripsi'] ?? 'Tidak ada deskripsi',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (selectedDate != null) {
                await _pesanProduk(context, selectedDate);
              }
            },
            child: const Text('Pesan Produk Ini'),
          ),
        ],
      ),
    );
  }

  // ⬇️ Tambahkan method ini di DALAM class ProductDetailPage (setelah build)
  Future<void> _pesanProduk(BuildContext context, DateTime tanggalSewa) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final orderData = {
      'productId': productId,
      'vendorId': vendorId,
      'nama_produk': productData['nama'] ?? '-',
      'harga': productData['harga'] ?? 0,
      'fotoUrl': productData['fotoUrl'],
      'status': 'pending',
      'tanggal_sewa': tanggalSewa,
      'created_at': FieldValue.serverTimestamp(),
      'userId': user.uid,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add(orderData);

      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('orders')
          .add({
            ...orderData,
            'nama_penyewa': user.email ?? 'Penyewa',
          });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat pesanan')),
        );
      }
    }
  }
}
