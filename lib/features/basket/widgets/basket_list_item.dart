import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/bloc_files/add_or_subtract_bonuses_bloc.dart';
import 'package:smart/bloc_files/order_calculate_bloc.dart';
import 'package:smart/bloc_files/selected_pay_card_and_address_for_order_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/basket/models/basket_list_model.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class BasketListItem extends StatefulWidget {
  final int index;
  final BasketListDataModel item;
  final BasketListBloc basketListBloc;
  final BasketLoadedState state;
  final List<ProductModelForOrderRequest> productModelForOrderRequestList;
  final OrderCalculateBloc orderCalculateBloc;
  final AddOrSubtractBonusesState addOrSubtractBonusesState;
  final SelectedPayCardAndAddressForOrderState
      selectedPayCardAndAddressForOrderState;
  final int subtractBonuses;
  final String orderDeliveryTypeId;

  const BasketListItem({
    required this.index,
    required this.item,
    required this.basketListBloc,
    required this.state,
    required this.productModelForOrderRequestList,
    required this.orderCalculateBloc,
    required this.addOrSubtractBonusesState,
    required this.selectedPayCardAndAddressForOrderState,
    required this.subtractBonuses,
    required this.orderDeliveryTypeId,
    super.key,
  });

  @override
  _BasketListItemState createState() => _BasketListItemState();
}

class _BasketListItemState extends State<BasketListItem>
    with SingleTickerProviderStateMixin {
  late final SlidableController _shoppingListSlidableController =
      SlidableController(this);
  bool isLoadingText = false;

  Future<void> _updateProductInBasket(
      String productUuid, double quantity) async {
    setState(() {
      isLoadingText = true;
    });

    await BasketProvider().updateProductInBasket(
      productUuid: productUuid,
      quantity: quantity,
    );

    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoadingText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            new CupertinoPageRoute(
              builder: (context) => RedesProductDetailsPage(
                isFromBasket: true,
                productUuid: widget.item.assortment.uuid,
              ),
            ),
          );
        },
        child: _Line(
            model: widget.item,
            controller: _shoppingListSlidableController,
            index: widget.index,
            isLoadingText: isLoadingText,
            callback: (it) => isLoadingText = it,
            updateItem: _updateProductInBasket,
            deleteItem: _deleteProductFromBasket,
            basketListBloc: widget.basketListBloc,
            calculateOrder: () {
              _calculateOrder(
                orderCalculateBloc: widget.orderCalculateBloc,
                productModelForOrderRequestList:
                    widget.productModelForOrderRequestList,
                selectedPayCardAndAddressForOrderState:
                    widget.selectedPayCardAndAddressForOrderState,
                addOrSubtractBonusesState: widget.addOrSubtractBonusesState,
              );
            }));
  }

  Future<void> _deleteProductFromBasket(
    int index,
    BasketListBloc basketListBloc,
  ) async {
    if (await BasketProvider()
        .reomoveProductFromBasket(widget.item.assortment.uuid)) {
      basketListBloc.add(BasketRemoveItemEvent(index));
      if (widget.state.basketListModel.data!.isNotEmpty) {
        _calculateOrder(
          orderCalculateBloc: widget.orderCalculateBloc,
          productModelForOrderRequestList:
              widget.productModelForOrderRequestList,
          selectedPayCardAndAddressForOrderState:
              widget.selectedPayCardAndAddressForOrderState,
          addOrSubtractBonusesState: widget.addOrSubtractBonusesState,
        );
      }
    } else {
      Fluttertoast.showToast(msg: "Не удалось удалить продукт!");
    }
  }

  void _calculateOrder({
    required OrderCalculateBloc orderCalculateBloc,
    required List<ProductModelForOrderRequest> productModelForOrderRequestList,
    required SelectedPayCardAndAddressForOrderState
        selectedPayCardAndAddressForOrderState,
    required AddOrSubtractBonusesState addOrSubtractBonusesState,
  }) {
    orderCalculateBloc.add(OrderCalculateLoadEvent(
      subtractBonusesCount: addOrSubtractBonusesState is AddBonusesState
          ? null
          : widget.subtractBonuses,
      orderDeliveryTypeId: widget.orderDeliveryTypeId,
      orderPaymentTypeId: selectedPayCardAndAddressForOrderState
              is SelectedPayCardAndAddressForOrderLoadedState
          ? selectedPayCardAndAddressForOrderState.payType
          : null,
      productModelForOrderRequestList: productModelForOrderRequestList,
    ));
  }
}

class _Line extends StatelessWidget {
  final SlidableController controller;
  final int index;
  final bool isLoadingText;
  final BasketListDataModel model;
  final void Function(bool) callback;
  final Future<void> Function(String productUuid, double quantity) updateItem;
  final Future<void> Function(int index, BasketListBloc basketListBloc)
      deleteItem;
  final BasketListBloc basketListBloc;
  final VoidCallback calculateOrder;

  _Line({
    required this.model,
    required this.controller,
    required this.index,
    required this.isLoadingText,
    required this.callback,
    required this.updateItem,
    required this.deleteItem,
    required this.basketListBloc,
    required this.calculateOrder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      // actionExtentRatio: 1 / 6,
      // secondaryActions: [
      //   IconSlideAction(
      //     onTap: () async {
      //       await _deleteProductFromBasket(
      //         index: widget.index,
      //         basketListBloc: widget.basketListBloc,
      //       );
      //     },
      //     closeOnTap: true,
      //     iconWidget: Container(
      //       height: 89,
      //       margin:
      //           EdgeInsets.only(left: widthRatio(size: 20, context: context)),
      //       padding: EdgeInsets.symmetric(
      //           horizontal: widthRatio(size: 11, context: context)),
      //       alignment: Alignment.center,
      //       child: SvgPicture.asset(
      //         'assets/images/newTrash.svg',
      //         height: heightRatio(size: 21, context: context),
      //         width: widthRatio(size: 18, context: context),
      //       ),
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(
      //             heightRatio(size: 15, context: context)),
      //         border: Border.all(
      //             color: newGrey,
      //             width: widthRatio(size: 1, context: context)),
      //       ),
      //     ),
      //   ),
      // ],
      // actionPane: SlidableScrollActionPane(),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: heightRatio(size: 10, context: context)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            //фото левая часть товара
                            Container(
                              foregroundDecoration: (model
                                                  .assortment.currentPrice !=
                                              null ||
                                          model.assortment.priceWithDiscount !=
                                              null) &&
                                      model.assortment.quantityInStore != null
                                  ? BoxDecoration()
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          heightRatio(
                                              size: 8, context: context)),
                                      color: Colors.grey,
                                      backgroundBlendMode:
                                          BlendMode.saturation),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    heightRatio(size: 8, context: context)),
                                color: newIconBg,
                              ),
                              height: heightRatio(size: 89, context: context),
                              width: widthRatio(size: 89, context: context),
                              child: model.assortment.images.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: model.assortment.images[0]
                                          .thumbnails.the1000X1000,
                                      cacheManager: CustomCacheManager(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              "assets/images/notImage.png",
                                              fit: BoxFit.contain),
                                      useOldImageOnUrlChange: true,
                                    )
                                  // ? Image.network(
                                  //     widget.item.assortment.images[0].thumbnails.the1000X1000,
                                  //     fit: BoxFit.cover,
                                  //   )
                                  : Image.asset("assets/images/notImage.png",
                                      fit: BoxFit.fitWidth),
                            ),

                            // bonuses
                            if (model.assortment.bonusPercent != null &&
                                model.assortment.bonusPercent != 0)
                              Positioned(
                                bottom: heightRatio(size: 4, context: context),
                                left: widthRatio(size: 4, context: context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(
                                        widthRatio(size: 4, context: context)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          widthRatio(size: 4, context: context),
                                      vertical: heightRatio(
                                          size: 2, context: context)),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: widthRatio(
                                            size: 15, context: context),
                                        height: heightRatio(
                                            size: 15, context: context),
                                        child: SvgPicture.asset(
                                            'assets/images/bonus_vector.svg',
                                            width: widthRatio(
                                                size: 15, context: context),
                                            height: heightRatio(
                                                size: 15, context: context)),
                                      ),
                                      SizedBox(
                                          width: widthRatio(
                                              size: 3, context: context)),
                                      Text(
                                        model.assortment.priceWithDiscount ==
                                                    null ||
                                                model.assortment
                                                        .priceWithDiscount ==
                                                    0
                                            ? (model.assortment.currentPrice! /
                                                    100 *
                                                    model.assortment
                                                        .bonusPercent!)
                                                .toStringAsFixed(0)
                                            : (model.assortment
                                                        .priceWithDiscount! /
                                                    100 *
                                                    model.assortment
                                                        .bonusPercent!)
                                                .toStringAsFixed(0),
                                        style: appHeadersTextStyle(
                                            fontSize: heightRatio(
                                                size: 10, context: context),
                                            fontWeight: FontWeight.w700,
                                            color: colorBlack06),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                        SizedBox(width: widthRatio(size: 10, context: context)),
                        Expanded(
                          // правая часть товара
                          child: SizedBox(
                            height: heightRatio(size: 89, context: context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        model.assortment.name,
                                        maxLines: 2,
                                        style: appHeadersTextStyle(
                                          color: (model.assortment
                                                              .currentPrice !=
                                                          null ||
                                                      model.assortment
                                                              .priceWithDiscount !=
                                                          null) &&
                                                  model.assortment
                                                          .quantityInStore !=
                                                      null
                                              ? newBlack
                                              : colorBlack04,
                                          fontSize: heightRatio(
                                              size: 12, context: context),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          //rating
                                          if (model.assortment.rating != null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/newStar.svg",
                                                  height: heightRatio(
                                                      size: 11,
                                                      context: context),
                                                ),
                                                SizedBox(
                                                    width: widthRatio(
                                                        size: 2,
                                                        context: context)),
                                                Text(
                                                  model.assortment.rating !=
                                                          null
                                                      ? model.assortment.rating
                                                          .toString()
                                                      : '',
                                                  style: appHeadersTextStyle(
                                                      fontSize: heightRatio(
                                                          size: 9,
                                                          context: context),
                                                      color: newGrey),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start, // + -
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            callback(true);
                                            await updateItem(
                                              model.assortment.uuid,
                                              model.quantity -
                                                  (model.assortment
                                                              .assortmentUnitId ==
                                                          "kilogram"
                                                      ? model.assortment.weight
                                                              .toInt()! /
                                                          1000
                                                      : 1),
                                            );

                                            if (model.assortment
                                                    .assortmentUnitId !=
                                                "kilogram") {
                                              if (model.quantity > 1) {
                                                context.read<BasketListBloc>().add(
                                                    UpdateProductQuantityEvent(
                                                        index: index,
                                                        newQuantity:
                                                            model.quantity -
                                                                1));
                                              } else {
                                                await deleteItem(
                                                  index,
                                                  basketListBloc,
                                                );
                                              }
                                            } else {
                                              // Обработка для весового товара
                                              //убавляем с корзины
                                              double weight = double.tryParse(
                                                      model
                                                          .assortment.weight) ??
                                                  0.0;
                                              double weightInKg = weight / 1000;
                                              double newQuantity =
                                                  model.quantity - weightInKg;
                                              if (newQuantity > 0) {
                                                context.read<BasketListBloc>().add(
                                                    UpdateProductQuantityEvent(
                                                        index: index,
                                                        newQuantity:
                                                            newQuantity));
                                              } else {
                                                await deleteItem(
                                                    index, basketListBloc);
                                              }
                                            }
                                            calculateOrder();
                                            // _calculateOrder(
                                            //   orderCalculateBloc:
                                            //       widget.orderCalculateBloc,
                                            //   productModelForOrderRequestList:
                                            //       widget
                                            //           .productModelForOrderRequestList,
                                            //   selectedPayCardAndAddressForOrderState:
                                            //       widget
                                            //           .selectedPayCardAndAddressForOrderState,
                                            //   addOrSubtractBonusesState: widget
                                            //       .addOrSubtractBonusesState,
                                            // );
                                            Timer(Duration(seconds: 1), () {
                                              callback(false);
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            ((model.assortment.currentPrice ==
                                                            null ||
                                                        model.assortment
                                                                .priceWithDiscount ==
                                                            null) &&
                                                    model.assortment
                                                            .quantityInStore ==
                                                        null)
                                                ? "assets/images/remove_circle_button_grey.svg"
                                                : "assets/images/remove_circle_button.svg",
                                            height: heightRatio(
                                                size: 28, context: context),
                                            width: widthRatio(
                                                size: 28, context: context),
                                          ),
                                        ),
                                        SizedBox(
                                            width: widthRatio(
                                                size: 8, context: context)),
                                        isLoadingText
                                            ? Shimmer.fromColors(
                                                baseColor: Colors.grey.shade500,
                                                highlightColor:
                                                    Colors.grey.shade500,
                                                child: Text(
                                                  model.assortment
                                                              .assortmentUnitId ==
                                                          "kilogram"
                                                      ? model.quantity > 0.9
                                                          ? "${model.quantity.toStringAsFixed(1)}${"kgText".tr()}"
                                                          : "${(model.quantity * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                                              .toString()
                                                      : model.quantity
                                                              .toInt()
                                                              .toString() +
                                                          " " +
                                                          getAssortmentUnitId(
                                                              assortmentUnitId: model
                                                                  .assortment
                                                                  .assortmentUnitId)[1],
                                                  style: appHeadersTextStyle(
                                                      fontSize: 12,
                                                      color: newBlack),
                                                ),
                                              )
                                            : Text(
                                                model.assortment
                                                            .assortmentUnitId ==
                                                        "kilogram"
                                                    ? model.quantity > 0.9
                                                        ? (model.quantity % 1 ==
                                                                0
                                                            ? "${model.quantity.toInt()}${"kgText".tr()}"
                                                            : "${model.quantity.toStringAsFixed(1)}${"kgText".tr()}")
                                                        : "${(model.quantity * 1000).toStringAsFixed(0)}${"grText".tr()}"
                                                    : model.quantity
                                                            .toInt()
                                                            .toString() +
                                                        " " +
                                                        getAssortmentUnitId(
                                                            assortmentUnitId: model
                                                                .assortment
                                                                .assortmentUnitId)[1],
                                                style: appHeadersTextStyle(
                                                    fontSize: 12,
                                                    color: newBlack),
                                              ),
                                        SizedBox(
                                            width: widthRatio(
                                                size: 8, context: context)),
                                        InkWell(
                                          onTap: () async {
                                            callback(true);

                                            await updateItem(
                                              model.assortment.uuid,
                                              model.quantity +
                                                  (model.assortment
                                                              .assortmentUnitId ==
                                                          "kilogram"
                                                      ? model.assortment.weight
                                                              .toInt()! /
                                                          1000
                                                      : 1),
                                            );

                                            if (model.assortment
                                                    .assortmentUnitId !=
                                                "kilogram") {
                                              context.read<BasketListBloc>().add(
                                                  UpdateProductQuantityEvent(
                                                      index: index,
                                                      newQuantity:
                                                          model.quantity + 1));
                                            } else {
                                              // Обработка для весового товара
                                              //Добавляем с корзины
                                              double weight = double.tryParse(
                                                      model
                                                          .assortment.weight) ??
                                                  0.0;
                                              double weightInKg = weight / 1000;
                                              double newQuantity =
                                                  model.quantity + weightInKg;
                                              context.read<BasketListBloc>().add(
                                                  UpdateProductQuantityEvent(
                                                      index: index,
                                                      newQuantity:
                                                          newQuantity));
                                            }
                                            calculateOrder();

                                            Timer(Duration(seconds: 1), () {
                                              callback(false);
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            ((model.assortment.currentPrice ==
                                                            null ||
                                                        model.assortment
                                                                .priceWithDiscount ==
                                                            null) &&
                                                    model.assortment
                                                            .quantityInStore ==
                                                        null)
                                                ? "assets/images/add_circle_button_grey.svg"
                                                : "assets/images/add_circle_button.svg",
                                            height: heightRatio(
                                                size: 28, context: context),
                                            width: widthRatio(
                                                size: 28, context: context),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Prices
                                    BlocBuilder<OrderCalculateBloc,
                                        OrderCalculateState>(
                                      builder: (context, calculateState) {
                                        return calculateState
                                                        .orderCalculateResponseModel !=
                                                    null &&
                                                calculateState
                                                        .orderCalculateResponseModel!
                                                        .data
                                                        .products
                                                        .length >
                                                    index
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (calculateState
                                                              .orderCalculateResponseModel!
                                                              .data
                                                              .products[index]
                                                              .originalPrice !=
                                                          calculateState
                                                              .orderCalculateResponseModel!
                                                              .data
                                                              .products[index]
                                                              .priceWithDiscount)
                                                        Stack(
                                                          //цена перечеркнутая
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: calculateState
                                                                        .orderCalculateResponseModel!
                                                                        .data
                                                                        .products[
                                                                            index]
                                                                        .originalPrice!
                                                                        .toStringAsFixed(
                                                                            0),
                                                                    style: appLabelTextStyle(
                                                                        fontSize: heightRatio(
                                                                            size:
                                                                                12,
                                                                            context:
                                                                                context),
                                                                        color:
                                                                            newGrey),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        " ${"rubleSignText".tr()}",
                                                                    style: appTextStyle(
                                                                        fontSize: heightRatio(
                                                                            size:
                                                                                12,
                                                                            context:
                                                                                context),
                                                                        color:
                                                                            newGrey,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0,
                                                              child: Image.asset(
                                                                  "assets/images/line_through_image.png",
                                                                  fit: BoxFit
                                                                      .contain),
                                                            )
                                                          ],
                                                        ),
                                                      SizedBox(
                                                          width: widthRatio(
                                                              size: 10,
                                                              context:
                                                                  context)),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: calculateState
                                                                  .orderCalculateResponseModel!
                                                                  .data
                                                                  .products[
                                                                      index]
                                                                  .price!
                                                                  .toStringAsFixed(
                                                                      0),
                                                              style: appLabelTextStyle(
                                                                  fontSize: heightRatio(
                                                                      size: 12,
                                                                      context:
                                                                          context),
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  " ${"rubleSignText".tr()}",
                                                              style: appTextStyle(
                                                                  fontSize: heightRatio(
                                                                      size: 12,
                                                                      context:
                                                                          context),
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: heightRatio(
                                                          size: 6,
                                                          context: context)),
                                                  if (calculateState
                                                              .orderCalculateResponseModel!
                                                              .data
                                                              .products[index]
                                                              .price !=
                                                          null ||
                                                      calculateState
                                                              .orderCalculateResponseModel!
                                                              .data
                                                              .products[index]
                                                              .priceWithDiscount !=
                                                          null)
                                                    Container(
                                                      //цена закрашенная price
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              widthRatio(
                                                                  size: 6,
                                                                  context:
                                                                      context),
                                                          vertical: heightRatio(
                                                              size: 3,
                                                              context:
                                                                  context)),
                                                      decoration: BoxDecoration(
                                                          color: calculateState
                                                                      .orderCalculateResponseModel!
                                                                      .data
                                                                      .products[
                                                                          index]
                                                                      .discountTypeColor ==
                                                                  null
                                                              ? newRedDark
                                                              : Color(int.parse(
                                                                  "0xff${calculateState.orderCalculateResponseModel!.data.products[index].discountTypeColor}")),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  heightRatio(
                                                                      size: 4,
                                                                      context:
                                                                          context))),
                                                      child: isLoadingText
                                                          ? Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade100,
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      style: appHeadersTextStyle(
                                                                          color: (calculateState.orderCalculateResponseModel!.data.products[index].price != null || calculateState.orderCalculateResponseModel!.data.products[index].priceWithDiscount != null) && model.assortment.quantityInStore != null
                                                                              ? whiteColor
                                                                              : colorBlack04,
                                                                          fontSize: heightRatio(
                                                                              size: 12,
                                                                              context: context)),
                                                                      text: calculateState
                                                                          .orderCalculateResponseModel!
                                                                          .data
                                                                          .products[
                                                                              index]
                                                                          .totalAmountWithDiscount!
                                                                          .toStringAsFixed(
                                                                              0),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          " ${"rubleSignText".tr()}",
                                                                      style: appTextStyle(
                                                                          color: (calculateState.orderCalculateResponseModel!.data.products[index].price != null || calculateState.orderCalculateResponseModel!.data.products[index].priceWithDiscount != null) && model.assortment.quantityInStore != null
                                                                              ? whiteColor
                                                                              : colorBlack04,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize: heightRatio(
                                                                              size: 12,
                                                                              context: context)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    style: appHeadersTextStyle(
                                                                        color: (calculateState.orderCalculateResponseModel!.data.products[index].price != null || calculateState.orderCalculateResponseModel!.data.products[index].priceWithDiscount != null) && model.assortment.quantityInStore != null
                                                                            ? whiteColor
                                                                            : colorBlack04,
                                                                        fontSize: heightRatio(
                                                                            size:
                                                                                12,
                                                                            context:
                                                                                context)),
                                                                    text: calculateState
                                                                        .orderCalculateResponseModel!
                                                                        .data
                                                                        .products[
                                                                            index]
                                                                        .totalAmountWithDiscount!
                                                                        .toStringAsFixed(
                                                                            0),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        " ${"rubleSignText".tr()}",
                                                                    style: appTextStyle(
                                                                        color: (calculateState.orderCalculateResponseModel!.data.products[index].price != null || calculateState.orderCalculateResponseModel!.data.products[index].priceWithDiscount != null) && model.assortment.quantityInStore != null
                                                                            ? whiteColor
                                                                            : colorBlack04,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize: heightRatio(
                                                                            size:
                                                                                12,
                                                                            context:
                                                                                context)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    ),
                                                  SizedBox(
                                                      height: heightRatio(
                                                          size: 4,
                                                          context: context)),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  if ((model.assortment
                                                                  .currentPrice ==
                                                              null ||
                                                          model.assortment
                                                                  .priceWithDiscount ==
                                                              null) &&
                                                      model.assortment
                                                              .quantityInStore ==
                                                          null)
                                                    Text(
                                                        "notAvailable".tr(),
                                                        style: appHeadersTextStyle(
                                                            fontSize:
                                                                heightRatio(
                                                                    size: 13,
                                                                    context:
                                                                        context),
                                                            color: newRedDark)),
                                                  SizedBox(
                                                      height: heightRatio(
                                                          size: 4,
                                                          context: context)),
                                                ],
                                              );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heightRatio(size: 20, context: context)),
                    Container(height: 1, color: grey04),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
