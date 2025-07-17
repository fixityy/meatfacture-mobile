class LoyaltyCardsListDataModel {
  LoyaltyCardsListDataModel({
    required this.uuid,
    required this.number,
    required this.discountPercent,
    required this.loyaltyCardTypeUuid,
    required this.loyaltyCardTypeName,
    required this.clientUuid,
    required this.clientPhone,
    required this.createdAt,
  });

  String uuid;
  String number;
  int discountPercent;
  String loyaltyCardTypeUuid;
  String loyaltyCardTypeName;
  String clientUuid;
  String clientPhone;
  String createdAt;

  factory LoyaltyCardsListDataModel.fromJson(Map<String, dynamic> json) =>
      LoyaltyCardsListDataModel(
        uuid: json["uuid"],
        number: json["number"],
        discountPercent: json["discount_percent"],
        loyaltyCardTypeUuid: json["loyalty_card_type_uuid"],
        loyaltyCardTypeName: json["loyalty_card_type_name"],
        clientUuid: json["client_uuid"],
        clientPhone: json["client_phone"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "number": number,
        "discount_percent": discountPercent,
        "loyalty_card_type_uuid": loyaltyCardTypeUuid,
        "loyalty_card_type_name": loyaltyCardTypeName,
        "client_uuid": clientUuid,
        "client_phone": clientPhone,
        "created_at": createdAt,
      };
}
