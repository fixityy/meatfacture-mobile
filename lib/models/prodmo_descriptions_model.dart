import 'package:smart/models/meta_model.dart';

class PromoDescriptionsModel {
  PromoDescriptionsModel({
    required this.data,
    required this.meta,
  });

  List<PromoDescriptionsDataModel> data;
  MetaModel meta;

  factory PromoDescriptionsModel.fromJson(Map<String, dynamic> json) =>
      PromoDescriptionsModel(
        data: List<PromoDescriptionsDataModel>.from(
            json["data"].map((x) => PromoDescriptionsDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class PromoDescriptionsDataModel {
  PromoDescriptionsDataModel({
    required this.uuid,
    required this.name,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.logoFileUuid,
    required this.logoFilePath,
    required this.createdAt,
  });

  String uuid;
  String name;
  String title;
  String subtitle;
  String description;
  String logoFileUuid;
  String? logoFilePath;
  String createdAt;

  factory PromoDescriptionsDataModel.fromJson(Map<String, dynamic> json) =>
      PromoDescriptionsDataModel(
        uuid: json["uuid"],
        name: json["name"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        logoFileUuid: json["logo_file_uuid"],
        logoFilePath: json["logo_file_path"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "logo_file_uuid": logoFileUuid,
        "logo_file_path": logoFilePath,
        "created_at": createdAt,
      };
}
