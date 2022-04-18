import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/view_model/auth_provider.dart';

class LoginError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 812;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Something Went Wrong"),
          SizedBox(
            height: height * 10,
          ),
          TextButton(
              onPressed: () {
             context.read<AuthProvider>().onRetryPress();
              },
              child: const Text(
                "Retry",
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }
}
