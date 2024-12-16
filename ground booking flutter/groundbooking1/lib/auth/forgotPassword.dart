// ignore_for_file: must_be_immutable

import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Image.network(
                  'https://img.freepik.com/free-vector/forgot-password-concept-illustration_114360-1095.jpg?size=626&ext=jpg&ga=GA1.1.321645196.1708071430&semt=ais',
                  fit: BoxFit.cover,
                ),
              ),
              const Text('Enter your Verifield Email Here to get OTP'),
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                valueListenable: provider.isloading,
                builder: (context, value, child) {
                  return SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              provider.loading(true);
                              await forgotPassword(
                                  emailController.text, context, provider);
                              emailController.clear();
                              provider.loading(false);
                            }
                          },
                          child: provider.isloading.value
                              ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text('Sent Otp')));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
