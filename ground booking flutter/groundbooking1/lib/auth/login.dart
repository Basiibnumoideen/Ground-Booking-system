import 'package:demo123/auth/forgotPassword.dart';
import 'package:demo123/auth/register.dart';
import 'package:demo123/ipScreen.dart';
import 'package:demo123/main.dart';
import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obsecure = true;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        navigation2(context, IpScreen());
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 5),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Username',
                                controller: usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username';
                                  } else if (value.length < 3) {
                                    return 'Must be at least 3 characters long';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              CustomTextField(
                                suffix: IconButton(
                                  icon: obsecure
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      obsecure = !obsecure;
                                    });
                                  },
                                ),
                                obsecure: obsecure,
                                prefixIcon: const Icon(Icons.lock),
                                labelText: 'Password',
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  } else if (value.length < 6) {
                                    return 'Must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                    onPressed: () {
                                      navigation(context, ForgotPassword());
                                    },
                                    child: const Text('Forgot Password?')),
                              ),
                              const SizedBox(height: 20),
                              ValueListenableBuilder(
                                valueListenable: provider.isloading,
                                builder: (context, value, child) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        // You can also access the input values directly from the controllers
                                        print('hello');
                                        provider.loading(true);
                                        await loginUser(
                                            usernameController.text,
                                            passwordController.text,
                                            context,
                                            provider);
                                        provider.loading(false);
                                        print('hello3');
                                      }
                                    },
                                    child: provider.isloading.value
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : const Text('Login'),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Dont hve an Account?'),
                      TextButton(
                          onPressed: () {
                            navigation(context, const Registration());
                          },
                          child: const Text('Register'))
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        navigation(context, IpScreen());
                      },
                      child: const Text('Enter IP'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
