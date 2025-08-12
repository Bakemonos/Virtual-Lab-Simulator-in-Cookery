import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/components/custom_dalog.dart';
import 'package:virtual_lab/components/custom_svg.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/equipments.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/effects.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyPlatingUI extends StatefulWidget {
  const MyPlatingUI({super.key});

  @override
  State<MyPlatingUI> createState() => _MyPlatingUIState();
}

class _MyPlatingUIState extends State<MyPlatingUI> {
  final controller = AppController.instance;
  final db = ApiServices.instance;
  final GlobalKey _repaintKey = GlobalKey();
  List<_DraggableItem> items = [];
  Uint8List? capturedImageBytes;

  @override
  void dispose() {
    controller.platingOptionToggle.value = false;
    controller.removeToggle.value = false;
    super.dispose();
  }

  Future<void> _capturePlatingImage() async {
    try {
      final boundaryContext = _repaintKey.currentContext;
      if (boundaryContext == null) return;

      final boundary = boundaryContext.findRenderObject();
      if (boundary == null || boundary is! RenderRepaintBoundary) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        setState(() {
          capturedImageBytes = pngBytes;
        });
        debugPrint("Screenshot captured in memory.");
      }
    } catch (e) {
      debugPrint('Screenshot error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.exitDialog(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: double.infinity,
                        height: 500.h,
                        decoration: controller.designUI(),
                        child: DragTarget<_DraggableItem>(
                          onAcceptWithDetails: (details) {
                            final renderObject = _repaintKey.currentContext?.findRenderObject() as RenderBox?;
                            if (renderObject != null) {
                              final localPos = renderObject.globalToLocal(details.offset);

                              final containerSize = renderObject.size;
                              final itemWidth = 80.w * details.data.scale;
                              final itemHeight = 80.h * details.data.scale;

                              final clampedX = localPos.dx.clamp(0.0, containerSize.width - itemWidth);
                              final clampedY = localPos.dy.clamp(0.0, containerSize.height - itemHeight);

                              setState(() {
                                final existingIndex = items.indexWhere((i) => i.id == details.data.id);
                                if (existingIndex != -1) {
                                  final updated = items[existingIndex].copyWith(offset: Offset(clampedX, clampedY));
                                  items.removeAt(existingIndex);
                                  items.add(updated);
                                } else {
                                  items.add(details.data.copyWith(offset: Offset(clampedX, clampedY)));
                                }
                              });
                            }
                          },

                          builder: (context, candidateData, rejectedData) {
                            return Stack(
                              children: items.asMap().entries.map((entry) => _buildDraggable(entry.key)).toList(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Obx(() => controller.hiderToggle.value? SizedBox.shrink() : 
                  (controller.platingOptionToggle.value ? platingOption(context) : platingMenu(context))),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Obx(()=> controller.hiderToggle.value ? SizedBox.shrink() : Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(width: 8.w, color: backgroundColor),
          ),
          child: GestureDetector(
            onTap: () {
              SoundEffects.playEffect();
              quickAlertDialog(
                context: context,
                type: QuickAlertType.warning,
                title: 'Are you sure?',
                message: 'This will reset your plating',
                confirmBtnText: 'Yes',
                barrierDismissible: true,
                showCancelBtn: true,
                onConfirmBtnTap: () {
                  context.go(Routes.playUI);
                },
              );
            },
            child: SizedBox(
              height: 48.h,
              child: AspectRatio(
                aspectRatio: 1,
                child: MySvgPicture(path: menu),
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget platingMenu(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 24.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            controller.repeatedIconButton(
              label: 'Garnish',
              path: garnish,
              onPressed: () {
                controller.selectedOption.value = 'garnish';
                controller.platingOptionToggler();
              },
            ),
            controller.repeatedIconButton(
              label: 'Plating Tools',
              path: platingTool,
              onPressed: () {
                controller.selectedOption.value = 'tools';
                controller.platingOptionToggler();
              },
            ),
            controller.repeatedIconButton(
              label: 'Dish',
              path: dish,
              onPressed: () {
                controller.selectedOption.value = 'dish';
                controller.platingOptionToggler();
              },
            ),
            controller.repeatedIconButton(
              label: 'Submit',
              path: plating,
              onPressed: () async {
                if (controller.tap) return;
                controller.tap = true;
                controller.hiderToggler();
                await submitPlating(context);
                controller.tap = false; 
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget platingOption(BuildContext context) {
    final List<dynamic> sourceList;

    switch (controller.selectedOption.value) {
      case 'garnish':
        sourceList = garnishList;
        break;
      case 'tools':
        sourceList = platngToolList;
        break;
      default:
        sourceList = controller.submittedCocList;
        break;
    }

    return SizedBox(
      height: 80.h,
      child: Row(
        spacing: 8.w,
        children: [
          repeatedButton(
            image: plating,
            onPressed: controller.platingOptionToggler,
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: sourceList.length,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                var data = sourceList[index];

                final newItem = _DraggableItem(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: data.name,
                  imageUrl: data.image,
                  offset: Offset.zero,
                  side: controller.selectedOption.value,
                  scale: 1.0,
                );

                return LongPressDraggable<_DraggableItem>(
                  data: newItem,
                  feedback: SizedBox(
                    width: 80.w * newItem.scale,
                    height: 80.h * newItem.scale,
                    child: CachedNetworkImage(
                      imageUrl: data.image,
                      placeholder: (context, url) => ShimmerSkeletonLoader(),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: lightGridColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: CachedNetworkImage(
                            imageUrl: data.image,
                            placeholder: (context, url) => ShimmerSkeletonLoader(),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: lightBrown.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.r),
                              bottomRight: Radius.circular(8.r),
                            ),
                          ),
                          child: MyText(
                            text: data.name,
                            textAlign: TextAlign.center,
                            color: textLight,
                            size: 16.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() => repeatedButton(
                image: controller.removeToggle.value ? remove : dontRemove,
                onPressed: controller.removeToggler,
              ))
        ],
      ),
    );
  }

  Widget repeatedButton({required void Function()? onPressed, required String image}) {
    return SizedBox(
      height: 80.h,
      child: AspectRatio(
        aspectRatio: 1,
        child: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.brown.withValues(alpha: 0.2);
              }
              return backgroundColor.withValues(alpha: 0.8);
            }),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: BorderSide(color: darkBrown, width: 2.w),
              ),
            ),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            overlayColor: WidgetStateProperty.all(Colors.brown.withValues(alpha: 0.1)),
          ),
          icon: Padding(
            padding: EdgeInsets.all(8.w),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) => ShimmerSkeletonLoader(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildDraggable(int index) {
    final item = items[index];
    return Positioned(
      left: item.offset.dx,
      top: item.offset.dy,
      child: Draggable<_DraggableItem>(
        data: item,
        feedback: _buildImage(item),
        childWhenDragging: Opacity(opacity: 0.4, child: _buildImage(item)),
        onDragEnd: (details) {
          final context = _repaintKey.currentContext;
          if (context == null) return;

          final renderObject = context.findRenderObject();
          if (renderObject == null || renderObject is! RenderBox) return;

          final localOffset = renderObject.globalToLocal(details.offset);

          final containerSize = renderObject.size;
          final itemWidth = 80.w * item.scale;
          final itemHeight = 80.h * item.scale;

          final clampedX = localOffset.dx.clamp(0.0, containerSize.width - itemWidth);
          final clampedY = localOffset.dy.clamp(0.0, containerSize.height - itemHeight);

          setState(() {
            final foundIndex = items.indexWhere((i) => i.id == item.id);
            if (foundIndex != -1) {
              // Update position
              final updated = items[foundIndex].copyWith(offset: Offset(clampedX, clampedY));
              // Remove and re-add to bring it to front
              items.removeAt(foundIndex);
              items.add(updated);
            }
          });
        },
        child: _buildImage(item),
      ),
    );
  }

  Widget _buildImage(_DraggableItem item) {
    return GestureDetector(
      onTap: () {
        if (controller.removeToggle.value) {
          removeItem(item);
        } else {
          _showScaleSlider(item);
        }
      },
      child: SizedBox(
        width: 80.w * item.scale,
        height: 80.h * item.scale,
        child: CachedNetworkImage(
          imageUrl: item.imageUrl,
          placeholder: (context, url) => const ShimmerLightLoader(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> submitPlating(BuildContext context) async {
    await _capturePlatingImage();
    if (capturedImageBytes != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator(color: textLight)),
      );
      final uploadedUrl = await db.uploadImageToCloudinary(capturedImageBytes!);
      if (context.mounted) context.pop();
      if (uploadedUrl != null) {
        controller.platingImageUrl.value = uploadedUrl;

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: MyText(text: 'Preview Uploaded Image', fontWeight: FontWeight.w500),
              content: CachedNetworkImage(
                imageUrl: uploadedUrl,
                placeholder: (context, url) => const ShimmerSkeletonLoader(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (controller.tap) return;
                    controller.tap = true;
                    controller.hiderToggler();
                    await db.submitCoc(context);
                    controller.tap = false; 
                  },
                  child: MyText(text: 'Confirm', fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () {
                    controller.hiderToggler(); 
                    context.pop();
                  },
                  child: MyText(text: 'Close', fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        }
      } else {
        debugPrint('Image upload failed');
        if (context.mounted) {
          controller.showFloatingSnackbar(
            context: context,
            message: 'Failed to upload image',
          );
        }
      }
    }
  }

  void removeItem(_DraggableItem item) {
    setState(() {
      items.removeWhere((i) => i.id == item.id);
    });
  }

  void _showScaleSlider(_DraggableItem item) {
    double currentScale = item.scale;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(text: 'Adjust Size', fontWeight: FontWeight.w500),
                Slider(
                  value: currentScale,
                  min: 0.5,
                  max: 2.0,
                  divisions: 30,
                  label: "${(currentScale * 100).toInt()}%",
                  onChanged: (value) {
                    setModalState(() => currentScale = value);
                    setState(() {
                      final idx = items.indexWhere((i) => i.id == item.id);
                      if (idx != -1) {
                        items[idx] = items[idx].copyWith(scale: value);
                      }
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: MyText(text: 'Done', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class _DraggableItem {
  final String id;
  final String name;
  final String imageUrl;
  final String side;
  final Offset offset;
  final double scale;

  _DraggableItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.offset,
    required this.side,
    this.scale = 1.0,
  });

  _DraggableItem copyWith({
    String? id,
    Offset? offset,
    double? scale,
  }) {
    return _DraggableItem(
      id: id ?? this.id,
      name: name,
      imageUrl: imageUrl,
      offset: offset ?? this.offset,
      side: side,
      scale: scale ?? this.scale,
    );
  }
}
