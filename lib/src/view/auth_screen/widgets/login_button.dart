import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(
      {this.buttonColor,
      required this.buttonTitle,
      required this.icon,
      this.onPress});

  final Widget? icon;
  final String? buttonTitle;
  final Color? buttonColor;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          icon ?? const SizedBox(),
          Text(
            buttonTitle ?? "",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox()
        ],
      ),
      padding: EdgeInsets.zero,
      onPressed: onPress,
      color: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
