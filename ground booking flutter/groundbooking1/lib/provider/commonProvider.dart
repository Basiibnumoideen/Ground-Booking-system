import 'package:flutter/material.dart';

class CommonProvider extends ChangeNotifier {
  ValueNotifier<bool> isloading = ValueNotifier(false);

  void loading(load) {
    isloading.value = load;
    notifyListeners();
  }

  void showSnackbar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    notifyListeners();
  }

//alertDialod
  void showCustomAlertDialog(BuildContext context, title, subtitle, screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the action when "OK" is pressed
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => screen)); // Close the AlertDialog
                // Add your custom logic here for "OK" button
              },
              child: const Text('OK'),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Perform the action when "Cancel" is pressed
            //     Navigator.of(context).pop(); // Close the AlertDialog
            //     // Add your custom logic here for "Cancel" button
            //   },
            //   child: Text('Cancel'),
            // ),
          ],
        );
      },
    );
    notifyListeners();
  }
}
