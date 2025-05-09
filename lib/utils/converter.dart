import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as image_util;

Future<Uint8List> imageToUint8List(Image image) async {
  final originalImage = await image.toByteData();
  if (originalImage == null) throw Exception("Image is null");
  final outputImage = image_util.Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: originalImage.buffer,
    order: image_util.ChannelOrder.rgba,
  );
  return image_util.encodeJpg(outputImage);
}