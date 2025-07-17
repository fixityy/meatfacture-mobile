// ignore: implementation_imports
import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/bloc_files/shopping_list_details_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/models/shopping_list_data_model.dart';
import 'package:smart/pages/shopping_list/widgets/update_shopping_list_bottom_sheet.dart';
import 'package:smart/models/shopping_lists_model.dart';
import 'package:smart/pages/shopping_list/shopping_list_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class ShoppingListsItemBuilder extends StatefulWidget {
  final ShoppingListsModel shoppingListsModel;

  const ShoppingListsItemBuilder({required this.shoppingListsModel});

  @override
  _ShoppingListsItemBuilderState createState() =>
      _ShoppingListsItemBuilderState();
}

class _ShoppingListsItemBuilderState extends State<ShoppingListsItemBuilder>
    with SingleTickerProviderStateMixin {
  late SlidableController _shoppingListSlidableController =
      SlidableController(this);
  late bool isinit;

  @override
  void initState() {
    isinit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BasketListBloc _basketListBloc = BlocProvider.of(context);
    // ignore: close_sinks

    // // ignore: close_sinks
    // SecondaryPageBloc _bottomNavBloc =
    //     BlocProvider.of<SecondaryPageBloc>(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (_shoppingListSlidableController.activeState != null) {}
      // _shoppingListSlidableController.activeState.context.on;
      // final slidable = Slidable.of(context);
      // slidable.open();
    });

    return ListView.separated(
      separatorBuilder: (context, index) =>
          SizedBox(height: heightRatio(size: 40, context: context)),
      padding: EdgeInsets.symmetric(
          vertical: heightRatio(size: 20, context: context)),
      itemCount: widget.shoppingListsModel.data.length,
      itemBuilder: (BuildContext context, int index) {
        return _ShopingListLine(
          key: ValueKey(widget.shoppingListsModel.data[index].uuid),
          modelsList: widget.shoppingListsModel,
          index: index,
          controller: _shoppingListSlidableController,
          showActions: true,
          addToBasket: (model) async {
            if (!await BasketProvider().addShoppingListToBasket(model.uuid)) {
              Fluttertoast.showToast(msg: "errorText".tr());
            } else {
              _basketListBloc.add(BasketLoadEvent());
            }
          },
          delete: (model) async {
            Fluttertoast.showToast(msg: "Подождите...");
            if (await DeleteShoppingListProvider()
                .getDeleteShoppingListResponse(shoppingListsUuid: model.uuid)) {
              setState(() {
                widget.shoppingListsModel.data.removeAt(index);
              });
            } else {
              await Fluttertoast.showToast(msg: 'errorText'.tr());
            }
          },
        );
      },
    );
  }
}

class _ShopingListLine extends StatelessWidget {
  final SlidableController controller;
  final ShoppingListsModel modelsList;
  final int index;
  final Function(ShoppingListDataModel) addToBasket;
  final Function(ShoppingListDataModel) delete;
  final bool showActions;

  _ShopingListLine({
    required this.controller,
    required this.modelsList,
    required this.index,
    required this.addToBasket,
    required this.delete,
    required this.showActions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = modelsList.data[index];
    log(model.uuid.toString());
    ShoppingListDetailsBloc _shoppingListDetailsBloc =
        BlocProvider.of<ShoppingListDetailsBloc>(context);
    return Slidable(
      key: ValueKey(model.uuid),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) => addToBasket(model),
            autoClose: true,
            child: Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.symmetric(
              //     horizontal: widthRatio(size: 5, context: context)),
              width: widthRatio(size: 32, context: context),
              child: SvgPicture.asset(
                'assets/images/busketIcon.svg',
                height: heightRatio(size: 20, context: context),
                width: widthRatio(size: 20, context: context),
                color: newGrey,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      heightRatio(size: 5, context: context)),
                  border: Border.all(color: newGrey, width: 1)),
            ),
          ),
          CustomSlidableAction(
            onPressed: (context) {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                useSafeArea: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        heightRatio(size: 25, context: context)),
                    topRight: Radius.circular(
                        heightRatio(size: 25, context: context)),
                  ),
                ),
                builder: (BuildContext bc) {
                  return Wrap(
                    children: [
                      UpdateShoppingListBottomSheetWidget(
                        shoppingListName: modelsList.data[index].name,
                        shoppingListsUuid: modelsList.data[index].uuid,
                      ),
                    ],
                  );
                },
              );
            },
            autoClose: true,
            child: Container(
              width: widthRatio(size: 32, context: context),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/editIcon.svg',
                width: widthRatio(size: 20, context: context),
                height: heightRatio(size: 20, context: context),
                color: newGrey,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    heightRatio(size: 3, context: context)),
                border: Border.all(color: newGrey, width: 1),
              ),
            ),
          ),
          CustomSlidableAction(
            onPressed: (context) => delete(model),
            child: Container(
              width: widthRatio(size: 32, context: context),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/newTrash.svg',
                height: heightRatio(size: 20, context: context),
                width: widthRatio(size: 20, context: context),
                color: newGrey,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    heightRatio(size: 3, context: context)),
                border: Border.all(color: newGrey, width: 1),
              ),
            ),
          ),
        ],
      ),
      // actionPane: SlidableDrawerActionPane(),
      child: Builder(builder: (context) {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            if (showActions) {
              initSlidableAnimation(context: context);
            }
          },
        );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //Go To  detail page
            _shoppingListDetailsBloc.add(ShoppingListDetailsLoadEvent(
                shoppingListUuid: modelsList.data[index].uuid));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShoppingListDetailsPage(
                        shoppingListName: modelsList.data[index].name)));
          },
          child: _Line(modelsList.data[index]),
        );
      }),
    );
  }

  Future<void> initSlidableAnimation({required BuildContext context}) async {
    if (await prefs.getBool("hasShoppingListIn") == null ||
        await prefs.getBool("hasShoppingListIn") == false) {
      prefs.setBool("hasShoppingListIn", true);
      final SlidableController? slidable = Slidable.of(context);
      slidable?.openEndActionPane();
      Timer(Duration(milliseconds: 1500), () {
        slidable?.close();
      });
    }
  }
}

class _Line extends StatelessWidget {
  final ShoppingListDataModel model;

  _Line(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widthRatio(size: 16, context: context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.name,
                style: appHeadersTextStyle(
                    color: newBlack,
                    fontSize: heightRatio(size: 17, context: context)),
              ),
              SizedBox(height: heightRatio(size: 13, context: context)),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2), color: newRedDark),
                height: heightRatio(size: 18, context: context),
                width: widthRatio(size: 81, context: context),
                child: Center(
                  child: Text(
                    model.assortments.length.toString() + " товаров",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: heightRatio(size: 10, context: context)),
                  ),
                ),
              ),
            ],
          ),
          if (model.assortments.length > 0)
            Container(
              width: 130,
              height: 48,
              child: Stack(
                children: [
                  if (model.assortments.length >= 3)
                    Positioned(
                      right: 70,
                      top: 0,
                      child: Container(
                        width: widthRatio(size: 48, context: context),
                        height: heightRatio(size: 48, context: context),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              model.assortments[2].images[0].thumbnails
                                  .the1000X1000,
                              cacheManager: CustomCacheManager(),
                            ),
                            // image: NetworkImage(widget.shoppingListsModel.data[index].assortments[2].images[0].thumbnails.the1000X1000),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  if (model.assortments.length >= 2)
                    Positioned(
                      right: 35,
                      top: 0,
                      child: Container(
                        width: widthRatio(size: 48, context: context),
                        height: heightRatio(size: 48, context: context),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: model.assortments[1].images.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    model.assortments[1].images[0].thumbnails
                                        .the1000X1000,
                                    cacheManager: CustomCacheManager(),
                                  )
                                : AssetImage("assets/images/notImage.png")
                                    as ImageProvider,
                            fit: model.assortments[1].images.isNotEmpty
                                ? BoxFit.cover
                                : BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  if (model.assortments.length >= 1)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: widthRatio(size: 48, context: context),
                        height: heightRatio(size: 48, context: context),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              model.assortments[0].images[0].thumbnails
                                  .the1000X1000,
                              cacheManager: CustomCacheManager(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  if (model.assortments.length > 3)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: widthRatio(size: 48, context: context),
                        height: heightRatio(size: 48, context: context),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            '+${model.assortments.length - 3}',
                            style: appHeadersTextStyle(
                                color: whiteColor,
                                fontSize:
                                    heightRatio(size: 16, context: context)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
