import 'dart:convert';
import 'package:demo123/auth/login.dart';
import 'package:demo123/auth/otpscreen.dart';
import 'package:demo123/main.dart';
import 'package:demo123/screens/memeberhome.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = '';
List<String> imageUrlsList = [];
List<Map<String, dynamic>> newsList = [];

String? token;
String? id;
String? memuid;
List<Map<String, dynamic>> dropDownList = [];
List<Map<String, dynamic>> sportsItemList = [];
List<Map<String, dynamic>> selectedBatchList = [];
List<Map<String, dynamic>> selectedBatchTimeList = [];
List<String> dateList = [];
List<Map<String, dynamic>> accountdetails = [];
List<Map<String, dynamic>> myBookingList = [];
List<Map<String, dynamic>> myBatchList = [];
Map<String, dynamic> userDataList = {};

//shared preference

Future<String> loadStoredValue(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? storedValue =
      prefs.getString(key); // If the key doesn't exist, return an empty string
  return storedValue!;
}

void saveValue(key, value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

// registrationAPI

Future<void> postDataToDjango(
    Map<String, dynamic> data, filePath, context) async {
  final String apiUrl = 'http://$baseUrl/apiclubmember';
  try {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        filePath,
      ),
    );
    print('started');
    // Send the request
    var streamedResponse = await request.send();
    print('started');
    // Get response as string
    var response = await http.Response.fromStream(streamedResponse);

    print(response.statusCode);

    if (response.statusCode == 201) {
      // Request was successful
      print('Response from server: ${response.body}');
      navigation(context, const Login());
    } else {
      // Handle errors
      print(
          'Failed to post data to Django server. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle exceptions
    print('Error posting data: $e');
  }
}

//loginAPI
Future<void> loginUser(
    String username, String password, context, provider) async {
  final url = Uri.parse('http://$baseUrl/apiuserlogin');

  try {
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print({'success': true, 'data': responseData});
      if (responseData['token'] != null) {
        navigation(context, HomeScreen());
        provider.showSnackbar(context, 'Login Success', Colors.green);

        token = responseData['token'];

        Map<String, dynamic> sessondata = responseData['session_data'];
        print(sessondata);

        id = sessondata['user_id'].toString();
        memuid = sessondata['memuid'].toString();

        //save to shared pref
        saveValue('token', token);
        saveValue('user_id', id);
        saveValue('memuid', memuid);
        saveValue('ip', baseUrl);
        await getUserDatas();
        print('saved to sharedpref successfully');
      } else {
        print("sorry");
        provider.showSnackbar(context, "can't perform login", Colors.red);
      }
    } else {
      // If that response was not OK, throw an error.
      provider.showSnackbar(context, 'Login failed', Colors.red);
      throw Exception('Failed to login');
    }
  } catch (e) {
    // Catch any errors during the process
    provider.showSnackbar(context, 'Login failed', Colors.red);
    print({'success': false, 'error': e.toString()});
  }
}

// get gallery images

Future<void> fetchImagesFromDjango() async {
  final response = await http.get(Uri.parse('http://$baseUrl/apiclubgallary'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse); // Decode as Map

    if (jsonResponse.containsKey('data')) {
      List<Map<String, dynamic>> images =
          List<Map<String, dynamic>>.from(jsonResponse['data']);
      print(images);

      List<String> imageUrls = [];
      for (var url in images) {
        imageUrls.add(url['img']);
      }
      print(imageUrls);
      imageUrlsList = imageUrls;
    } else {
      throw Exception('No data field found in the response');
    }
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load images');
  }
}

// get news
Future<void> fetchNewsListFromApi() async {
  final url = Uri.parse('http://$baseUrl/apinewsview');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      print(stringList);

      newsList = stringList;
    } else {
      throw Exception('Failed to load news');
    }
  } catch (error) {
    // Throw exception if there's an error in making the request
    throw Exception('Failed to fetch data: $error');
  }
}

//Ground Booking
Future<void> storeDataToApiWithIdAndToken(
    Map<String, dynamic> data, context, provider) async {
  try {
    print(data);
    final response = await http.post(
      Uri.parse('http://$baseUrl/apigroundbooking'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      provider.showSnackbar(
          context, 'ground Booked successfully', Colors.green);
      print(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to store data: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

//getDropdownlist
Future<void> getDropdownListFromApi() async {
  final url = Uri.parse('http://$baseUrl/apiviewpurpose');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      print(stringList);

      dropDownList = stringList;
    } else {
      throw Exception('Failed to load news');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//get Booked dates slots(dates)
Future<void> getDatesFromApi() async {
  final url = Uri.parse('http://$baseUrl/apiviewbookeddate');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      print(responseData);

      List<String> stringList = json.decode(response.body).cast<String>();
      print(stringList);

      dateList = stringList;
    } else {
      throw Exception('Failed to load news');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

// get sport items
Future<void> getSportitemList() async {
  final url = Uri.parse('http://$baseUrl/apisportsitemview');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      print(stringList);

      sportsItemList = stringList;
    } else {
      throw Exception('Failed to load SportsItem');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

// get batchList using id
Future<void> getBatchListUsingId(id) async {
  final url = Uri.parse('http://$baseUrl/apibatchview/$id');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      print(stringList);

      selectedBatchList = stringList;
    } else {
      throw Exception('Failed to load Batches');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//  get batch time list using id
Future<void> getBatchTimeListUsingId(id) async {
  final url = Uri.parse('http://$baseUrl/apibatchtimeview/$id');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      print(stringList);

      selectedBatchTimeList = stringList;
    } else {
      throw Exception('Failed to load Batches time');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//get acc anfd ifsc
Future<void> getaccNoIfsc(id) async {
  final url = Uri.parse('http://$baseUrl/apiusergroundbookaccountview/$id');
  try {
    final response = await http.get(url);
    print('.src');
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      accountdetails = stringList;
      print(responseData);
    } else {
      throw Exception('Failed to load account and ifsc');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//update balance amount
Future<void> updateBalanceAmount(amount, context, provider) async {
  try {
    print(amount);
    final response = await http.post(
      Uri.parse('http://$baseUrl/apiusergroundbookingpayment/$memuid/$amount'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      provider.showCustomAlertDialog(context, 'payment success',
          'Booking Success\n waiting for Confirmation', HomeScreen());
      print(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to store data: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

//get user's bookings
Future<void> getUserBookings() async {
  final url = Uri.parse('http://$baseUrl/apiusergroundbookingview/$memuid');
  try {
    final response = await http.get(url);
    print('.src');
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      myBookingList = stringList;
      print(responseData);
    } else {
      throw Exception('Failed to load user Bookings');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//batch booking

Future<void> batchBooking(Map<String, dynamic> data, context, provider) async {
  try {
    print(data);
    final response = await http.post(
      Uri.parse('http://$baseUrl/apiuserregisterbatch'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token', // Assuming token-based authentication
        // 'user_id': id, // Assuming you need to include an ID header
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      provider.showSnackbar(context, 'Booked successfully', Colors.green);
      print(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to store data: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

//get users batchList
Future<void> getUserBatches() async {
  final url = Uri.parse('http://$baseUrl/apiUserBatchregisterview/$memuid');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> stringList =
          responseData.cast<Map<String, dynamic>>();
      myBatchList = stringList;
      print(responseData);
    } else {
      throw Exception('Failed to load user Batches');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//get userDatas
Future<void> getUserDatas() async {
  final url = Uri.parse('http://$baseUrl/apimemberviewprofile/$memuid');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> responseData = json.decode(response.body);

      userDataList = responseData;
      print('ok');
      print(responseData);
    } else {
      throw Exception('Failed to load user Datas');
    }
  } catch (error) {
    throw Exception('Failed to fetch data: $error');
  }
}

//kjbk
Future<void> updateUserdatas(
    Map<String, dynamic> data, filePath, provider, context) async {
  final String apiUrl = 'http://$baseUrl/apimemeberprofileupdate/$memuid';
  try {
    var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        filePath,
      ),
    );
    print('started');
    // Send the request
    var streamedResponse = await request.send();
    print('started');
    // Get response as string
    var response = await http.Response.fromStream(streamedResponse);

    print(response.statusCode);

    if (response.statusCode == 200) {
      // Request was successful
      provider.showSnackbar(context, 'Updated successfully', Colors.green);
      print('Response from server: ${response.body}');
    } else {
      // Handle errors
      print(
          'Failed to post data to Django server. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle exceptions
    print('Error posting data: $e');
  }
}

//forgotpassword mail
Future<void> forgotPassword(email, context, provider) async {
  try {
    print(email);
    final response = await http.post(
      Uri.parse('http://$baseUrl/forgotpassword/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}), // Make sure to encode email properly
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
      provider.showSnackbar(context, 'Email send to $email', Colors.green);
      navigation(
          context,
          OtpScreen(
            email: email,
          ));
      // Handle success, e.g., show a success message or navigate to a success screen
      // provider.showCustomAlertDialog(context, 'Email sent', 'Booking Success\n waiting for Confirmation', HomeScreen());
    } else {
      print(response.statusCode);
      // Handle failure, throw an exception, or show an error message
      provider.showSnackbar(context, 'failed to send imail', Colors.red);
      throw Exception('Failed to send email: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
    // Handle the exception, e.g., show an error message to the user
  }
}

//changePassword
Future<void> changePassword(data, context, provider) async {
  try {
    print(data);
    final response = await http.post(
      Uri.parse('http://$baseUrl/changepassword/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data), // Make sure to encode email properly
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
      provider.showSnackbar(
          context, 'password changed successfully', Colors.green);
      navigation(context, const Login());
      // Handle success, e.g., show a success message or navigate to a success screen
      // provider.showCustomAlertDialog(context, 'Email sent', 'Booking Success\n waiting for Confirmation', HomeScreen());
    } else {
      print(response.statusCode);
      // Handle failure, throw an exception, or show an error message
      provider.showSnackbar(context, 'Error changing password', Colors.red);

      throw Exception('Failed to change password: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
    // Handle the exception, e.g., show an error message to the user
  }
}
