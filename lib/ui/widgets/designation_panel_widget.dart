import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

class DesignationsPanelWidget extends StatelessWidget {
  final _state = Get.find<DesignationOnImageState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.grey,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runAlignment: WrapAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
            IconButton(
                onPressed: () {
                  _state.mode = DesignationMode.note;
                },
                icon: const Icon(Icons.arrow_right_alt)),
            IconButton(
                onPressed: () {
                  _state.mode = DesignationMode.dimension;
                },
                icon: const Icon(Icons.open_in_full)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.rtt)),
          ],
        ),
      ),
    );
  }
}
