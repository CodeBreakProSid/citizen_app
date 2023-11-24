// ignore_for_file: avoid_print

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/home_controller.dart';
import 'widgets/exit_popup_view.dart';
import 'widgets/home_screen.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
    final PageController pageController = PageController();
    //final controller = Get.find<HomeController>();

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: PageView(
        allowImplicitScrolling: true,
        controller: pageController,
        children: [
          Scaffold(
            floatingActionButton: Builder(
              builder: (context) => FabCircularMenu(
                key: fabKey,
                ringColor: const Color.fromARGB(255, 108, 18, 13),
                ringDiameter: 300.0,
                ringWidth: 130.0,
                fabIconBorder: const CircleBorder(),
                fabOpenColor: Colors.red,
                fabCloseColor: const Color.fromARGB(255, 108, 18, 13),
                fabColor: Colors.white,
                fabOpenIcon: const Icon(Icons.sos, color: Colors.white),
                fabCloseIcon: const Icon(Icons.close, color: Colors.white),
                animationCurve: Curves.bounceOut,
                onDisplayChange: (isOpen) {
                  print('info');
                },
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () async {
                      final call = Uri.parse('tel:112');
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        throw 'Could not launch $call';
                      }
                    },
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24.0),
                    child: const Icon(Icons.call, color: Colors.white),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor:Colors.white,
                            title: const Text(
                              'Emergency SOS',
                              textAlign: TextAlign.center,
                            ),
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                FormBuilder(
                                  key: controller.sosMessageFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FormBuilderTextField(
                                        name: 'sosMessage',
                                        maxLines: 5,
                                        initialValue: '',
                                        decoration: const InputDecoration(
                                          labelText: 'SOS Message',
                                          border: OutlineInputBorder(
                                            borderRadius: CIRCULAR_BORDER,
                                          ),
                                          helperText:
                                              '(Give us a short information)',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some info !...';
                                          }

                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                const Color(0xFF008585),
                                              ),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.h,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controller.sosMessageFormKey
                                                  .currentState!
                                                  .validate()) {
                                                controller.submitSosMessage();
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                const Color(0xFF008585),
                                              ),
                                            ),
                                            child: const Text(
                                              'Send',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24.0),
                    child: const Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            body: FutureBuilder<bool>(
              future: controller.isDataLoaded,
              initialData: false,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(child: shimmerLoaderHome());
                  case ConnectionState.done:
                    {
                      return (snapshot.hasData && snapshot.data!)
                          ? const HomeScreen()
                          : Center(child: shimmerLoaderHome());
                    }

                  default:
                    return Center(child: shimmerLoaderHome());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
