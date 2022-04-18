import 'package:flutter/material.dart';
import 'package:zartek_test/src/utility/status_enum.dart';
import 'package:zartek_test/src/view/auth_screen/widgets/phone_number_login_widget.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/drawer_widget.dart';
import 'package:zartek_test/src/view/auth_screen/widgets/error_widget.dart';
import 'package:zartek_test/src/view/auth_screen/widgets/login_button.dart';
import 'package:zartek_test/src/view/user_home_screen/user_home_screen.dart';
import 'package:zartek_test/src/view_model/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthMainScreen extends StatefulWidget {
  @override
  State<AuthMainScreen> createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen> {
  @override
  void initState() {
    AuthProvider _authProvider = context.read<AuthProvider>();
    _authProvider.loginStatus = LoginStatus.idle;
    _authProvider.phoneLogStatus = PhoneNumberLoginStatus.idle;
    var logedStatus = context.read<AuthProvider>().checkLogedIn();
    _authProvider.loginStatus =
        logedStatus ? LoginStatus.loading : LoginStatus.idle;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (logedStatus) {
        Navigator.pushReplacementNamed(context, UserHomeScreen.route);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 812;
    double width = MediaQuery.of(context).size.height / 375;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<AuthProvider>(builder: (context, provider, child) {
            if (provider.loginStatus == LoginStatus.loading) {
              return Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/auth/firebase_logo.png",
                    height: height * 100,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LoginButton(
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              "assets/images/auth/google_logo.png",
                              height: height * 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                          buttonTitle: "Google",
                          buttonColor: Colors.blue,
                          onPress: () {
                            if (provider.phoneLogStatus ==
                                PhoneNumberLoginStatus.idle) {
                              provider.signInWithGoogle(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "You Already choosen Phone Login ! If it Failed You can Try Google Signin")));
                            }
                          }),
                      SizedBox(
                        height: height * 10,
                      ),
                      PhoneNumberLoginWidget()
                    ],
                  ),
                ],
              ),
            );
          })),
    );
  }
}
