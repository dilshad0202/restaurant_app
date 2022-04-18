import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/view/common_widgets/add_min_item.dart';
import 'package:zartek_test/src/view/dish_cart/widgets/dish_cart_item_widget.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/dishList_widget.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class DishCartScreen extends StatelessWidget {
  static String route = "dishCartScreen";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width / 812;
    UserDataProvider userDataProvider = context.read<UserDataProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Summary",
          style:
              TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey[600],
            )),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 59, 2),
                          borderRadius: BorderRadius.circular(7)),
                      height: height * 120,
                      child: Center(
                          child: Selector<UserDataProvider, int>(
                        selector: (context, provider) =>
                            provider.totalItemsCount,
                        builder: (context, value, child) => Text(
                          "${userDataProvider.userCart.length.toString()} Dishes - $value items",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                    ),
                    Expanded(
                      child: Selector<UserDataProvider, int>(
                        selector: (context, provider) =>
                            provider.userCart.length,
                        builder: (context, provider, child) =>
                            ListView.separated(
                                itemBuilder: (context, int index) {
                                  return DishCartItem(
                                      categoryDish:
                                          userDataProvider.userCart[index]);
                                },
                                separatorBuilder: (context, int index) {
                                  return const Divider();
                                },
                                itemCount: userDataProvider.userCart.length),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 20, horizontal: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Selector<UserDataProvider, double>(
                                selector: (context, provider) =>
                                    provider.totalPrice,
                                builder: (context, value, child) => Text(
                                    "INR ${userDataProvider.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Colors.green)),
                              )
                            ]))
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, 03))
                    ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 8, right: 8, top: height * 200, bottom: height * 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  height: height * 120,
                  color: const Color.fromARGB(255, 2, 59, 2),
                  onPressed: () {
                    _openCustomDialog(context);
                  },
                  child: const Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openCustomDialog(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: SizedBox(
                  height: 150,
                  child: AlertDialog(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    title: Column(children: [
                      const CircleAvatar(
                        radius: 70,
                        foregroundColor: Color.fromARGB(255, 0, 197, 7),
                        child: Center(
                          child: Icon(
                            Icons.done_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Order Placed Successfully",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Ok")),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }
}
