import 'package:smart/models/shopping_lists_assortment_model.dart';

class ShoppingListDataModel {
  ShoppingListDataModel({
    required this.uuid,
    required this.name,
    required this.assortments,
    required this.addingcheck,
  });

  String uuid;
  String name;
  List<ShoppingListsAssortmentModel> assortments;
  bool addingcheck;
  factory ShoppingListDataModel.fromJson(Map<String, dynamic> json) =>
      ShoppingListDataModel(
        addingcheck: false,
        uuid: json["uuid"],
        name: json["name"],
        assortments: List<ShoppingListsAssortmentModel>.from(json["assortments"]
            .map((x) => ShoppingListsAssortmentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "assortments": List<dynamic>.from(assortments.map((x) => x.toJson())),
      };
}
