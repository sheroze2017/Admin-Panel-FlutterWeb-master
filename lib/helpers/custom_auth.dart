import 'package:get/get.dart';

import '../constants/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

const baseUrl = "http://3.80.53.112:4005/api/v1";

final connect = GetConnect();

Future userSignup(String username, String email, String password) async {
  try {
    var result = await connect.post(
      '${Constants.localHost}/signup',
      {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return result.body;
  } catch (e) {
    return e.toString();
  }
}

Future userLogin(String email, String password) async {
  try {
    var result = await connect.post(
      '${Constants.localHost}/login',
      {
        'email': email,
        'password': password,
      },
    );
    return result.body;
  } catch (e) {
    return e.toString();
  }
}

class LoginController extends GetxController {
  var status = false.obs;
  var message = ''.obs;
  var error = ''.obs;
  var userId = 0.obs;
  var fullName = ''.obs;
  var email = ''.obs;
  var mobile = ''.obs;
  var isActive = false.obs;
  var isVerify = false.obs;
  var createdAt = ''.obs;
  var updatedAt = ''.obs;
  var roleId = 0.obs;
  var roleName = ''.obs;
  var accessToken = ''.obs;
  var refreshToken = ''.obs;
  var expiresIn = ''.obs;
  var refreshExpiresIn = ''.obs;
  var isloading = false.obs;
  var logoutLoader = false.obs;
  Future login(String mobileno, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isloading.value = true;
    String apiUrl = '$baseUrl/users/login';

    try {
      Map<String, String> data = {
        'mobile': mobileno,
        'password': password,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if role name is "Admin" and message is "Login successful"
        if (responseData['status'] == true &&
            responseData['message'] == 'Login successful' &&
            responseData['data'] != null &&
            responseData['data']['user'] != null &&
            responseData['data']['user']['role'] != null &&
            responseData['data']['user']['role']['name'] == 'Admin') {
          // Store required data in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('id', responseData['data']['user']['id']);
          prefs.setString('name', responseData['data']['user']['full_name']);
          prefs.setString('email', responseData['data']['user']['email']);
          prefs.setString('mobile', responseData['data']['user']['mobile']);
          prefs.setString('access_token', responseData['data']['access_token']);
          prefs.setString(
              'refresh_token', responseData['data']['refresh_token']);
          return true;
        }
      } else if (response.statusCode == 404) {
        // Invalid credentials
        Get.snackbar('Error', 'Invaild Credentials');
        return false;
        //print('Invalid credentials');
      } else {
        // Error occurred during login
        print('Login failed');
        return false;
      }
    } catch (error) {
      print('An error occurred: $error');
      // Handle connection errors or other exceptions
      return false;
    } finally {
      isloading.value = false;
    }
  }
}
