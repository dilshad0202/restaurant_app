import 'package:zartek_test/src/models/category_dish_model.dart';

class TableMenuList {
    TableMenuList({
        this.menuCategory,
        this.menuCategoryId,
        this.menuCategoryImage,
        this.nexturl,
        this.categoryDishes,
    });

    String? menuCategory;
    String? menuCategoryId;
    String? menuCategoryImage;
    String? nexturl;
    List<CategoryDish>? categoryDishes;

    factory TableMenuList.fromJson(Map<String, dynamic> json) => TableMenuList(
        menuCategory: json["menu_category"],
        menuCategoryId: json["menu_category_id"],
        menuCategoryImage: json["menu_category_image"],
        nexturl: json["nexturl"],
        categoryDishes: List<CategoryDish>.from(json["category_dishes"].map((x) => CategoryDish.fromJson(x))),
    );

}