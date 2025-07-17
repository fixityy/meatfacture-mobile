import 'package:smart/models/meta_model.dart';

class OrderListModel {
  OrderListModel({
    required this.data,
    required this.meta,
  });

  List<OrderListDataModel> data;
  MetaModel meta;

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        data: List<OrderListDataModel>.from(
            json["data"].map((x) => OrderListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class OrderListDataModel {
  OrderListDataModel({
    required this.uuid,
    required this.number,
    required this.storeUserUuid,
    required this.storeUserFullName,
    required this.storeUserAddress,
    required this.orderStatusId,
    required this.orderDeliveryTypeId,
    required this.orderPaymentTypeId,
    this.clientComment,
    required this.clientEmail,
    this.clientAddressData,
    required this.isPaid,
    required this.deliveryPrice,
    required this.totalDiscountForProducts,
    required this.totalPriceForProductsWithDiscount,
    required this.totalPrice,
    required this.totalWeight,
    this.totalQuantity,
    required this.plannedDeliveryDatetimeFrom,
    required this.plannedDeliveryDatetimeTo,
    required this.createdAt,
    required this.updatedAt,
    required this.bonusToCharge,
    required this.paidBonus,
    required this.totalBonus,
  });

  String uuid;
  int number;
  String storeUserUuid;
  String storeUserFullName;
  String storeUserAddress;
  String orderStatusId;
  String orderDeliveryTypeId;
  String orderPaymentTypeId;
  String? clientComment;
  String clientEmail;
  OrderListClientAddressData? clientAddressData;
  bool isPaid;
  double deliveryPrice;
  double totalDiscountForProducts;
  double totalPriceForProductsWithDiscount;
  double totalPrice;
  double totalWeight;
  double? totalQuantity;
  String plannedDeliveryDatetimeFrom;
  String plannedDeliveryDatetimeTo;
  String createdAt;
  String updatedAt;
  int totalBonus;
  int paidBonus;
  int bonusToCharge;

  factory OrderListDataModel.fromJson(Map<String, dynamic> json) =>
      OrderListDataModel(
        uuid: json["uuid"],
        number: json["number"],
        storeUserUuid: json["store_user_uuid"],
        storeUserFullName: json["store_user_full_name"],
        storeUserAddress: json["store_user_address"],
        orderStatusId: json["order_status_id"],
        orderDeliveryTypeId: json["order_delivery_type_id"],
        orderPaymentTypeId: json["order_payment_type_id"],
        clientComment:
            json["client_comment"] == null ? null : json["client_comment"],
        clientEmail: json["client_email"],
        clientAddressData: json["client_address_data"] == null
            ? null
            : OrderListClientAddressData.fromJson(json["client_address_data"]),
        isPaid: json["is_paid"],
        deliveryPrice: json["delivery_price"].toDouble(),
        totalDiscountForProducts:
            json["total_discount_for_products"].toDouble(),
        totalPriceForProductsWithDiscount:
            json["total_price_for_products_with_discount"].toDouble(),
        totalPrice: json["total_price"].toDouble(),
        totalWeight: json["total_weight"].toDouble(),
        totalQuantity: json["total_quantity"].toString() == null
            ? null
            : double.parse(json["total_quantity"].toString()),
        plannedDeliveryDatetimeFrom: json["planned_delivery_datetime_from"],
        plannedDeliveryDatetimeTo: json["planned_delivery_datetime_to"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        paidBonus: json["paid_bonus"],
        bonusToCharge: json["bonus_to_charge"],
        totalBonus: json["total_bonus"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "paid_bonus": paidBonus,
        "bonus_to_charge": bonusToCharge,
        "total_bonus": totalBonus,
        "number": number,
        "store_user_uuid": storeUserUuid,
        "store_user_full_name": storeUserFullName,
        "store_user_address": storeUserAddress,
        "order_status_id": orderStatusId,
        "order_delivery_type_id": orderDeliveryTypeId,
        "order_payment_type_id": orderPaymentTypeId,
        "client_comment": clientComment == null ? null : clientComment,
        "client_email": clientEmail,
        "client_address_data":
            clientAddressData == null ? null : clientAddressData!.toJson(),
        "is_paid": isPaid,
        "delivery_price": deliveryPrice,
        "total_discount_for_products": totalDiscountForProducts,
        "total_price_for_products_with_discount":
            totalPriceForProductsWithDiscount,
        "total_price": totalPrice,
        "total_weight": totalWeight,
        "total_quantity": totalQuantity,
        "planned_delivery_datetime_from": plannedDeliveryDatetimeFrom,
        "planned_delivery_datetime_to": plannedDeliveryDatetimeTo,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class OrderListClientAddressData {
  OrderListClientAddressData({
    this.floor,
    this.address,
    this.entrance,
    required this.intercomCode,
    this.apartmentNumber,
  });

  dynamic floor;
  String? address;
  dynamic entrance;
  String intercomCode;
  dynamic apartmentNumber;

  factory OrderListClientAddressData.fromJson(Map<String, dynamic> json) =>
      OrderListClientAddressData(
        floor: json["floor"],
        address: json["address"],
        entrance: json["entrance"],
        intercomCode: json["intercom_code"],
        apartmentNumber: json["apartment_number"],
      );
  Map<String, dynamic> toJson() => {
        "floor": floor,
        "address": address,
        "entrance": entrance,
        "intercom_code": intercomCode,
        "apartment_number": apartmentNumber,
      };
}
