import 'package:zartek_test/src/models/table_menu_model.dart';

class RestaurantModel {
    RestaurantModel({
        this.restaurantId,
        this.restaurantName,
        this.restaurantImage,
        this.tableId,
        this.tableName,
        this.branchName,
        this.nexturl,
        this.tableMenuList,
    });

    String? restaurantId;
    String? restaurantName;
    String? restaurantImage;
    String? tableId;
    String? tableName;
    String? branchName;
    String? nexturl;
    List<TableMenuList>? tableMenuList;


    factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
        restaurantId: json["restaurant_id"],
        restaurantName: json["restaurant_name"],
        restaurantImage: json["restaurant_image"],
        tableId: json["table_id"],
        tableName: json["table_name"],
        branchName: json["branch_name"],
        nexturl: json["nexturl"],
        tableMenuList:List<TableMenuList>.from(json["table_menu_list"].map((x) => TableMenuList.fromJson(x))),

    );
}