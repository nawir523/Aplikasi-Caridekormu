import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KalenderTab extends StatefulWidget {
  const KalenderTab({super.key});

  @override
  State<KalenderTab> createState() => _KalenderTabState();
}

class _KalenderTabState extends State<KalenderTab> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Set<String> unavailableDates = {}; // simpan tanggal yang sudah libur

  @override
  void initState() {
    super.initState();
    fetchUnavailableDates();
  }

  Future<void> fetchUnavailableDates() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(uid)
        .collection('calendar')
        .get();

    final dates = snapshot.docs.map((doc) => doc.id).toSet();

    setState(() {
      unavailableDates = dates;
    });
  }

  Future<void> toggleUnavailable(DateTime day) async {
    final dateStr = day.toIso8601String().substring(0, 10); // YYYY-MM-DD
    final docRef = FirebaseFirestore.instance
        .collection('vendors')
        .doc(uid)
        .collection('calendar')
        .doc(dateStr);

    if (unavailableDates.contains(dateStr)) {
      // Sudah ada → hapus
      await docRef.delete();
      setState(() {
        unavailableDates.remove(dateStr);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dihapus dari libur')),
      );
    } else {
      // Belum ada → tambahkan
      await docRef.set({'unavailable': true});
      setState(() {
        unavailableDates.add(dateStr);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal ditandai sebagai libur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF5EE), // seashell background
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              toggleUnavailable(selectedDay);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.pink.shade300, // warna pink lembut saat dipilih
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.pink.shade100,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final dateStr = day.toIso8601String().substring(0, 10);
                if (unavailableDates.contains(dateStr)) {
                  return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade200, // pink lembut untuk libur
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap tanggal untuk tandai libur / batal',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
