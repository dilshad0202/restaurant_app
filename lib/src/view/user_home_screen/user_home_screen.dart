import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/models/category_dish_model.dart';
import 'package:zartek_test/src/utility/status_enum.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/drawer_widget.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/dishList_widget.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/user_home_loaded.dart';
import 'package:zartek_test/src/view_model/auth_provider.dart';
import 'package:zartek_test/src/view_model/restaurant_provider.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class UserHomeScreen extends StatefulWidget {
  static String route = "userHomeRoute";

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      context.read<UserDataProvider>().getUserData();
      await context.read<RestaurantDataProvider>().getDishDatas().then((value) {
        context.read<UserDataProvider>().getCartData(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Consumer<RestaurantDataProvider>(
          builder: (context, provider, child) {
        if (provider.dataFetchStatus == ProviderStatus.error) {
          return const Center(
            child: Text("Something Went Wrong"),
          );
        } else if (provider.dataFetchStatus == ProviderStatus.loaded) {
          return UserHomeLoadedWidget();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
