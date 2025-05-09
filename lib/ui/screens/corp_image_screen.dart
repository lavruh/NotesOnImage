import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:notes_on_image/utils/converter.dart';

class CorpImageScreen extends StatefulWidget {
  final String title;
  final Image image;

  const CorpImageScreen({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  State<CorpImageScreen> createState() => _CorpImageScreenState();
}

class _CorpImageScreenState extends State<CorpImageScreen> {
  final controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CropImage(
          controller: controller,
          image: widget.image,
          paddingSize: 25.0,
          alwaysMove: true,
          minimumImageSize: 50,
          maximumImageSize: 3500,
        ),
      ),
      bottomNavigationBar: _buildButtons(),
    );
  }

  Widget _buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
            onPressed: _rotateLeft,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
            onPressed: _rotateRight,
          ),
          TextButton(
            onPressed: _finished,
            child: const Text('Done'),
          ),
        ],
      );

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Future<void> _finished() async {
    final c = context;
    final image = await controller.croppedBitmap();
    final r = await imageToUint8List(image);
    if (c.mounted) Navigator.of(c).pop(r);
  }
}
