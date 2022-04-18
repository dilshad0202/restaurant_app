import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/models/category_dish_model.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class AddMinButton extends StatelessWidget {
  const AddMinButton({Key? key, required this.categoryDishes, this.index})
      : super(key: key);

  final CategoryDish categoryDishes;
  final int? index;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 375;
    double height = MediaQuery.of(context).size.width / 812;
    UserDataProvider userDataProvider = context.read<UserDataProvider>();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                if (categoryDishes.categoryCount == 1) {
                  bool updateSuccess =
                      await userDataProvider.removeDishFromCart(categoryDishes);
                  if (!updateSuccess) {
                    showSnackBar("Failed to remove dish from cart", context);
                  } else {
                    showSnackBar("Dish removed successfully", context);
                  }
                } else if (categoryDishes.categoryCount != 0) {
                  bool updateSuccess =
                      await userDataProvider.updateCart(categoryDishes, false);
                  if (!updateSuccess) {
                    showSnackBar("Failed to update dish count", context);
                  } 
                }
              },
              icon: const Text(
                "-",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )),
          Selector<UserDataProvider, int>(
              selector: (context, provider) => categoryDishes.categoryCount,
              builder: (context, value, child) {
                return Text(
                  value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                );
              }),
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                if (categoryDishes.categoryCount == 0) {
                  bool updateSuccess =
                      await userDataProvider.addDishToCart(categoryDishes);
                  if (!updateSuccess) {
                    showSnackBar("Failed to add dish to cart", context);
                  } else {
                    showSnackBar("Dish added to cart successfully", context);
                  }
                } else {
                  bool updateSuccess =
                      await userDataProvider.updateCart(categoryDishes, true);
                  if (!updateSuccess) {
                    showSnackBar("Failed to update dish count", context);
                  }
                }
              },
              icon: const Text(
                "+",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      width: width * 120,
      height: height * 90,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              spreadRadius: 0,
              color: Colors.black54,
              blurRadius: 5.0,
              offset: Offset(-1, 2))
        ],
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
      ),
    );
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 1), content: Text(message)));
  }
}
