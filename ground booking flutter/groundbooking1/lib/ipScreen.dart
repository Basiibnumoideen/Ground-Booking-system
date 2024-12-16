import 'package:demo123/auth/login.dart';
import 'package:demo123/main.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:flutter/material.dart';

class IpScreen extends StatelessWidget {
  IpScreen({super.key});
  final TextEditingController ipController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  hintText: '192.168.X.XX:XXXX',
                  enableSuggession: true,
                  labelText: 'IP Address and port Number',
                  controller: ipController,
                  validator: (s) =>
                      s!.isEmpty ? 'enter IP addrss and port Number' : null,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      baseUrl = ipController.text;
                      if (formKey.currentState!.validate() &&
                          baseUrl.isNotEmpty) {
                        navigation(context, const Login());
                      }
                    },
                    child: const Text('Continue'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
