import 'package:flutter/material.dart';
import 'package:hajeri/screen/admin_screens/add_emp_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isClockedIn = false;
  DateTime? _clockInTime;
  DateTime? _clockOutTime;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkClockStatus();
  }

  Future<void> _checkClockStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      final clockData = await _firestore
          .collection('clock_records')
          .doc(user.uid)
          .get();

      if (clockData.exists) {
        final data = clockData.data()!;
        if (data.containsKey('clock_in')) {
          _isClockedIn = true;
          _clockInTime = (data['clock_in'] as Timestamp).toDate();
        }
        if (data.containsKey('clock_out')) {
          _clockOutTime = (data['clock_out'] as Timestamp).toDate();
          _isClockedIn = false;
        }
      }
      setState(() {});
    }
  }

  Future<void> _clockInOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      if (_isClockedIn) {
        // Clock out
        await _firestore.collection('clock_records').doc(user.uid).update({
          'clock_out': Timestamp.fromDate(now),
        });
        setState(() {
          _isClockedIn = false;
          _clockOutTime = now;
        });
      } else {
        // Clock in
        await _firestore.collection('clock_records').doc(user.uid).set({
          'clock_in': Timestamp.fromDate(now),
        }, SetOptions(merge: true));
        setState(() {
          _isClockedIn = true;
          _clockInTime = now;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'User Name'),
              accountEmail: Text(user?.email ?? 'user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? 'https://via.placeholder.com/150'),
              ),
            ),
            ListTile(
              title: Text('Add Employee'),
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployeeScreen(),));
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Handle settings tap
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0.w), // Use responsive padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0), // Border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes the column size to fit its content
          children: [
            ElevatedButton(
              onPressed: _clockInOut,
              child: Text(_isClockedIn ? 'Clock Out' : 'Clock In'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full width
              ),
            ),
            SizedBox(height: 2.h),
            if (_isClockedIn && _clockInTime != null)
              Text('Clocked in at: ${_clockInTime!.toLocal()}'),
            if (!_isClockedIn && _clockOutTime != null)
              Text('Clocked out at: ${_clockOutTime!.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
