import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../controllers/page_incident_train_controller.dart';
import 'page_incident_train_main_view.dart';

class PageIncidentTrainView extends GetView<PageIncidentTrainController> {
  const PageIncidentTrainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incident in train',
          style: appBarTextStyle,
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        shape: appBarShape,
      ),
      body: FutureBuilder<bool>(
        future: controller.isDataLoaded,
        initialData: false,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              {
                return snapshot.hasData && snapshot.data!
                    ? const SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: PageIncidentTrainMainView(),
                      )
                    : const Center(child: CircularProgressIndicator());
              }

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
