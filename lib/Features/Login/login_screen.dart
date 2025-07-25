

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Common Widgets/form_footer.dart';
import '../../Common Widgets/constants.dart';
import 'login_form_widget.dart';

class LoginScreen extends StatelessWidget  {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Get the size in LoginHeaderWidget()
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(color),
        centerTitle: true,
        automaticallyImplyLeading: false,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),

        bottom: PreferredSize(
            preferredSize:  Size.fromHeight(Get.height * 0.1),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: const AssetImage("assets/logos/emergencyAppLogo.png"), height: Get.height * 0.08),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  const [
                        Text(
                          "Emergency Response System",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            )),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // (,
              LoginForm(),
              FooterWidget(Texts: "Don't have an account? ",Title: "Sign Up"),
            ],
          ),
        ),
      ),
    );
  }
}