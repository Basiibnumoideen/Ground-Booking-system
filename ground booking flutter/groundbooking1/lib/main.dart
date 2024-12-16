import 'package:demo123/ipScreen.dart';
import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/screens/memeberhome.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CommonProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FutureBuilder<Widget>(
        future: checkUserAuthentication(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              // While the future is still running, show a loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              // Future is complete, check for data or error
              if (snapshot.hasData) {
                // User is authenticated, show the authenticated screen
                return HomeScreen();
              } else {
                // User is not authenticated, show the login screen
                return IpScreen();
              }
            default:
              // Handle ConnectionState.active or any other unexpected state
              return Center(
                child: Text(
                    'Unexpected connection state: ${snapshot.connectionState}'),
              );
          }
        },
      ),
    );
  }
}

Future<Widget> checkUserAuthentication() async {
  token = await loadStoredValue('token');
  id = await loadStoredValue('user_id');
  memuid = await loadStoredValue('memuid');
  baseUrl = await loadStoredValue('ip');
  await getUserDatas();
  if (token!.isNotEmpty && id!.isNotEmpty && memuid!.isNotEmpty) {
    return HomeScreen();
  }

  return IpScreen();
}

void navigation(
  context,
  screen,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void navigation2(
  context,
  screen,
) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}
