import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});
  final email;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isFilled = false;
  String otp = '';
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController conformcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool visibility = true;
  bool conformVisibility = true;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '𝗘𝗻𝘁𝗲𝗿 𝗢𝘁𝗽',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                'check your Email and enter the Code below',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              OtpTextField(
                keyboardType: TextInputType.number,
                numberOfFields: 4,
                borderColor: const Color(0xFF512DA8),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                  setState(() {
                    isFilled = false;
                  });
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  setState(() {
                    isFilled = true;
                    otp = verificationCode;
                  });
                }, // end onSubmit
              ),
              const SizedBox(
                height: 10,
              ),
              isFilled
                  ? CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'invalid input';
                        } else if (value.length < 6) {
                          return 'Password must be 6 digits';
                        }
                        return null;
                      },
                      controller: passwordcontroller,
                      suffix: InkWell(
                        onTap: () {
                          visibility = !visibility;
                          setState(() {});
                        },
                        child: visibility
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      prefixIcon: const Icon(Icons.key),
                      obsecure: visibility,
                      labelText: 'New Password',
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 5,
              ),
              isFilled
                  ? CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'invalid input';
                        } else if (value.length < 6) {
                          return 'Password must be 6 digits';
                        } else if (passwordcontroller.text != value) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                      controller: conformcontroller,
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            conformVisibility = !conformVisibility;
                          });
                        },
                        child: conformVisibility
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      prefixIcon: const Icon(Icons.key),
                      obsecure: conformVisibility,
                      labelText: 'Conform Password',
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate() && otp != '') {
                          //perform
                          await changePassword({
                            'email': widget.email,
                            'otp': otp,
                            'new_password': passwordcontroller.text,
                          }, context, provider);
                        }
                      },
                      child: const Text('Update'))),
            ],
          ),
        ),
      ),
    );
  }
}
