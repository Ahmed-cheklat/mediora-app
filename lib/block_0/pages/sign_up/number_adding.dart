import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_1/pages%20/homePage.dart';
import 'package:mediora/tools.dart';

class NumberAdding extends StatelessWidget {
  const NumberAdding({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController numberController = TextEditingController(); 
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14.0.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  40.verticalSpace,
                  //Contact information title 
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contact Information ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "LineSeedJP",
                        fontSize: 32.sp,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  //description 
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Adding your phone number will help us to contact use easily",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "LineSeedJP",
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  40.verticalSpace,

                  // Phone number and his field 
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: const Color(0xFF2463EB)),
                        10.horizontalSpace,
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LineSeedJP',
                            fontSize: 16.sp,
                          ),
                        ),
                        8.verticalSpace,
                      ],
                    ),
                  ),
                  8.verticalSpace, 
                  NumberField(numberController: numberController),
                  150.verticalSpace, 
                  Button(
                    isFromSettings: false,
                    mywidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "LineSeedJP",
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  Icon(Icons.arrow_forward, size: 30.r),
                                ],
                              ),
                  function: () => Navigator.pushAndRemoveUntil(
                    context,MaterialPageRoute(builder: (context) => Homepage()),(route) => false,),
                  ),
                  20.verticalSpace, 
                  SkipLink(text: "Skip for now", widget: Homepage()),
                  30.verticalSpace, 
                  //description 
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "By continuing, you agree to receive SMS from us ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "LineSeedJP",
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




//number field
class NumberField extends StatelessWidget {
  final TextEditingController numberController;
  final String hintText;

  const NumberField({
    super.key,
    required this.numberController,
    this.hintText = "(+213)567 463 424",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: numberController,
      keyboardType: TextInputType.number,
      maxLength: 12,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Phone number is required";
        }
        if (value.length < 10) {
          return "Number must be at least 10 digits";
        }
        if (value.length > 12) {
          return "Number must not exceed 12 digits";
        }
        return null;
      },
      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: "LineSeedJP",
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Color(0xFF2463EB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

//Link to click, accept a text to write and a widget to go using push and remove until 
class SkipLink extends StatelessWidget {
  final String text;
  final Widget widget;
  const SkipLink({super.key, required this.text, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        (route) => false,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "LineSeedJP",
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          color: Color(0xFF2463EB),
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFF2463EB),
          decorationThickness: 1.5,
        ),
      ),
    );
  }
}