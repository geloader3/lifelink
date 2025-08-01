import 'package:emergencyrespo3712/Features/User/Screens/SignUp/signup_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:public_emergency_app/Common%20Widgets/constants.dart';
//import 'package:public_emergency_app/Features/Login/login_screen.dart';
//import 'package:public_emergency_app/Features/User/Screens/SignUp/signup_form_widget.dart';

import '../../../../Common Widgets/constants.dart';
import '../../../../Common Widgets/form_footer.dart';
import '../../../Login/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
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
            preferredSize: Size.fromHeight(Get.height * 0.1),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const SizedBox(width: 30,),
                  Center(
                    child: SizedBox.fromSize(
                      size: const Size(36, 36),
                      child: ClipOval(
                        child: Material(
                          color: Color(color),
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: () {  Get.to(() => const LoginScreen());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.arrow_back, color: Colors.white, size: 30,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 80,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: const AssetImage(
                              "assets/logos/emergencyAppLogo.png"),
                          height: Get.height * 0.08),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Sign Up",
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
                ],
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: const [
              SignUpFormWidget(),
              FooterWidget(Texts: "Already have Account ", Title: "Login")
            ],
          ),
        ),
      ),
    );
  }
}
