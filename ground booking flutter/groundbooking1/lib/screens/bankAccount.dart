import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class BankAccountDetails extends StatelessWidget {
  const BankAccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: const Text('Account Deteils',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              title: Text('AccNo: ' + accountdetails[0]['account_number']),
            ),
            ListTile(
              title: Text('IFSC: ' + accountdetails[0]['IFSC']),
            ),
            ListTile(
              title: Text('PIN: ' + accountdetails[0]['key']),
            )
          ],
        ),
      ),
    );
  }
}
