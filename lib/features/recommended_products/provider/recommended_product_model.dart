import 'package:flutter/widgets.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/services/services.dart';

class RecommendedProductModel with ChangeNotifier {
  final AssortmentsListModel assortmentsListModel;
  final BasketListBloc basketListBloc;

  RecommendedProductModel(
      {required this.assortmentsListModel, required this.basketListBloc});

  Future<void> addOrRemoveFromBasket() async {
    if (!assortmentsListModel.isbasketAdding) {
      await _addToBasket();
    } else {
      await _removeFromBasket();
    }
  }

  Future<void> _addToBasket() async {
    assortmentsListModel.isbasketAdding = true;
    notifyListeners();

    if (assortmentsListModel.assortmentUnitId != "kilogram") {
      if (assortmentsListModel.quantityInClientCart! <
          assortmentsListModel.productsQuantity) {
        assortmentsListModel.quantityInClientCart =
            assortmentsListModel.quantityInClientCart! + 1;
        if (await BasketProvider().updateProductInBasket(
            productUuid: assortmentsListModel.uuid,
            quantity: assortmentsListModel.assortmentUnitId != "kilogram"
                ? assortmentsListModel.quantityInClientCart
                : assortmentsListModel.quantityInClientCart)) {
          basketListBloc.add(BasketLoadEvent());
        }
      }
    } else {
      double weight = double.tryParse(assortmentsListModel.weight!) ?? 0.0;
      double weightInKg = weight / 1000;
      if (assortmentsListModel.quantityInClientCart! <
          assortmentsListModel.productsQuantity) {
        assortmentsListModel.quantityInClientCart =
            assortmentsListModel.quantityInClientCart! + weightInKg;
        if (await BasketProvider().updateProductInBasket(
            productUuid: assortmentsListModel.uuid,
            quantity: assortmentsListModel.quantityInClientCart)) {
          basketListBloc.add(BasketLoadEvent());
        }
      }
    }
  }

  Future<void> _removeFromBasket() async {
    assortmentsListModel.isbasketAdding = false;
    notifyListeners();

    if (assortmentsListModel.assortmentUnitId != "kilogram") {
      assortmentsListModel.quantityInClientCart =
          assortmentsListModel.quantityInClientCart! - 1;
      if (assortmentsListModel.quantityInClientCart != null &&
          assortmentsListModel.quantityInClientCart! <= 0) {
        if (await BasketProvider()
            .reomoveProductFromBasket(assortmentsListModel.uuid!)) {
          basketListBloc.add(BasketLoadEvent());
        }
      }
      if (await BasketProvider().updateProductInBasket(
          productUuid: assortmentsListModel.uuid,
          quantity: assortmentsListModel.quantityInClientCart)) {
        basketListBloc.add(BasketLoadEvent());
      }
    } else {
      double weight = double.tryParse(assortmentsListModel.weight!) ?? 0.0;
      double weightInKg = weight / 1000;

      assortmentsListModel.quantityInClientCart =
          assortmentsListModel.quantityInClientCart! - weightInKg;
      if (assortmentsListModel.quantityInClientCart! <= 0) {
        if (await BasketProvider()
            .reomoveProductFromBasket(assortmentsListModel.uuid!)) {
          basketListBloc.add(BasketLoadEvent());
        }
      } else if (await BasketProvider().updateProductInBasket(
          productUuid: assortmentsListModel.uuid,
          quantity: assortmentsListModel.quantityInClientCart)) {
        basketListBloc.add(BasketLoadEvent());
      }
    }
  }
}
