import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/repositories/assortments_repository.dart';

class AssortmentsModel with ChangeNotifier {
  List<AssortmentsListModel> _assortments = [];

  List<AssortmentsListModel> get assortments => _assortments;

  void loadAssortments() async {
    _assortments = await AssortmentsRepository(currentPage: 1)
        .getAssortmentsFromRepositoryForPagination();
    final randLength = 3 + Random().nextInt(2);
    if (_assortments.length > randLength) {
      _assortments.shuffle();
      _assortments.removeRange(randLength, _assortments.length);
    }

    notifyListeners();
  }
}
