/*
to get SHA keys fire command:
cd apk directory

$ keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
keytool 
.......
Certificate fingerprints:
          SHA1: ....
          SHA256: ....
........
*/

import 'package:firebase1/Widget/utils/all_management.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:firebase1/Widget/utils/utils.dart';
import 'package:firebase1/verify_screens/auth/Mobile/mobile_code_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Widget/support_widget/button.dart';
import '../../../Widget/support_widget/controllers.dart';
import '../../../Widget/support_widget/sized_box.dart';
import '../../../Widget/support_widget/text_feild.dart';

class MobileVerify extends StatefulWidget {
  const MobileVerify({super.key});

  @override
  State<MobileVerify> createState() => _MobileVerifyState();
}

class _MobileVerifyState extends State<MobileVerify> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  String countryCode = "+91";
  String mobile = "";
  @override
  void initState() {
    super.initState();
    mobileNumber.text = "$countryCode$mobile";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManger().appName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text("Login Using Mobile Number",
                    style: TextStyle(fontSize: 15)),
              ),
              addVerticalSpace(50),
              textField(
                username,
                "Username",
                true,
                false,
                1,
              ),
              addVerticalSpace(20),
              // textField(mobileNumber, "Mobile Number", true, false, 1, ),
              IntlPhoneField(
                controller: mobileNumber,
                initialCountryCode: 'IN',
                decoration: const InputDecoration(
                  focusColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: "Enter phone number",
                  labelText: "Phone number",
                ),
                onSubmitted: (p0) {
                  setState(() {
                    mobile = p0;
                  });
                },
                onCountryChanged: (value) {
                  setState(() {
                    countryCode = value as String;
                  });
                },
              ),

              addVerticalSpace(60),
              Button(
                  loading: loading,
                  title: "Verify",
                  onClick: () {
                    setState(() {
                      loading = true;
                    });

                    _auth.verifyPhoneNumber(
                        phoneNumber: mobileNumber.text.toString(),
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toastMessage(e.toString());
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VerifyMobileUser(
                              verificationId: verificationId,
                            );
                          }));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Utils().toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                  }),
              addVerticalSpace(30),
            ],
          ),
        ),
      ),
    );
  }
}
