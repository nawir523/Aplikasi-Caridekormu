import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> registerWithRole(String email, String password, String role) async {
    // 1. Buat akun di Firebase Authentication
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = userCred.user!.uid;

    // 2. Simpan ke koleksi sesuai role
    if (role == 'PENYEWA') {
      await _db.collection('penyewas').doc(uid).set({
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
      });
    } else if (role == 'VENDOR') {
      await _db.collection('vendors').doc(uid).set({
        'email': email,
        'business_name': '',
        'products': [],
        'created_at': FieldValue.serverTimestamp(),
      });
    } else if (role == 'ADMIN') {
      await _db.collection('admins').doc(uid).set({
        'email': email,
        'permissions': [],
        'created_at': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('Peran tidak dikenal');
    }

    // (Opsional) Tambahkan ke koleksi pusat, jika Anda ingin ada "semua user"
    await _db.collection('users_summary').doc(uid).set({
      'email': email,
      'role': role,
    });
  }

  
    Future<String> loginAndGetRole(String email, String password) async {
    // 1. Login user
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = cred.user!.uid;

    // 2. Cek koleksi role
    if ((await _db.collection('penyewas').doc(uid).get()).exists) {
      return 'PENYEWA';
    } else if ((await _db.collection('vendors').doc(uid).get()).exists) {
      return 'VENDOR';
    } else if ((await _db.collection('admins').doc(uid).get()).exists) {
      return 'ADMIN';
    } else {
      throw Exception('Role pengguna tidak ditemukan');
    }
  }

}
