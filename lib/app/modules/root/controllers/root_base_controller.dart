import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RootBaseController extends GetxController {
  final int timeInterval  = 5;
  bool _isConnection      = true;
  bool _isLoading         = false;

  late Position?          currentLocation;

  

  bool get isConnection => _isConnection;
  set isConnection(bool v) => {_isConnection = v, update()};

  bool get isLoading => _isLoading;
  set isLoading(bool v) => {_isLoading = v, update()};
}
