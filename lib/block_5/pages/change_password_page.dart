import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_0/pages/forget_password/gmail_enter_for_forget_password.dart';
// import 'package:mediora/block_0/pages/forget_password/rest_passwrod.dart';
import 'package:mediora/block_0/pages/forget_password/validation_gmail_for_forget_password.dart';
// import 'package:mediora/block_0/pages/sign_up/password.dart';
import 'package:mediora/block_1/pages%20/homePage.dart';
import 'package:mediora/block_5/pages/delete_account_page.dart';
import 'package:mediora/tools.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: TextStyle(fontSize: 20)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.verticalSpace,
                // Text of chnaging password
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "To keep your account secure, please enter your current password before setting a new one.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: "LineSeedJP",
                      color: Colors.grey,
                    ),
                  ),
                ),
                40.verticalSpace,
                //Title of current password
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Current Password",
                      style: TextStyle(
                        fontFamily: 'LineSeedJP',
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                //Field of current password
                CurrentPasswordField(controller: _currentPasswordController),
                Align(
                  alignment: AlignmentGeometry.bottomLeft,
                  child: LinkToForgetPassword(
                    text: 'Forget Passowrd?',
                    widget: ForgetpasswordGmail(isFromSettings: true,),
                  ),
                ),
                5.verticalSpace,
                //Title of New password
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password",
                      style: TextStyle(
                        fontFamily: 'LineSeedJP',
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                CreatePassword(controller: _newPasswordController),
                5.verticalSpace,
                //Title of confirm password
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontFamily: 'LineSeedJP',
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                //ConfirmPasswordField(controller: _confirmPasswordController),
                70.verticalSpace,
                ContinueButtonCustom(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContinueButtonCustom extends StatelessWidget {
  const ContinueButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          CustomSnackBar.show(
            context,
            message: 'Password Updated',
            seconds: 3,
            icon: Icons.check_circle_outline,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2463EB),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 10.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Continue",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: "LineSeedJP",
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LinkToForgetPassword extends StatelessWidget {
  final String text;
  final Widget widget;
  const LinkToForgetPassword({super.key,  required this.text, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "LineSeedJP",
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          decoration: TextDecoration.underline,
          decorationColor: Colors.grey,
          decorationThickness: 1.5,
        ),
      ),
    );
  }
}
