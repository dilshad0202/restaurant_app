import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/models/category_dish_model.dart';
import 'package:zartek_test/src/models/user_model.dart';
import 'package:zartek_test/src/utility/collection_name.dart';
import 'package:zartek_test/src/utility/status_enum.dart';
import 'package:zartek_test/src/view_model/restaurant_provider.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ProviderStatus fetchUserDataStatus = ProviderStatus.idel;

  List<CategoryDish> _userCart = [];
  int totalItemsCount = 0;
  double totalPrice = 0;

  List<CategoryDish> get userCart => _userCart;
  FirebaseAuth get auth => _auth;

  UserModel? _user;

  UserModel? get user => _user;

  // get user Details

  Future<void> getUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection(Collections.userCollection)
          .doc(_auth.currentUser!.uid)
          .get();
      if (snapshot.exists) {
        _user = UserModel.fromMap(snapshot.data()!);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("$e");
    }
  }

  /// to add new product to cart
  Future<bool> addDishToCart(
    CategoryDish dish,
  ) async {
    bool success = true;
    try {
      userCart.add(dish);
      dish.categoryCount = 1;
      await firestore
          .collection(Collections.userCollection)
          .doc(_auth.currentUser!.uid)
          .collection(Collections.usersCart)
          .doc(dish.dishId)
          .set({"dishId": dish.dishId, "dishName": dish.dishName, "count": 1});
      totalItemsandPrice();
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to add Product to Cart $e");
      success = false;
    }
    return success;
  }

  // to Reduce read and write count we use update Cart method
  Future<bool> updateCart(CategoryDish dish, bool increment) async {
    bool success = true;
    try {
      if (increment) {
        dish.categoryCount++;
      } else {
        dish.categoryCount--;
      }
      await firestore
          .collection(Collections.userCollection)
          .doc(_auth.currentUser!.uid)
          .collection(Collections.usersCart)
          .doc(dish.dishId)
          .update({"count": dish.categoryCount});
      totalItemsandPrice();
      notifyListeners();
    } catch (e) {
      success = false;
      debugPrint("Failed to add Product to Cart $e");
    }
    return success;
  }

  /// to remove completely from database
  Future<bool> removeDishFromCart(CategoryDish dish) async {
    bool deleteSucess = true;
    try {
      _userCart.remove(dish);
      dish.categoryCount = 0;

      await firestore
          .collection(Collections.userCollection)
          .doc(_auth.currentUser!.uid)
          .collection(Collections.usersCart)
          .doc(dish.dishId)
          .delete();
      totalItemsandPrice();
      notifyListeners();
    } catch (e) {
      deleteSucess = false;
      debugPrint("Removing From Cart Failes $e");
    }
    return deleteSucess;
  }

  Future<void> getCartData(BuildContext context) async {
    fetchUserDataStatus = ProviderStatus.laoding;
    notifyListeners();
    _userCart.clear();
    try {
      QuerySnapshot snapshot = await firestore
          .collection(Collections.userCollection)
          .doc(_auth.currentUser!.uid)
          .collection(Collections.usersCart)
          .get();

      List<String> values = [];
      snapshot.docs.forEach((element) {
        for (int i = 0; i < element["count"]; i++) {
          values.add(element["dishId"]);
        }
      });

      values.forEach((dishId) {
        context
            .read<RestaurantDataProvider>()
            .tableMenuList!
            .forEach((tableMEnu) {
          tableMEnu.categoryDishes!.forEach((categoryDish) {
            if (dishId == categoryDish.dishId) {
              _userCart.add(categoryDish);
              categoryDish.categoryCount++;
            }
          });
        });
      });
      List<CategoryDish> dummyCart = [
        ...{..._userCart}
      ];
      _userCart = dummyCart;
      totalItemsandPrice();
      fetchUserDataStatus = ProviderStatus.loaded;
      notifyListeners();
    } catch (e) {
      fetchUserDataStatus = ProviderStatus.error;
      notifyListeners();
      debugPrint("$e");
    }
  }

  void totalItemsandPrice() {
    totalItemsCount = 0;
    totalPrice = 0;
    _userCart.forEach((element) {
      totalPrice =
          totalPrice + (element.categoryCount * element.dishPrice!.toDouble());
      totalItemsCount = totalItemsCount + element.categoryCount;
    });
  }
}
