import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save role (student, mentor, admin, etc.) for the current authenticated user
  Future<void> saveUserRole(String email, String role) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No authenticated user");

    await _db.collection('users').doc(user.uid).set({
      'email': email,
      'role': role,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get current user's role from Firestore using UID
  Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()!.containsKey('role')) {
      return doc['role'];
    }
    return null;
  }

  /// Save an interaction between student and mentor
  Future<void> saveInteraction(String studentId, String mentorId) async {
    await _db.collection('interactions').add({
      'studentId': studentId,
      'mentorId': mentorId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Save attendance under a faculty (mentor) for a bus
  Future<void> saveAttendance({
    required String facultyName,
    required String busNumber,
    required String studentId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No authenticated user");

    await _db
        .collection('attendance')
        .doc(facultyName)
        .collection('scans')
        .add({
      'facultyId': user.uid,
      'facultyName': facultyName,
      'busNumber': busNumber,
      'studentId': studentId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Stream today's attendance for a faculty (mentor)
  Stream<QuerySnapshot<Map<String, dynamic>>> getTodayAttendance(
      String facultyName,
      ) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    return _db
        .collection('attendance')
        .doc(facultyName)
        .collection('scans')
        .where(
      'timestamp',
      isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
    )
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}