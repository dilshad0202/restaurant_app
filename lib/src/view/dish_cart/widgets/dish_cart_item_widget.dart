import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/models/category_dish_model.dart';
import 'package:zartek_test/src/view/common_widgets/add_min_item.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class DishCartItem extends StatelessWidget {
  DishCartItem({required this.categoryDish});

  final CategoryDish categoryDish;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 812;
    double width = MediaQuery.of(context).size.width / 375;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (categoryDish.dishType != null)
            Container(
              margin: EdgeInsets.only(top: height * 8),
              padding: const EdgeInsets.all(1),
              child: CircleAvatar(
                radius: 15,
                backgroundColor:
                    categoryDish.dishType == 2 ? Colors.green : Colors.red,
              ),
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  border: Border.all(
                color: categoryDish.dishType == 2 ? Colors.green : Colors.red,
              )),
            ),
          SizedBox(
            width: width * 3,
          ),
          SizedBox(
            width: width*100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryDish.dishName ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: height * 8,
                ),
                Text(
                  "INR ${categoryDish.dishPrice.toString()}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "${categoryDish.dishCalories.toString()} calories",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 6),
              child: AddMinButton(categoryDishes: categoryDish)),
          Expanded(
            child: Selector<UserDataProvider, int>(
                selector: (_, provider) => provider.totalItemsCount,
                builder: (context, value, child) => Text(
                    "INR ${(categoryDish.dishPrice! * categoryDish.categoryCount).toStringAsFixed(2)}")),
          )
        ],
      ),
    );
  }
}
