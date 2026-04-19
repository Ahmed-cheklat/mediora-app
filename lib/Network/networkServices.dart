// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthResult {
  final bool success;
  final String message;
  final String? token;

  AuthResult({required this.success, required this.message, this.token});
}

class AuthService {
  String? _extractCookieValue(String setCookieHeader, String cookieName) {
    final parts = setCookieHeader.split(',');
    for (final part in parts) {
      final cookies = part.split(';');
      for (final cookie in cookies) {
        final trimmed = cookie.trim();
        if (trimmed.startsWith('$cookieName=')) {
          return trimmed.substring('$cookieName='.length);
        }
      }
    }
    return null;
  }

  // Define your base URL once so you don't have to repeat it
  static const String _baseUrl = 'https://mediora-back-2.onrender.com';

  // -------------------------
  // SIGN IN
  // -------------------------
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signin'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('FULL SIGNIN RESPONSE: $data');
        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          await prefs.setString('access_token', data['token']);
        }

        final String? refreshTokenHeader = response.headers['refresh_token'];

        if (refreshTokenHeader != null) {
          // If the token comes with "Bearer " prefix in the header, you might want to remove it:
          // final cleanToken = refreshTokenHeader.replaceFirst('Bearer ', '');

          await prefs.setString('refresh_token', refreshTokenHeader);
          print(
            'Refresh Token extracted from header and saved: $refreshTokenHeader',
          );
          print('Header refresh token: ${response.headers['refresh_token']}');
          print('Cookie header: ${response.headers['set-cookie']}');
          // In signIn, after saving tokens:
          final String? deviceIdCookie = _extractCookieValue(
            response.headers['set-cookie'] ?? '',
            'device_id',
          );
          if (deviceIdCookie != null) {
            await prefs.setString('device_id', deviceIdCookie);
            print('Device ID from backend saved: $deviceIdCookie');
          }
        } else {
          // Printing all header keys to help you debug what the actual key name is
          print(
            'No refresh token found. Available header keys: ${response.headers.keys}',
          );
        }

        print('Token: ${data['token']}');
        return AuthResult(success: true, message: "Welcome Back");
      }
      if (response.statusCode == 401) {
        return AuthResult(success: false, message: "Wrong email or password");
      }
      print('Sign In Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Sign In: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  // -------------------------
  // -------------------------
  // CHECK EMAIL (Sign Up Step 1)
  // -------------------------
  Future<AuthResult> checkEmail({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/check-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return AuthResult(
          success: true,
          message: "Check your email for OTP code!",
        );
      }
      if (response.statusCode == 400 || response.statusCode == 409) {
        return AuthResult(success: false, message: "Email already in use");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('Check Email Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Check Email: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  // -------------------------
  // VERIFY EMAIL / Request OTP (Sign Up Step 2)
  // -------------------------
  Future<AuthResult> requestOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/verify-email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return AuthResult(success: true, message: "OTP sent to your email");
      }
      if (response.statusCode == 404) {
        return AuthResult(success: false, message: "Email not found");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('Request OTP Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Request OTP: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  //--------------------------
  Future<AuthResult> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/verify-email?code=$otp&email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('verifyEmail full response: ${response.body}');
        final data = jsonDecode(response.body);
        return AuthResult(
          success: true,
          message: "Email verified successfully",
          token: data['token'],
        );
      }
      if (response.statusCode == 400) {
        return AuthResult(success: false, message: "Invalid OTP code");
      }
      if (response.statusCode == 401) {
        return AuthResult(
          success: false,
          message: "Invalid or expired OTP code",
        );
      }
      if (response.statusCode == 404) {
        return AuthResult(success: false, message: "Email not found");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('Verify OTP Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Verify OTP: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }
  //--------------------------

  Future<AuthResult> checkUsername({required String username}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/check-username'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['exists'] == true) {
          return AuthResult(success: false, message: "Username already taken");
        }
        return AuthResult(success: true, message: "");
      }
      if (response.statusCode == 400 || response.statusCode == 409) {
        return AuthResult(success: false, message: "Username already taken");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('Check Username Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Check Username: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  //---------------------------
  Future<AuthResult> SignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String creationToken,
  }) async {
    print('Creation token being sent: $creationToken');
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          'creation-token': creationToken,
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
          'password': password,
          'role': 'user',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          // or 'access_token' depending on your API
          await prefs.setString('access_token', data['token']);
          print('Access token saved: ${data['token']}');
        }
        final String? refreshTokenHeader = response.headers['refresh_token'];
        if (refreshTokenHeader != null) {
          await prefs.setString('refresh_token', refreshTokenHeader);
          print('refresh token from sign up : $refreshTokenHeader');
        }
        final String? deviceIdCookie = _extractCookieValue(
          response.headers['set-cookie'] ?? '',
          'device_id',
        );
        if (deviceIdCookie != null) {
          await prefs.setString('device_id', deviceIdCookie);
        }

        if (data['exists'] == true) {
          return AuthResult(success: false, message: "Successfully siging up");
        }
        return AuthResult(success: true, message: "");
      }

      if (response.statusCode != 200 && response.statusCode != 500) {
        print('Error : ----------------------------: ${response.statusCode}');
        return AuthResult(success: false, message: "Something went wrong");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('Error : ----------------------------: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during validation: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  //--------------------------
  Future<AuthResult> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      //final String deviceId = await DeviceManager.getDeviceId();
      final String? refreshToken = prefs.getString('refresh_token');
      final String? deviceId = prefs.getString('device_id');
      print('SignOut - deviceId: $deviceId');
      print('SignOut - refreshToken: $refreshToken');
      final response = await http.delete(
        Uri.parse('$_baseUrl/auth/signout'),
        headers: {
          'Content-Type': 'application/json',
          'x-device-id': deviceId!,
          if (refreshToken != null) 'Authorization': 'Bearer $refreshToken',
        },
      );
      print('SignOut status: ${response.statusCode}');
      print('SignOut body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');

        return AuthResult(success: true, message: "Signed out successfully");
      }
      if (response.statusCode == 401) {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        return AuthResult(success: false, message: "Already signed out");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('SignOut Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Sign Out: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  // // -------------------------
  // -------------------------
  // GET REFRESH TOKEN (Call this after signup)
  // -------------------------
  Future<AuthResult> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');
      final String? refreshToken = prefs.getString('refresh_token');
      final String? deviceId = prefs.getString('device_id');

      //final String deviceId = await DeviceManager.getDeviceId();
      if (accessToken == null) {
        return AuthResult(
          success: false,
          message: "Session expired, please sign in again.",
        );
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
          'Cookie':
              'access_token=$accessToken; refresh_token=$refreshToken;device_id=$deviceId',
          //'x-device-id': deviceId,
          //'Cookie': 'refresh_token=$refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final String? newAccessToken = response.headers['access_token'];
        final String? newRefreshToken = response.headers['refresh_token'];

        if (newAccessToken != null) {
          await prefs.setString('access_token', newAccessToken);
        }

        if (newRefreshToken != null) {
          await prefs.setString('refresh_token', newRefreshToken);
        }

        return AuthResult(
          success: true,
          message: "Token refreshed successfully",
        );
      }

      if (response.statusCode == 401) {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        print(response.body);
        return AuthResult(
          success: false,
          message: "Session expired, please sign in again.",
        );
      }

      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Refresh: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  //--------------------------
  Future<AuthResult> forgotPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return AuthResult(
          success: true,
          message: "Reset code sent to your email",
        );
      }
      if (response.statusCode == 404) {
        return AuthResult(success: false, message: "Email not found");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('ForgotPassword Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Forgot Password: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }
  //--------------------------

  Future<AuthResult> resetPassword({required String code}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        print('verifyEmail full response: ${response.body}');
        final data = jsonDecode(response.body);
        return AuthResult(
          success: true,
          message: "Code verified successfully",
          token: data["token"],
        );
      }
      if (response.statusCode == 400) {
        return AuthResult(success: false, message: "Invalid or expired code");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('ResetPassword Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Reset Password: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  //-------------------------
  Future<AuthResult> updatePasswordWithToken({
    required String password,
    required String resetToken,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/auth/update-password-with-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'password': password, 'reset_token': resetToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          await prefs.setString('access_token', data['token']);
        }
        return AuthResult(
          success: true,
          message: "Password updated successfully",
        );
      }
      if (response.statusCode == 400) {
        return AuthResult(success: false, message: "Invalid or expired token");
      }
      if (response.statusCode == 401) {
        return AuthResult(success: false, message: "Unauthorized");
      }
      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      print('UpdatePasswordWithToken Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Update Password: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }

  //-------------------------
  Future<AuthResult> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');
      final String? deviceId = prefs.getString('device_id');
      // 1. Check if the user is actually logged in
      if (accessToken == null) {
        return AuthResult(
          success: false,
          message: "Session expired, please sign in again.",
        );
      }

      // 2. Make the request to the backend
      // Note: Verify with your backend developer if this should be a PATCH or POST request,
      // and confirm the exact endpoint URL ('/auth/change-password').
      final response = await http.patch(
        Uri.parse('$_baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          if (deviceId != null) 'Cookie': 'device_id=$deviceId',
          //'x-device-id': deviceId!,
        },
        body: jsonEncode({
          'password': newPassword,
          'current_password': currentPassword,
        }),
      );

      // 3. Handle the responses
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          print('---------------------------- $data');
          if (data['token'] != null) {
            await prefs.setString('access_token', data['token']);
          }
        }

        final String? newAccessToken = response.headers['access_token'];
        final String? newRefreshToken = response.headers['refresh_token'];
        
        if (newAccessToken != null) {
          await prefs.setString('access_token', newAccessToken);
        }
        if (newRefreshToken != null) {
          await prefs.setString('refresh_token', newRefreshToken);
          print('New refresh token saved after password change: $newRefreshToken');
        }


        return AuthResult(
          success: true,
          message: "Password changed successfully",
        );
      }

      if (response.statusCode == 400 || response.statusCode == 401) {
        return AuthResult(
          success: false,
          message: "Incorrect current password",
        );
      }

      if (response.statusCode == 500) {
        return AuthResult(
          success: false,
          message: "Server error, try again later",
        );
      }

      // Catch-all for unexpected status codes
      print('ChangePassword Failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return AuthResult(success: false, message: "Something went wrong");
    } catch (e) {
      print('Network Error during Change Password: $e');
      return AuthResult(success: false, message: "No internet connection");
    }
  }
}
//---------------------------

class DeviceManager {
  static const String _deviceIdKey = 'device_id';

  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      // Generate a new unique device ID
      deviceId = const Uuid().v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  static Future<void> clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceIdKey);
  }
}
