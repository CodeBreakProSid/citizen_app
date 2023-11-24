import 'package:get/get.dart';

import '../../../data/awareness_class.dart';

class PageAwarenessClassBaseController extends GetxController {
  late Map<String, dynamic> apiResponse;

  List<AwarenessClass> _initialListOfAwareness = [];
  List<AwarenessClass> _listOfAwareness = [];
  List<AwarenessClass> _moreListOfAwareness = [];

  bool _noMoreAwareness = false;
  int notificationToShow = 24;

  late List<AwarenessClass> listOfAwarenessClass;
  late final Future<bool> isDataLoaded;
  bool _isAwarenessClassListLoading = false;
  bool _isMoreAwarenessClassListLoading = false;

  List<AwarenessClass> get initialListOfAwareness => _initialListOfAwareness;
  set initialListOfAwareness(List<AwarenessClass> v) =>
      {_initialListOfAwareness = v, update()};

  bool get isAwarenessClassListLoading => _isAwarenessClassListLoading;
  set isAwarenessClassListLoading(bool v) =>
      {_isAwarenessClassListLoading = v, update()};

  List<AwarenessClass> get listOfAwareness => _listOfAwareness;
  set listOfAwareness(List<AwarenessClass> v) =>
      {_listOfAwareness = v, update()};

  bool get noMoreAwareness => _noMoreAwareness;
  set noMoreAwareness(bool v) => {_noMoreAwareness = v, update()};

  bool get isMoreAwarenessClassListLoading => _isMoreAwarenessClassListLoading;
  set isMoreAwarenessClassListLoading(bool v) =>
      {_isMoreAwarenessClassListLoading = v, update()};

  List<AwarenessClass> get moreListOfAwareness => _moreListOfAwareness;
  set moreListOfAwareness(List<AwarenessClass> v) =>
      {_moreListOfAwareness = v, update()};
}
