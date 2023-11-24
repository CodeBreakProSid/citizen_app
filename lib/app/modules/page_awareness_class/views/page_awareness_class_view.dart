import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../controllers/page_awareness_class_controller.dart';
import 'page_awareness_class_main_view.dart';

class PageAwarenessClassView extends GetView<PageAwarenessClassController> {
  const PageAwarenessClassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Awareness class',
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
                        child: PageAwarenessClassMainView(),
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
