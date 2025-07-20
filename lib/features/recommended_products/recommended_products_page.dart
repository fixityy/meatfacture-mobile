import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/recommended_products/provider/assortments_model.dart';
import 'package:smart/features/recommended_products/provider/recommended_product_model.dart';
import 'package:smart/features/recommended_products/widgets/recommended_product_widget.dart';
import 'package:smart/models/assortments_list_model.dart';

class RecommendedProductsPage extends StatelessWidget {
  const RecommendedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AssortmentsListModel> _assortments =
        context.watch<AssortmentsModel>().assortments;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(
                  bottom: heightRatio(size: 12, context: context),
                  right: widthRatio(size: 17, context: context),
                  left: widthRatio(size: 12, context: context),
                  top: heightRatio(size: 4, context: context),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: widthRatio(size: 2, context: context),
                                right: widthRatio(size: 5, context: context),
                              ),
                              color: Colors.transparent,
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: heightRatio(size: 22, context: context),
                                  color: whiteColor),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(
                              width: widthRatio(size: 8, context: context)),
                          Expanded(
                            child: Text(
                              "addToOrder".tr(),
                              style: appLabelTextStyle(
                                color: Colors.white,
                                fontSize:
                                    heightRatio(size: 22, context: context),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                        heightRatio(size: 15, context: context)),
                    topLeft: Radius.circular(
                        heightRatio(size: 15, context: context)),
                  ),
                  child: Container(
                    color: whiteColor,
                    child: Builder(builder: (context) {
                      if (_assortments.isEmpty) {
                        context.read<AssortmentsModel>().loadAssortments();
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(mainColor),
                          ),
                        );
                      }
                      return GridView.builder(
                        cacheExtent: 50,
                        padding: EdgeInsets.only(
                          top: heightRatio(size: 16, context: context),
                          left: widthRatio(size: 16, context: context),
                          right: widthRatio(size: 16, context: context),
                        ),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: screenWidth <= 385
                              ? screenWidth <= 34
                                  ? 0.75
                                  : 0.64
                              : 0.61,
                          crossAxisSpacing: 12,
                          crossAxisCount: 2,
                        ),
                        itemCount: _assortments.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider(
                            create: (context) => RecommendedProductModel(
                                assortmentsListModel: _assortments[index],
                                basketListBloc:
                                    BlocProvider.of<BasketListBloc>(context)),
                            child: RecommendedProductWidget(),
                          );
                        },
                      );
                    }),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
