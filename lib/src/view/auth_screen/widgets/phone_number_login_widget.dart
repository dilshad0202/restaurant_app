import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/utility/status_enum.dart';
import 'package:zartek_test/src/view/auth_screen/widgets/login_button.dart';
import 'package:zartek_test/src/view_model/auth_provider.dart';

class PhoneNumberLoginWidget extends StatefulWidget {
  @override
  State<PhoneNumberLoginWidget> createState() => _PhoneNumberLoginWidgetState();
}

class _PhoneNumberLoginWidgetState extends State<PhoneNumberLoginWidget> {
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _oTPController = TextEditingController();

  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKeyOTP = GlobalKey<FormState>();

  String? verificationId;

  @override
  Widget build(BuildContext context) {
    AuthProvider _authProvider = context.read<AuthProvider>();
    return Selector<AuthProvider, PhoneNumberLoginStatus>(
      selector: (_, selector) => selector.phoneLogStatus,
      builder: ((context, value, child) {
        if (value == PhoneNumberLoginStatus.inputPhone ||
            value == PhoneNumberLoginStatus.loading) {
          return Form(
            key: _formKeyPhone,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty || value.length != 10) {
                  return "Please Enter Your Number";
                } else if (value.contains(RegExp("r[A-Z,a-z]"))) {
                  return "Please Enter a Valid Number";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                  suffixIcon: Selector<AuthProvider, PhoneNumberLoginStatus>(
                      selector: (context, provider) => provider.phoneLogStatus,
                      builder: (context, value, child) {
                        return value == PhoneNumberLoginStatus.loading
                            ? const Padding(
                                padding: EdgeInsets.all(5),
                                child: CircularProgressIndicator(
                                  strokeWidth: 0,
                                  color: Colors.grey,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  if (_formKeyPhone.currentState!.validate()) {
                                    _authProvider.phoneAuthentication(
                                        "+91${_phoneController.text}", context);
                                  }
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.grey,
                                ));
                      }),
                  prefixText: "+91",
                  counterText: "",
                  errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red[200]!)),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.grey[200]!)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Phone Number"),
              controller: _phoneController,
            ),
          );
        } else if (value == PhoneNumberLoginStatus.inputOTP ||
            value == PhoneNumberLoginStatus.error) {
          return Column(children: [
            Form(
              key: _formKeyOTP,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty || value.length != 6) {
                    return "Please Enter Valid OTP";
                  } else if (value.length != 6) {
                    return "Please Enter 6 Digit OTP";
                  } else if (value.contains(RegExp("r[A-Z,a-z]"))) {
                    return "Please Enter a Valid OTP";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                    prefix: const SizedBox(
                      width: 10,
                    ),
                    suffixIcon: TextButton(
                        onPressed: () {
                          if (_formKeyOTP.currentState!.validate()) {
                            _authProvider.verifyOTP(
                                _oTPController.text, context);
                          }
                        },
                        child: const Icon(
                          Icons.login_rounded,
                          color: Colors.grey,
                        )),
                    counterText: "",
                    errorBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.red[200]!)),
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "Enter OTP Here"),
                controller: _oTPController,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Selector<AuthProvider, PhoneNumberLoginStatus>(
                  selector: (context, provier) => provier.phoneLogStatus,
                  builder: (context, value, child) {
                    if (value == PhoneNumberLoginStatus.error) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _oTPController.clear();
                                  _phoneController.clear();
                                  _authProvider.changePhoneInputStatus(
                                      PhoneNumberLoginStatus.idle);
                                },
                                child: const Text("Try Another Method")),
                            TextButton(
                                onPressed: () {
                                  _authProvider.phoneAuthentication(
                                      "+91${_phoneController.text}", context);
                                },
                                child: const Text("Rety")),
                          ]);
                    } else {
                      return Selector<AuthProvider, int>(
                          selector: (context, provider) => provider.counter,
                          builder: (context, value, child) => Text(
                              "Retry in ${_authProvider.counter.toString()}"));
                    }
                  }),
            )
          ]);
        }
        return LoginButton(
          icon: const Icon(
            Icons.phone_rounded,
            color: Colors.white,
          ),
          buttonTitle: "Phone",
          buttonColor: Colors.green,
          onPress: () {
            _authProvider
                .changePhoneInputStatus(PhoneNumberLoginStatus.inputPhone);
          },
        );
      }),
    );
  }
}
