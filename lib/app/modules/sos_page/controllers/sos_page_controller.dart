import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SosPageController extends GetxController {  

  Future<void> sosPhonecalls() async {
    final url = Uri.parse('tel:112');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
