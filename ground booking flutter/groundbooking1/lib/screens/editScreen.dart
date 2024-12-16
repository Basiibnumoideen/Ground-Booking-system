import 'dart:io';

import 'package:demo123/main.dart';
import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/screens/profile.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController nameController =
      TextEditingController(text: userDataList['name']);

  final TextEditingController addressController =
      TextEditingController(text: userDataList['address']);

  final TextEditingController emailController =
      TextEditingController(text: userDataList['email']);

  final TextEditingController phoneController =
      TextEditingController(text: userDataList['phoneno'].toString());

  final TextEditingController doBController =
      TextEditingController(text: userDataList['date_of_birth'].toString());

  String selectedGender = userDataList['gender'];

  XFile? image = XFile('');
  String? imagePath = '';

  Future<XFile?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      image = await picker.pickImage(source: ImageSource.gallery);
      print(image!.path);
      setState(() {
        imagePath = image!.path;
      });

      return image;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: imagePath == ''
                    ? Image.network(userDataList['photo'] ??
                        'https://tse1.mm.bing.net/th?id=OIP.0CZd1ESLnyWIHdO38nyJDAAAAA&pid=Api&rs=1&c=1&qlt=95&w=123&h=101')
                    : Image.file(File(imagePath!)),
              ),
              // CircleAvatar(
              //   radius: 70,
              //   backgroundImage: NetworkImage(),
              //   // Assuming 'photo' is the key for the image URL
              // ),
              TextButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text('Edit Image')),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.person),
                labelText: 'Name',
                controller: nameController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.location_city_outlined),
                labelText: 'Address',
                controller: addressController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.email),
                labelText: 'Email',
                controller: emailController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.phone),
                labelText: 'Phone',
                controller: phoneController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.calendar_month),
                hintText: 'YYYY-MM-DD',
                labelText: 'DOB',
                controller: doBController,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Gender:  '),
                    DropdownButton<String>(
                      padding: const EdgeInsets.all(6),
                      underline: const SizedBox(),
                      value: selectedGender,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ValueListenableBuilder(
                valueListenable: provider.isloading,
                builder: (context, value, child) {
                  return ElevatedButton(
                      onPressed: () async {
                        provider.loading(true);
                        Map<String, dynamic> dataToPost = {
                          // 'username': usernameController.text,
                          // 'password': passwordController.text,
                          'id': memuid,
                          'name': nameController.text,
                          'address': addressController.text,
                          'email': emailController.text,
                          'phoneno': phoneController.text,
                          'date_of_birth': doBController.text,
                          'gender': selectedGender,
                          'member': userDataList['member'],
                          // 'photo': image!.path == '' ? ['photo'] : image!.path,
                          'date_of_join':
                              userDataList['date_of_join'].toString(),
                        };

                        // await updateProfile(dataToPost);
                        await updateUserdatas(
                            dataToPost,
                            image!.path == ''
                                ? userDataList['photo']
                                : image!.path,
                            provider,
                            context);
                        await getUserDatas();
                        provider.loading(false);
                        navigation(context, const ProfileScreen());
                        print(image!.path);
                      },
                      child: provider.isloading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Update'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
