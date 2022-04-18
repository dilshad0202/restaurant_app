import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/models/category_dish_model.dart';
import 'package:zartek_test/src/view/common_widgets/add_min_item.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

class DishListWidget extends StatefulWidget {
  const DishListWidget({Key? key, this.categoryDishes, this.index})
      : super(key: key);

  final List<CategoryDish>? categoryDishes;
  final int? index;

  @override
  State<DishListWidget> createState() => _DishListWidgetState();
}

class _DishListWidgetState extends State<DishListWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 375;
    double height = MediaQuery.of(context).size.width / 812;
    return ListView.separated(
        itemBuilder: (context, int index) {
          return Padding(
            padding: EdgeInsets.all(height * 25),
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${widget.categoryDishes![index].dishCalories!.toStringAsFixed(0)} calories",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                  SizedBox(
                    width: width * 5,
                  ),
                  Container(
                    height: height * 170,
                    width: width * 75,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: Image.network(
                      widget.categoryDishes![index].dishImage ?? "",
                      fit: BoxFit.contain,
                      loadingBuilder: (context, obj, stackTrace) {
                        return const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 1,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, obj, stackTrace) {
                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.error),
                                Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Text(
                                    "Failed to load image",
                                    style: TextStyle(fontSize: 5),
                                  ),
                                )
                              ]),
                        );
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.categoryDishes![index].dishType != null)
                    Container(
                      margin: EdgeInsets.only(top: height * 8),
                      padding: const EdgeInsets.all(1),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            widget.categoryDishes![index].dishType == 2
                                ? Colors.green
                                : Colors.red,
                      ),
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: widget.categoryDishes![index].dishType == 2
                            ? Colors.green
                            : Colors.red,
                      )),
                    ),
                  SizedBox(
                    width: width * 5,
                  ),
                  SizedBox(
                    width: width * 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoryDishes![index].dishName ?? "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 8,
                        ),
                        Text(
                          "INR ${widget.categoryDishes![index].dishPrice.toString()}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: height * 25,
                        ),
                        Text(
                          widget.categoryDishes![index].dishDescription ?? "",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: height * 15,
                        ),
                        AddMinButton(categoryDishes: widget.categoryDishes![index]),
                        SizedBox(
                          height: height * 15,
                        ),
                        if (widget.categoryDishes![index].addonCat != null &&
                            widget.categoryDishes![index].addonCat!.isNotEmpty)
                          const Text(
                            "Customiztion available",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            ]),
          );
        },
        separatorBuilder: (context, int int) {
          return const Divider(
            height: 0,
            thickness: 1,
          );
        },
        itemCount: widget.categoryDishes!.length);
  }


}

