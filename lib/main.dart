import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'auth/login.dart';
import 'auth/register.dart';
import 'dashboard/penyewa/user_main_pag.dart';
import 'dashboard/vendor/vendor_home.dart';
import 'dashboard/admin/admin_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARIDEKORMU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(), // SplashScreen sebagai entry point
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  Future<Widget> _checkLoginAndRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginPage(); // belum login
    }

    final uid = user.uid;
    final db = FirebaseFirestore.instance;

    // Cek role dari masing-masing koleksi
    if ((await db.collection('penyewas').doc(uid).get()).exists) {
      return UserMainPage();
    } else if ((await db.collection('vendors').doc(uid).get()).exists) {
      return VendorHome();
    } else if ((await db.collection('admins').doc(uid).get()).exists) {
      return AdminHome();
    } else {
      // Tidak ditemukan di koleksi mana pun → logout
      await FirebaseAuth.instance.signOut();
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkLoginAndRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Terjadi error: ${snapshot.error}")),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
