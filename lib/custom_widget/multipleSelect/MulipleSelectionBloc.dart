import 'dart:async';

import 'package:rxdart/subjects.dart';

class MultipleSelectionBloc {
  StreamController<List<dynamic>> selectedItemController =
      BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get selectionStream => selectedItemController.stream;
}
