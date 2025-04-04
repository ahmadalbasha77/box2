import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../../core/theme_app.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Text('Verification'.tr,
                  style: bold28.copyWith(color: AppColor.primaryColor)),
              const SizedBox(
                height: 30,
              ),
              Text('Enter the code sent to the email'.tr,
                  style: regular16.copyWith(color: const Color(0xff8599AA))),
              const SizedBox(
                height: 10,
              ),
              Text('ahmad1229@gmail.com',
                  style: regular16.copyWith(color: AppColor.primaryColor)),
              const SizedBox(
                height: 60,
              ),
              Form(
                child: SizedBox(
                  // height: 68,
                  child: Pinput(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter verification code'.tr;
                      } else if (value.length != 6) {
                        return 'enter full code'.tr;
                      }
                      return null;
                    },
                    // forceErrorState: true,
                    length: 6,
                    // controller: _controller.codeController,
                    // focusNode: _controller.focusNode,
                    defaultPinTheme: defaultPinTheme,
                    forceErrorState: true,

                    focusedPinTheme: defaultPinTheme.copyWith(
                      height: 68,
                      width: 64,
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColor.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "confirm",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text('Didn\'t receive code?'.tr,
                  style: regular14.copyWith(color: const Color(0xff8599AA))),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend'.tr,
                    style: regular16.copyWith(color: AppColor.primaryColor),
                  )),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
