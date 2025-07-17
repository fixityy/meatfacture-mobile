import 'package:smart/models/meta_model.dart';

class DiverseFoodPresentDiscountModel {
  DiverseFoodPresentDiscountModel({
    required this.data,
    required this.meta,
  });

  List<DiverseFoodPresentDiscountDataModel> data;
  MetaModel meta;

  factory DiverseFoodPresentDiscountModel.fromJson(Map<String, dynamic> json) =>
      DiverseFoodPresentDiscountModel(
        data: List<DiverseFoodPresentDiscountDataModel>.from(json["data"]
            .map((x) => DiverseFoodPresentDiscountDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class DiverseFoodPresentDiscountDataModel {
  DiverseFoodPresentDiscountDataModel({
    required this.uuid,
    required this.clientUuid,
    required this.discountPercent,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String uuid;
  String clientUuid;
  int discountPercent;
  String startAt;
  String endAt;
  String createdAt;
  String updatedAt;

  factory DiverseFoodPresentDiscountDataModel.fromJson(
          Map<String, dynamic> json) =>
      DiverseFoodPresentDiscountDataModel(
        uuid: json["uuid"],
        clientUuid: json["client_uuid"],
        discountPercent: json["discount_percent"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "client_uuid": clientUuid,
        "discount_percent": discountPercent,
        "start_at": startAt,
        "end_at": endAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
