import 'package:smart/models/Assortments_image_model.dart';

class ImInShopModel {
  ImInShopModel({
    required this.data,
  });

  Data data;

  factory ImInShopModel.fromJson(Map<String, dynamic> json) => ImInShopModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.uuid,
    required this.storeUuid,
    required this.storeName,
    this.discountPercent,
    required this.products,
  });

  String uuid;
  String storeUuid;
  String storeName;
  double? discountPercent;
  List<Product> products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        uuid: json["uuid"],
        storeUuid: json["store_uuid"],
        storeName: json["store_name"],
        discountPercent: json["discount_percent"] == null
            ? null
            : double.parse(json["discount_percent"].toString()),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "store_uuid": storeUuid,
        "store_name": storeName,
        "discount_percent": discountPercent,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.uuid,
    required this.name,
    this.rating,
    required this.images,
    required this.price,
    required this.priceWithDiscount,
    required this.discountType,
    required this.discountTypeColor,
    required this.discountTypeName,
    this.quantity,
    required this.assortmentUnitId,
    required this.quantityInClientCart,
    required this.totalBonus,
    required this.weight,
  });

  String uuid;

  String discountTypeName;
  String discountType;
  String discountTypeColor;
  String weight;
  String name;
  RatingForImInShopModel? rating;
  List<ImageModel> images;
  double price;
  double priceWithDiscount;
  double? quantity;
  double quantityInClientCart;
  String assortmentUnitId;
  int totalBonus;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        uuid: json["uuid"],
        weight: json["weight"],
        totalBonus: json["total_bonus"],
        quantityInClientCart: json["quantity_in_client_cart"] == null
            ? null
            : json["quantity_in_client_cart"].toDouble(),
        assortmentUnitId: json["assortment_unit_id"],
        name: json["name"],
        discountTypeColor: json["discount_type_color"],
        discountType: json["discount_type"],
        discountTypeName: json["discount_type_name"],
        rating: json["rating"] == null
            ? null
            : RatingForImInShopModel.fromJson(json["rating"]),
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        price: json["price"].toDouble(),
        priceWithDiscount: json["price_with_discount"].toDouble(),
        quantity: json["quantity"] == null
            ? null
            : double.parse(json["quantity"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "weight": weight,
        "total_bonus": totalBonus,
        "quantity_in_client_cart": quantityInClientCart,
        "assortment_unit_id": assortmentUnitId,
        "discount_type_color": discountTypeColor,
        "discount-type": discountType,
        "discount-type-name": discountTypeName,
        "name": name,
        "rating": rating == null ? null : rating!.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "price": price,
        "price_with_discount": priceWithDiscount,
        "quantity": quantity,
      };
}

class RatingForImInShopModel {
  RatingForImInShopModel({
    required this.uuid,
    required this.referenceType,
    required this.referenceId,
    required this.ratingTypeId,
    this.value,
    this.additionalAttributes,
    required this.createdAt,
    required this.updatedAt,
  });

  String uuid;
  String referenceType;
  String referenceId;
  String ratingTypeId;
  dynamic value;
  dynamic additionalAttributes;
  String createdAt;
  String updatedAt;

  factory RatingForImInShopModel.fromJson(Map<String, dynamic> json) =>
      RatingForImInShopModel(
        uuid: json["uuid"],
        referenceType: json["reference_type"],
        referenceId: json["reference_id"],
        ratingTypeId: json["rating_type_id"],
        value: json["value"],
        // != null
        //     ? double.parse(json["value"].toString())
        //     : null,
        additionalAttributes: json["additional_attributes"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "reference_type": referenceType,
        "reference_id": referenceId,
        "rating_type_id": ratingTypeId,
        "value": value,
        "additional_attributes": additionalAttributes,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
