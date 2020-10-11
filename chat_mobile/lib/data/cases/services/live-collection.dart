import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:chat_mobile/data/entities/live-collection-state.dart';

abstract class LiveCollection<T> with ChangeNotifier {

  LiveCollectionState _state = LiveCollectionState.UNKNOWN;

  List<T> _list = [];

  /// unused variable
  List<int> _rage = [0, 10];

  LiveCollectionState get currentState => _state;
  List<T> get list => _list;

  /// reload all collection
  refresh() => loadCollection(load());

  /// load next rage
  loadNext(int begin, int end) {
    if(begin < _rage[0])
      _rage[0] = begin;
    if(end > _rage[1])
      _rage[1] = end;

    _state = LiveCollectionState.LOADING;
    /// start load rage and call add or apply function
    _state = LiveCollectionState.READY;
  }

  @protected Future<List<T>> load();

  /// function load collection
  loadCollection(Future<List<T>> load) async {
    _state = LiveCollectionState.LOADING;
    apply(await load);
  }

  add(List<T> list) {
    _list.addAll(list);
    _state = LiveCollectionState.READY;
    notifyListeners();
  }

  apply(List<T> newData) {
    _list = newData;
    _state = LiveCollectionState.READY;
    notifyListeners();
  }

}