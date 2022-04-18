import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/models/user_model.dart';
import 'package:zartek_test/src/view_model/auth_provider.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class UserProfileDrawer extends StatelessWidget {
  const UserProfileDrawer({Key? key,this.user}) : super(key: key);

  final UserModel? user;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 812;
    return Drawer(
        child: Column(
      children: [
        SizedBox(
          height: height * 15,
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 34, 140, 37),
                Color.fromARGB(255, 116, 179, 9)
              ]),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          height: height * 250,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  foregroundImage: NetworkImage(
                      "https://w0.peakpx.com/wallpaper/163/281/HD-wallpaper-beatiful-view-aurora-landscape-nature-night-northern-lights-stars-thumbnail.jpg"),
                  radius: 50,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: height*10,),
                Text(
                  "${user?.email ?? user?.phoneNumber ?? ""} ",
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: height * 10,
                ),
                if(user!= null && user?.userID != null)
                Text("USER ID : ${user!.userID}",
                    style: const TextStyle(color: Colors.white)),
              ]),
        ),
        SizedBox(
          height: height * 10,
        ),
        TextButton.icon(
            onPressed: () async {
              bool? conFirmation = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                          title: const Text(
                            "Are you sure you want to log out?",
                            style: TextStyle(fontSize: 14),
                          )));
              conFirmation = conFirmation ?? false;
              if (conFirmation) {
                context.read<AuthProvider>().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.grey,
            ),
            label: const Text(
              "Logout",
              style: TextStyle(color: Colors.grey),
            ))
      ],
    ));
  }
}
