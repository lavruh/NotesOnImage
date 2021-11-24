import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:test/test.dart';

main() {
  final state = DesignationOnImageState();
  test("set file path", () {
    final data = [
      ['/root/folder', 'somename', '.jpg'],
      ['/root/folder/dir', '_some000name', '.jpg'],
      ['/root/folder', 'somename_', '.png'],
    ];
    for (var i in data) {
      state.path = '${i[0]}/${i[1]}${i[2]}';
      expect(state.pathBase, i[0]);
      expect(state.fileName, i[1]);
      expect(state.fileExt, i[2]);
    }
  });
}
