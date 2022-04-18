import 'package:flutter/cupertino.dart';
import 'package:zartek_test/src/models/restarant_model.dart';
import 'package:zartek_test/src/models/table_menu_model.dart';
import 'package:zartek_test/src/services/api_service.dart';
import 'package:zartek_test/src/utility/api.dart';
import 'package:zartek_test/src/utility/status_enum.dart';

class RestaurantDataProvider extends ChangeNotifier {
  ProviderStatus dataFetchStatus = ProviderStatus.idel;

  final  List<RestaurantModel> _restaurants = [];
   List<TableMenuList>? _tableMenuList = [];

  List<RestaurantModel> get restaurant => _restaurants;
  List<TableMenuList>? get tableMenuList => _tableMenuList;


  Future<void> getDishDatas() async {
    dataFetchStatus = ProviderStatus.laoding;
    _restaurants.clear();
    _tableMenuList!.clear();
    notifyListeners();
    try {
      var response = await ApiService.getApiData(url: ApiConstants.productsApi);
      response.data.forEach((data){
      restaurant.add(RestaurantModel.fromJson(data));
      });
      _tableMenuList = restaurant[0].tableMenuList;
      dataFetchStatus = ProviderStatus.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint("$e");
      dataFetchStatus = ProviderStatus.error;
      notifyListeners();
    }
  }
}
