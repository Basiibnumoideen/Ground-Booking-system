import 'package:demo123/main.dart';
import 'package:demo123/screens/bankAccount.dart';
import 'package:demo123/screens/editScreen.dart';
import 'package:demo123/screens/memeberhome.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xFF108554),
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                  onPressed: () {
                    navigation(context, const EditScreen());
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userDataList['photo'] ??
                        'https://tse1.mm.bing.net/th?id=OIP.0CZd1ESLnyWIHdO38nyJDAAAAA&pid=Api&rs=1&c=1&qlt=95&w=123&h=101'),
                  ),
                  Text(userDataList['name']),
                  ListTile(
                    title: Text('Address: ' + userDataList['address']),
                  ),
                  ListTile(
                    title: Text('Email: ' + userDataList['email']),
                  ),
                  ListTile(
                    title: Text('Phone: ${userDataList['phoneno']}'),
                  ),
                  ListTile(
                    title: Text('DOB: ${userDataList['date_of_birth']}'),
                  ),
                  ListTile(
                    title: Text('Gender: ' + userDataList['gender']),
                  ),
                  ListTile(
                    title: Text(
                        'Account Created: ${userDataList['date_of_join']}'),
                  ),
                  ListTile(
                    onTap: () async {
                      await getaccNoIfsc(memuid);
                      navigation(context, const BankAccountDetails());
                    },
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    title: const Text('Bank Account Details'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
