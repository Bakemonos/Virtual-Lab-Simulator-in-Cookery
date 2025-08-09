import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Json/coc1.dart';
import 'package:virtual_lab/components/custom_svg.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/services/services.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _repaintKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && mounted) {
        final size = renderBox.size;
        _generateAllItems(
          containerWidth: size.width,
          containerHeight: size.height,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.platingOptionToggle.value = false;
    super.dispose();
  }

  void _generateAllItems({required double containerWidth, required double containerHeight}) {
    final rand = Random();
    const double paddingX = 10;
    const double paddingY = 10;
    final double itemWidth = 80.w;
    final double itemHeight = 80.h;

    final double leftBaseX = paddingX;
    final double rightBaseX = containerWidth - itemWidth - paddingX;

    final List<_DraggableItem> newItems = [];

    int totalItems = max(ingredientsCOC1.length, controller.submittedCocList.length);
    double currentY = paddingY;

    for (int i = 0; i < totalItems; i++) {
      if (i < ingredientsCOC1.length) {
        final leftItem = ingredientsCOC1[i];
        newItems.add(
          _DraggableItem(
            name: leftItem.name,
            imageUrl: leftItem.path,
            offset: Offset(
              leftBaseX + rand.nextDouble() * 5, 
              currentY + rand.nextDouble() * 5,
            ),
            side: 'left',
          ),
        );
      }

      if (i < controller.submittedCocList.length) {
        final rightItem = controller.submittedCocList[i];
        newItems.add(
          _DraggableItem(
            name: rightItem.name,
            imageUrl: rightItem.image,
            offset: Offset(
              rightBaseX + rand.nextDouble() * 5,
              currentY + rand.nextDouble() * 5,
            ),
            side: 'right',
          ),
        );
      }

      currentY += itemHeight + paddingY;

      // Clamp to container height
      if (currentY + itemHeight > containerHeight) {
        currentY = paddingY + rand.nextDouble() * 10; // wrap and offset
      }
    }

    setState(() {
      items = newItems;
    });
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
                        child: Stack(
                          children: items.asMap().entries.map((entry) => _buildDraggable(entry.key)).toList(),
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
                child: Obx(()=> controller.platingOptionToggle.value ? platingOption(context) : platingMenu(context))
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(width: 8.w, color: backgroundColor),
          ),
          child: InkWell(
            onTap: () {
              controller.playClickSound();
              context.pop();
            },
            child: SizedBox(
              height: 48.h,
              child: AspectRatio(
                aspectRatio: 1,
                child: MySvgPicture(path: menu),
              ),
            ),
          ),
        ),
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
              label: 'Plates',
              path: equipment, 
              onPressed: controller.platingOptionToggler,
            ),
            controller.repeatedIconButton(
              label: 'Submit',
              path: plating, 
              onPressed: () async => await submitPlating(context),
            ),
            controller.repeatedIconButton(
              label: 'Dish',
              path: equipment, 
              onPressed: controller.platingOptionToggler,
            ),
            
          ],
        ),
      ],
    );
  }

  Widget platingOption(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Row(
        spacing: 8.w,
        children: [
          SizedBox(
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
                    imageUrl: plating,
                    placeholder: (context, url) => ShimmerSkeletonLoader(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.contain,
                  ),
                ),
                onPressed: controller.platingOptionToggler
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: ingredientsCOC1.length,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                var data = ingredientsCOC1[index];
          
                return Stack(
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
                          imageUrl: data.path,
                          placeholder: (context, url) => ShimmerSkeletonLoader(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggable(int index) {
    final item = items[index];
    return Positioned(
      left: item.offset.dx,
      top: item.offset.dy,
      child: Draggable(
        feedback: _buildImage(item),
        childWhenDragging: Opacity(opacity: 0.4, child: _buildImage(item)),
        onDragEnd: (details) {
          final context = _repaintKey.currentContext;
          if (context == null) return;

          final renderObject = context.findRenderObject();
          if (renderObject == null || renderObject is! RenderBox) return;

          final localOffset = renderObject.globalToLocal(details.offset);

          final containerSize = renderObject.size;
          final itemWidth = 80.w;
          final itemHeight = 80.h;

          final clampedX = localOffset.dx.clamp(0.0, containerSize.width - itemWidth);
          final clampedY = localOffset.dy.clamp(0.0, containerSize.height - itemHeight);

          setState(() {
            final draggedItem = items.removeAt(index);
            final updatedItem = draggedItem.copyWith(offset: Offset(clampedX, clampedY));
            items.add(updatedItem);
          });
        },
        child: _buildImage(item),
      ),
    );
  }

  Widget _buildImage(_DraggableItem item) {
    return SizedBox(
      width: 80.w,
      height: 80.h,
      child: CachedNetworkImage(
        imageUrl: item.imageUrl,
        placeholder: (context, url) => const ShimmerLightLoader(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.contain,
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
                    context.go(Routes.playUI);
                    await db.submitCoc();
                  },
                  child: MyText(text: 'Confirm', fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () => context.pop(),
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

}

class _DraggableItem {
  final String name;
  final String imageUrl;
  Offset offset;
  final String side;

  _DraggableItem({
    required this.name,
    required this.imageUrl,
    required this.offset,
    required this.side,
  });

  _DraggableItem copyWith({Offset? offset}) {
    return _DraggableItem(
      name: name,
      imageUrl: imageUrl,
      offset: offset ?? this.offset,
      side: side,
    );
  }
}
