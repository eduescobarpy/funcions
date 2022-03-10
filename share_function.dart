import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ShareFunction {
  static Future<void> captureAndSharePng({
    @required GlobalKey widgetKey,
    @required String methodChannel,
  }) async {
    try {
      RenderRepaintBoundary boundary = widgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      final channel = MethodChannel(methodChannel);
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> createImage(Widget widget) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    Size logicalSize = window.physicalSize / window.devicePixelRatio;
    Size imageSize = window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      window: null,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child:widget,
        )
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: imageSize.width / logicalSize.width);
    final ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes);
  }

  static Future<void> createImageFromWidgetAndSharePng({
    @required Widget widget,
    @required String methodChannel,
  }) async {

    await createImage(widget);

    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    Size logicalSize = window.physicalSize / window.devicePixelRatio;
    Size imageSize = window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      window: null,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child:widget,
        )
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: imageSize.width / logicalSize.width);
    final ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes);
    final channel = MethodChannel(methodChannel);
    channel.invokeMethod('shareFile', 'image.png');
  }
}
