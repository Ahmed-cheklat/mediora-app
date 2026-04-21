import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/policies.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/sign_in.dart';
import 'package:mediora/block_1/pages%20/homePage.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            20.verticalSpace,

            // Centered content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    48.verticalSpace,
                    _Mediora_Icon(),
                    10.verticalSpace,
                    Text(
                      "Mediora",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30.sp,
                        fontFamily: "LineSeedJP",
                      ),
                    ),
                    200.verticalSpace,

                    Start_Button(),
                  ],
                ),
              ),
            ),
            // Responsive spacing
            SizedBox(height: 80.h), // 10% of screen height
            // Policy links
            PolicyLink(text: 'Cookies and Privacy policy', widget: Policies()),

            20.verticalSpace, // Bottom padding
          ],
        ),
      ),
    );
  }
}

//Icon of Mediora
// ignore: camel_case_types
class _Mediora_Icon extends StatelessWidget {
  const _Mediora_Icon();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/icon.png",
      height: 200.r,
      width: 200.r,
      fit: BoxFit.contain,
    );
  }
}

// Start button design
// ignore: camel_case_types
class Start_Button extends StatelessWidget {
  const Start_Button({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 216.w, // 60% of screen width
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2463EB),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30).r,
          ),
          elevation: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            30.verticalSpace,
            Text(
              'Start',
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: "LINESeedJP",
                fontWeight: FontWeight.w700,
              ),
            ),
            15.horizontalSpace,
            Icon(Icons.arrow_forward_rounded, size: 30.sp),
          ],
        ),
      ),
    );
  }
}

// policy link and terms and cookies
class PolicyLink extends StatelessWidget {
  final String text;
  final Widget widget;
  const PolicyLink({super.key, required this.text, required this.widget});

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
