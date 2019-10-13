import "dart:async";
import 'package:bloc_architecture/events/home_event.dart';
import 'package:bloc_architecture/states/home_state.dart';

class HomeModel {
  final StreamController<HomeState> _stateController =
      StreamController<HomeState>();

  List<String> _listItems;

  // -- Public interface for the home model --

  // Stream that broadcasts the home state.
  Stream<HomeState> get homeState => _stateController.stream;
  void dispatch(HomeEvent event) {
    print("Event dispatched: $event");
    if (event is FetchData) {
      _getListData(hasData: event.hasData, hasError: event.hasError);
    }
  }

  Future _getListData({bool hasError = false, bool hasData = true}) async {
    _stateController.add(BusyHomeState());
    await Future.delayed(Duration(seconds: 2));
    if (hasError) {
      return _stateController
          .addError("An error has occured please try again.");
    }

    if (!hasData) {
      return _stateController.add(DataFetchedHomeState(data: []));
    }
    _listItems = List<String>.generate(10, (index) => '$index title');
    _stateController.add(DataFetchedHomeState(data: _listItems));
  }
}
