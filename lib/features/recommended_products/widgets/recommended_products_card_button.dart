import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/recommended_products/provider/assortments_model.dart';
import 'package:smart/features/recommended_products/recommended_products_page.dart';
import 'package:userx_flutter/userx_flutter.dart';

class RecommendedProductsCardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        UserX.addEvent('recommendations', {});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (_) => AssortmentsModel(),
                    child: RecommendedProductsPage())));
      },
      child: Container(
        padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius:
              BorderRadius.circular(heightRatio(size: 10, context: context)),
          boxShadow: [
            BoxShadow(
                color: newShadow,
                offset: Offset(12, 12),
                blurRadius: 24,
                spreadRadius: 0)
          ],
          // Тень
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            heightRatio(size: 5, context: context)),
                        color: newIconBg),
                    child: Icon(Icons.stars_rounded,
                        color: newRedDark,
                        size: heightRatio(size: 32, context: context))),
                SizedBox(width: widthRatio(size: 15, context: context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "addTheseProducts".tr(),
                        style: appHeadersTextStyle(
                            fontSize: heightRatio(size: 15, context: context),
                            color: newBlack),
                      ),
                      SizedBox(height: heightRatio(size: 5, context: context)),
                      Text(
                        "weHaveSelectedTheseProducts".tr(),
                        textAlign: TextAlign.start,
                        style: appLabelTextStyle(
                            fontSize: heightRatio(size: 13, context: context),
                            fontWeight: FontWeight.w400,
                            color: newBlackLight),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widthRatio(size: 10, context: context)),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: newRedDark,
                    size: heightRatio(size: 23, context: context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
