import 'package:smart/models/Assortments_image_model.dart';
import 'package:smart/models/loyalty_card_type.dart';

class FindNearbyStoreModel {
  FindNearbyStoreModel({
    required this.data,
  });

  List<FindNearbyStoreDataModel> data;

  factory FindNearbyStoreModel.fromJson(Map<String, dynamic> json) =>
      FindNearbyStoreModel(
        data: List<FindNearbyStoreDataModel>.from(
            json["data"].map((x) => FindNearbyStoreDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FindNearbyStoreDataModel {
  FindNearbyStoreDataModel({
    required this.uuid,
    required this.brandName,
    required this.organizationName,
    this.loyaltyCardTypes,
    required this.address,
    required this.workHoursFrom,
    required this.workHoursTill,
    required this.phone,
    required this.hasParking,
    required this.hasReadyMeals,
    required this.hasAtms,
    this.image,
    required this.distance,
    required this.deliveryPrice,
  });

  String uuid;
  String brandName;
  String organizationName;
  List<LoyaltyCardType>? loyaltyCardTypes;
  String address;
  String workHoursFrom;
  String workHoursTill;
  String phone;
  bool hasParking;
  bool hasReadyMeals;
  bool hasAtms;
  ImageModel? image;
  int distance;
  String deliveryPrice;

  factory FindNearbyStoreDataModel.fromJson(Map<String, dynamic> json) =>
      FindNearbyStoreDataModel(
        uuid: json["uuid"],
        brandName: json["brand_name"],
        organizationName: json["organization_name"],
        loyaltyCardTypes: json["loyalty_card_types"] == null
            ? null
            : List<LoyaltyCardType>.from(json["loyalty_card_types"]
                .map((x) => LoyaltyCardType.fromJson(x))),
        address: json["address"],
        workHoursFrom: json["work_hours_from"],
        workHoursTill: json["work_hours_till"],
        phone: json["phone"],
        hasParking: json["has_parking"],
        hasReadyMeals: json["has_ready_meals"],
        hasAtms: json["has_atms"],
        image:
            json["image"] == null ? null : ImageModel.fromJson(json["image"]),
        distance: json["distance"],
        deliveryPrice:
            json["delivery_price"] != null ? json["delivery_price"] : '',
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "brand_name": brandName,
        "organization_name": organizationName,
        "loyalty_card_types": loyaltyCardTypes == null
            ? null
            : List<dynamic>.from(loyaltyCardTypes!.map((x) => x.toJson())),
        "address": address,
        "work_hours_from": workHoursFrom,
        "work_hours_till": workHoursTill,
        "phone": phone,
        "has_parking": hasParking,
        "has_ready_meals": hasReadyMeals,
        "has_atms": hasAtms,
        "image": image == null ? null : image!.toJson(),
        "distance": distance,
        "delivery_price": deliveryPrice,
      };
}
