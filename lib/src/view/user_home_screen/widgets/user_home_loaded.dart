import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/view/dish_cart/dish_cart_screen.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/drawer_widget.dart';
import 'package:zartek_test/src/view/user_home_screen/widgets/dishList_widget.dart';
import 'package:zartek_test/src/view_model/restaurant_provider.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class UserHomeLoadedWidget extends StatefulWidget {
  UserHomeLoadedWidget({Key? key}) : super(key: key);

  @override
  State<UserHomeLoadedWidget> createState() => _UserHomeLoadedWidgetState();
}

class _UserHomeLoadedWidgetState extends State<UserHomeLoadedWidget>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
        length: context.read<RestaurantDataProvider>().tableMenuList!.length,
        vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantDataProvider provider = context.read<RestaurantDataProvider>();
    UserDataProvider userDataProvider = context.read<UserDataProvider>();
    return Scaffold(
      key: _key,
      drawer:  UserProfileDrawer(user: userDataProvider.user,),
      appBar: AppBar(
        bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.pinkAccent[400],
            indicatorColor: Colors.pinkAccent[400],
            tabs: List.generate(provider.tableMenuList!.length, (index) {
              return Text(
                provider.tableMenuList![index].menuCategory ?? "",
                style: TextStyle(
                    color: Colors.pinkAccent[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              );
            })),
        elevation: 5,
        backgroundColor: Colors.white,
        actions: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, DishCartScreen.route);
              },
              icon: SizedBox(
                width: 40,
                child: Stack(
                  children: [
                    Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.grey[600],
                    ),
                    Positioned(
                      left: 15,
                      child: CircleAvatar(
                        radius: 8,
                        child: Center(
                            child: Selector<UserDataProvider, int>(
                          selector: (context, provider) =>
                              provider.userCart.length,
                          builder: (context, value, child) => Text(
                            userDataProvider.userCart.length.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        )),
                        backgroundColor: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
        leading: IconButton(
          iconSize: 28,
          onPressed: () => _key.currentState?.openDrawer(),
          icon: Icon(
            Icons.menu_rounded,
            color: Colors.grey[600],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        DishListWidget(
          categoryDishes: provider.tableMenuList![currentIndex].categoryDishes,
          index: _tabController.index,
        ),
        DishListWidget(
          categoryDishes: provider.tableMenuList![currentIndex].categoryDishes,
          index: _tabController.index,
        ),
        DishListWidget(
          categoryDishes: provider.tableMenuList![currentIndex].categoryDishes,
          index: _tabController.index,
        ),
        DishListWidget(
          categoryDishes: provider.tableMenuList![currentIndex].categoryDishes,
          index: _tabController.index,
        ),
        DishListWidget(
          categoryDishes: provider.tableMenuList![currentIndex].categoryDishes,
          index: _tabController.index,
        ),
        DishListWidget(
          categoryDishes: provider.tableMenuList![currentIndex].categoryDishes,
          index: _tabController.index,
        ),
      ]),
    );
  }
}
