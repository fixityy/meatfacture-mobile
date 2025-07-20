import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/custom_widgets/assortment_filter_button.dart';
import 'package:smart/features/recommended_products/provider/recommended_product_model.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class RecommendedProductWidget extends StatelessWidget {
  const RecommendedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AssortmentsListModel _assortmentsListModel =
        context.watch<RecommendedProductModel>().assortmentsListModel;

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RedesProductDetailsPage(
                productUuid: _assortmentsListModel.uuid!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: widthRatio(size: 2.5, context: context),
          vertical: heightRatio(size: 2.5, context: context),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(heightRatio(size: 14, context: context)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: heightRatio(size: 165, context: context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    heightRatio(size: 5, context: context)),
                color: _assortmentsListModel.images?.isNotEmpty == true
                    ? Colors.transparent
                    : newGrey2,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    heightRatio(size: 5, context: context)),
                child: Stack(children: [
                  _assortmentsListModel.images?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: _assortmentsListModel
                              .images![0].thumbnails.the1000X1000,
                          cacheManager: CustomCacheManager(),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset(
                              "assets/images/notImage.png",
                              fit: BoxFit.contain),
                          useOldImageOnUrlChange: true,
                        )
                      : Image.asset("assets/images/notImage.png",
                          fit: BoxFit.contain),
                  if (_assortmentsListModel.isbasketAdding)
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorBlack05,
                        borderRadius: BorderRadius.circular(
                            heightRatio(size: 5, context: context)),
                      ),
                      child: Text("inBasket".tr(),
                          style: appHeadersTextStyle(
                              color: whiteColor,
                              fontSize:
                                  heightRatio(size: 12, context: context))),
                    )
                ]),
              ),
            ),
            SizedBox(height: heightRatio(size: 4, context: context)),
            SizedBox(
              height: heightRatio(size: 27, context: context),
              child: Text(
                _assortmentsListModel.name != null
                    ? '${_assortmentsListModel.name}'
                    : "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: appLabelTextStyle(
                    fontSize: heightRatio(size: 12, context: context),
                    color: newBlack),
              ),
            ),
            SizedBox(height: heightRatio(size: 3, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _assortmentsListModel.assortmentUnitId == "kilogram"
                    ? Text(
                        '${(_assortmentsListModel.weight!.toDouble()! % 1000 == 0) ? (_assortmentsListModel.weight!.toDouble()! ~/ 1000) : (_assortmentsListModel.weight!.toDouble()! / 1000).toStringAsFixed(1)} кг',
                        style: appHeadersTextStyle(
                            fontSize: heightRatio(size: 10, context: context),
                            color: grey6D6D6D),
                      )
                    : Text(
                        '${(_assortmentsListModel.weight == "0" ? 1 : _assortmentsListModel.weight)} ${getAssortmentUnitId(assortmentUnitId: _assortmentsListModel.assortmentUnitId)[1]}',
                        style: appHeadersTextStyle(
                            fontSize: heightRatio(size: 10, context: context),
                            color: grey6D6D6D),
                      ),
                Text(
                  _assortmentsListModel.priceWithDiscount == null
                      ? '${(double.parse(_assortmentsListModel.currentPrice!) % 1 == 0 ? double.parse(_assortmentsListModel.currentPrice!).toStringAsFixed(0) : double.parse(_assortmentsListModel.currentPrice!).toStringAsFixed(2))} руб/кг'
                      : '${(_assortmentsListModel.priceWithDiscount! % 1 == 0 ? _assortmentsListModel.priceWithDiscount!.toStringAsFixed(0) : _assortmentsListModel.priceWithDiscount!.toStringAsFixed(2))} руб/кг',
                  style: appHeadersTextStyle(
                      fontSize: heightRatio(size: 10, context: context),
                      color: grey6D6D6D),
                ),
              ],
            ),
            SizedBox(height: heightRatio(size: 10, context: context)),
            InkWell(
              onTap: () async {
                if (await loadToken() != "guest") {
                  context
                      .read<RecommendedProductModel>()
                      .addOrRemoveFromBasket();
                } else {
                  AssortmentFilterButton().loginOrRegWarning(context);
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: newRedDark,
                  borderRadius: BorderRadius.circular(
                      heightRatio(size: 4, context: context)),
                ),
                child: Text(
                  !_assortmentsListModel.isbasketAdding
                      ? "add".tr()
                      : "remove".tr(),
                  style: appHeadersTextStyle(
                      color: whiteColor,
                      fontSize: heightRatio(size: 12, context: context)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
