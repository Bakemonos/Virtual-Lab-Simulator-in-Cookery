import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Json/coc1.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyPlatingUI extends StatefulWidget {
  const MyPlatingUI({super.key});

  @override
  State<MyPlatingUI> createState() => _MyPlatingUIState();
}

class _MyPlatingUIState extends State<MyPlatingUI> {
  final controller = AppController.instance;
  final GlobalKey _repaintKey = GlobalKey();

  List<_DraggableItem> items = [];
  Uint8List? capturedImageBytes;
  final int itemCount = 5;

  @override
  void initState() {
    super.initState();
    _generateRandomItemsFromIngredients();
  }

  void _generateRandomItemsFromIngredients() {
    final rand = Random();
    items = ingredientsCOC1.take(itemCount).map((ingredient) {
      double dx = rand.nextDouble() * 250;
      double dy = rand.nextDouble() * 350;
      return _DraggableItem(
        name: ingredient.name,
        imageUrl: ingredient.path,
        offset: Offset(dx, dy),
      );
    }).toList();
  }

  Future<void> _capturePlatingImage() async {
    try {
      final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        setState(() {
          capturedImageBytes = pngBytes;
          debugPrint('\nPICTURE : $pngBytes\n');
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
        if (!didPop) {
          controller.exitDialog(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: Container(
                    width: double.infinity,
                    height: 500.h,
                    decoration: controller.designUI(),
                    child: Stack(
                      children: items.asMap().entries.map((entry) => _buildDraggable(entry.key)).toList(),
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  border: Border.all(width: 8.w, color: backgroundColor),
                ),
                child: controller.floatingButton(
                  context: context,
                  icon: menu,
                  onTap: () {
                    context.pop();
                  },
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: controller.actionButton(
                  text: 'Submit',
                  onPressed: () async {
                    await _capturePlatingImage();

                    if (capturedImageBytes != null && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Preview"),
                          content: Image.memory(capturedImageBytes!),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildDraggable(int index) {
    final item = items[index];
    return Positioned(
      left: item.offset.dx,
      top: item.offset.dy,
      child: Draggable(
        feedback: SizedBox(
          width: 80.w, height: 80.h,
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            placeholder: (context, url) => const ShimmerLightLoader(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.4,
          child: SizedBox(
          width: 80.w, height: 80.h,
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              placeholder: (context, url) => const ShimmerLightLoader(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.contain,
            ),
          ),
        ),
        onDragEnd: (details) {
          final renderBox = _repaintKey.currentContext!.findRenderObject() as RenderBox;
          final localOffset = renderBox.globalToLocal(details.offset);

          setState(() {
            items[index] = item.copyWith(offset: localOffset);
          });
        },
        child: SizedBox(
          width: 80.w, height: 80.h,
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            placeholder: (context, url) => const ShimmerLightLoader(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

}

class _DraggableItem {
  final String name;
  final String imageUrl;
  Offset offset;

  _DraggableItem({required this.name, required this.imageUrl, required this.offset});

  _DraggableItem copyWith({Offset? offset}) {
    return _DraggableItem(
      name: name,
      imageUrl: imageUrl,
      offset: offset ?? this.offset,
    );
  }
}

