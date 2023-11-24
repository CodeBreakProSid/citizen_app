import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/camera_controller.dart';

class CameraMain extends StatefulWidget {
  const CameraMain({super.key});

  @override
  State<CameraMain> createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraController>();

    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: camera.CameraPreview(controller.cameraController),
            ),
          ),
          Container(
            width: Get.width,
            height: 120.sp,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                GetBuilder<CameraController>(
                  builder: (_) {
                    if (_.isPhotoTaken) {
                      return Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 4,
                              spreadRadius: -2,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: RawMaterialButton(
                          onPressed: () => _.retake(),
                          splashColor: Colors.grey,
                          shape: const CircleBorder(),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                const Expanded(flex: 2, child: SizedBox()),
                GetBuilder<CameraController>(
                  builder: (_) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _.isTakingImage ? Colors.grey : Colors.white,
                      ),
                      child: RawMaterialButton(
                        onPressed: () {
                          if (!controller.isPhotoTaken) {
                            controller.takePhoto();
                          }
                        },
                        splashColor: Colors.grey,
                        shape: const CircleBorder(),
                        child: _.isTakingImage
                            ? CircularProgressIndicator(
                                color: Colors.grey.shade700,
                                strokeWidth: 3,
                              )
                            : Icon(
                                Icons.camera,
                                color: Colors.black,
                                size: 30.sp,
                              ),
                      ),
                    );
                  },
                ),
                const Expanded(flex: 2, child: SizedBox()),
                GetBuilder<CameraController>(
                  builder: (_) {
                    if (_.isPhotoTaken) {
                      return Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 4,
                              spreadRadius: -2,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: RawMaterialButton(
                          onPressed: () => Navigator.pop(
                            context,
                            controller.image,
                          ),
                          splashColor: Colors.grey,
                          shape: const CircleBorder(),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
