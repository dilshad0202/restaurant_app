import 'package:zartek_test/src/models/category_dish_model.dart';

class AddonCat {
    AddonCat({
        this.addonCategory,
        this.addonCategoryId,
        this.addonSelection,
        this.nexturl,
        this.addons,
    });

    String? addonCategory;
    String? addonCategoryId;
    int? addonSelection;
    String? nexturl;
    List<CategoryDish>? addons;
 

    factory AddonCat.fromJson(Map<String, dynamic> json) => AddonCat(
        addonCategory: json["addon_category"],
        addonCategoryId: json["addon_category_id"],
        addonSelection: json["addon_selection"],
        nexturl: json["nexturl"],
        addons: List<CategoryDish>.from(json["addons"].map((x) => CategoryDish.fromJson(x))),
    );
}