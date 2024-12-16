import 'package:demo123/ipScreen.dart';
import 'package:demo123/main.dart';
import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/screens/batch/myBatches.dart';
import 'package:demo123/screens/batch/sportsitemlist.dart';
import 'package:demo123/screens/event/groundbooking.dart';
import 'package:demo123/screens/event/myBookings.dart';
import 'package:demo123/screens/gallary.dart';
import 'package:demo123/screens/news.dart';
import 'package:demo123/screens/profile.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  int backPressCount = 0;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (backPressCount == 0) {
          // Display a message on the first tap
          provider.showSnackbar(context, 'Press Again to Exit', Colors.white);
          print('Press again to exit');
          // Increase the backPressCount
          backPressCount++;
          // Do not close the app
          return false;
        } else {
          // On the second tap, close the app
          await SystemNavigator.pop();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0XFF108554),
          title: const Text(
            'Club Managment',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(192, 67, 229, 159),
          child: Column(
            children: [
              DrawerHeader(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Center(
                      child: ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        navigation(context, const ProfileScreen());
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    title: Text(userDataList['name'] ?? ''),
                    subtitle: Text(userDataList['email'] ?? ''),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userDataList['photo'] ??
                          'https://tse1.mm.bing.net/th?id=OIP.0CZd1ESLnyWIHdO38nyJDAAAAA&pid=Api&rs=1&c=1&qlt=95&w=123&h=101'),
                    ),
                  ))),
              ListTile(
                title: const Text('Log Out'),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              navigation(context, IpScreen());
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/clubg.png'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildContainer(context, () async {
                        navigation(context, const Gallery());
                      }, 'View Gallery'),
                      buildContainer(context, () async {
                        navigation(context, const ViewNews());
                        Future.delayed(
                          const Duration(seconds: 5),
                        );
                      }, 'Newses'),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildContainer(context, () {
                        navigation(context, const GroundBookingScreen());
                      }, 'Ground Booking'),
                      buildContainer(context, () async {
                        await getSportitemList();
                        navigation(context, const SportsItemList());
                      }, 'Batch Booking'),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildContainer(context, () async {
                        await getUserBookings();
                        navigation(context, const MyBookings());
                      }, 'My Bookings'),
                      buildContainer(context, () async {
                        await getUserBatches();
                        navigation(context, const MyBatches());
                      }, 'My Batches'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
