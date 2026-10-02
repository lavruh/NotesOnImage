import 'dart:ui' as ui;
import 'package:material_ui/material_ui.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/custom_gesture_recognizer.dart';
import 'package:notes_on_image/ui/widgets/designation_panel_widget.dart';
import 'package:zoom_widget/zoom_widget.dart';

class NotesOnImageScreen extends StatelessWidget {
  const NotesOnImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DesignationOnImageScope.of(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fl, result) async {
        bool leavePage = true;
        await state.hasToSaveDialog(
          context,
          onConfirmCallback: () async {
            leavePage = false;
            await state.saveImage();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          onCancelCallback: () => leavePage = false,
        );
        if (leavePage && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Scaffold(
            body: ListenableBuilder(
              listenable: DesignationOnImageScope.of(context),
              builder: (context, _) {
                final state = DesignationOnImageScope.of(context);
                Widget child = const Center(child: CircularProgressIndicator());

                if (state.image != null && state.isBusy == false) {
                  final imagePainter = CustomPaint(
                    painter: ImagePainter(state),
                    child: Container(),
                  );

                  Widget eventHandler = RawGestureDetector(
                    gestures: <Type, GestureRecognizerFactory>{
                      CustomPanGestureRecognizer:
                          GestureRecognizerFactoryWithHandlers<
                              CustomPanGestureRecognizer>(
                        () => CustomPanGestureRecognizer(
                          onPanDown: (Offset details) {
                            state.panDown(context, details);
                            return true;
                          },
                          onPanUpdate: (details) =>
                              state.updatePoint(details.localPosition),
                          onPanEnd: (details) => state.finishDrawing(),
                        ),
                        (CustomPanGestureRecognizer instance) {},
                      ),
                    },
                    child: imagePainter,
                  );

                  child = Zoom(
                    initTotalZoomOut: true,
                    maxZoomHeight: state.image!.height.toDouble(),
                    maxZoomWidth: state.image!.width.toDouble(),
                    child: eventHandler,
                  );
                }

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: child,
                );
              },
            ),
          ),
          const DesignationsPanelWidget(),
        ],
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final DesignationOnImageState _state;

  ImagePainter(this._state);

  @override
  void paint(Canvas canvas, Size size) {
    ui.Image? img = _state.image;
    if (img != null) {
      canvas.drawImage(img, const Offset(0, 0), Paint());
    }
    final imgSize = _state.imageSize;
    for (Designation o in _state.objects.values) {
      o.updateStrokeWidth(imgSize);
      o.draw(canvas);
    }
    if (_state.objToEdit != null) {
      _state.objToEdit!.updateStrokeWidth(imgSize);
      _state.objToEdit!.draw(canvas);
    }
    _state.imageSize = size;
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) {
    _state.updateCursorPosition(position);
    return _state.isPressed || _state.isNewObj || _state.isObjTouched(position);
  }
}
