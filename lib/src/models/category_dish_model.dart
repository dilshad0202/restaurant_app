import 'package:zartek_test/src/models/addoncat_model.dart';

class CategoryDish {
    CategoryDish({
        this.dishId,
        this.dishName,
        this.dishPrice,
        this.dishImage,
        this.dishCalories,
        this.dishDescription,
        this.dishAvailability,
        required this.categoryCount,
        this.dishType,
        this.nexturl,
        this.addonCat,
    });

    String? dishId;
    String? dishName;
    double? dishPrice;
    String? dishImage;
    double? dishCalories;
    String? dishDescription;
    bool? dishAvailability;
    int categoryCount ;
    int? dishType;
    String? nexturl;
    List<AddonCat>? addonCat;


    factory CategoryDish.fromJson(Map<String, dynamic> json) => CategoryDish(
        dishId: json["dish_id"],
        dishName: json["dish_name"],
        dishPrice: json["dish_price"].toDouble(),
        dishImage: json["dish_image"],
        dishCalories: json["dish_calories"],
        dishDescription: json["dish_description"],
        categoryCount: 0,
        dishAvailability: json["dish_Availability"],
        dishType: json["dish_Type"],
        nexturl: json["nexturl"],
        addonCat: json["addonCat"] == null ? null : List<AddonCat>.from(json["addonCat"].map((x) => AddonCat.fromJson(x))),
    );
    
     Map<String, dynamic> toJson() => {
        "dish_id": dishId,
        "dish_name": dishName,
        "dish_price": dishPrice,
        "dish_image": dishImage,
        "dish_calories": dishCalories,
        "dish_description": dishDescription,
        "dish_Type": dishType,
    };

}
