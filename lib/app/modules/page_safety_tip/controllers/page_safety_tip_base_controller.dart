import 'package:get/get.dart';

import '../../../data/safety_tip.dart';

class PageSafetyTipBaseController extends GetxController {
  late Map<String, dynamic> apiResponse;

  List<SafetyTip> _listOfSafetyTip = [];
  List<SafetyTip> _initialListOfSafety = [];
  List<SafetyTip> _moreListOfSafety = [];

  late final Future<bool> isDataLoaded;
  bool _noMoreSafety = false;

  bool _isSafetyTipListLoading = false;
  bool _isMoreSafetyTipListLoading = false;
  int notificationToShow = 24;

  bool get isSafetyTipListLoading => _isSafetyTipListLoading;
  set isSafetyTipListLoading(bool v) => {_isSafetyTipListLoading = v, update()};

  List<SafetyTip> get initialListOfSafety => _initialListOfSafety;
  set initialListOfSafety(List<SafetyTip> v) =>
      {_initialListOfSafety = v, update()};

  List<SafetyTip> get listOfSafetyTip => _listOfSafetyTip;
  set listOfSafetyTip(List<SafetyTip> v) => {_listOfSafetyTip = v, update()};

  bool get noMoreSafety => _noMoreSafety;
  set noMoreSafety(bool v) => {_noMoreSafety = v, update()};

  bool get isMoreSafetyTipListLoading => _isMoreSafetyTipListLoading;
  set isMoreSafetyTipListLoading(bool v) =>
      {_isMoreSafetyTipListLoading = v, update()};

  List<SafetyTip> get moreListOfSafety => _moreListOfSafety;
  set moreListOfSafety(List<SafetyTip> v) => {_moreListOfSafety = v, update()};
}
