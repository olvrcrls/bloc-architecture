import 'dart:async';
import 'package:flutter/material.dart';

enum HomeViewState { Busy, DataRetrieved, NoData }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final StreamController<HomeViewState> stateController =
      StreamController<HomeViewState>();

  List<String> listItems;

  @override
  void initState() {
    _getListData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        // The limitation of the FutureBuilder is that
        // it cannot re-run the method data once again.
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getListData();
          },
        ),
        backgroundColor: Colors.grey[900],
        body: StreamBuilder(
            stream: stateController.stream,
            builder: (buildContext, snapshot) {
              if (snapshot.hasError) {
                return _getInformationMessage(snapshot.error);
              }

              if (!snapshot.hasData || snapshot.data == HomeViewState.Busy) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (listItems.length == 0) {
                return _getInformationMessage("No data fetched.");
              }

              return ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (buildContext, index) =>
                    _getListItemUi(index, listItems),
              );
            }));
  }

  Future _getListData(
      {bool hasError = false, bool hasData = true}) async {
    stateController.add(HomeViewState.Busy);
    await Future.delayed(Duration(seconds: 2));
    if (hasError) {
      return stateController.addError("An error has occured please try again.");
    }

    if (hasData) {
      listItems = List<String>.generate(10, (index) => '$index title');
      stateController.add(HomeViewState.DataRetrieved);
    } else {
      return stateController.add(HomeViewState.NoData);
    }
  }

  Widget _getListItemUi(int index, List<String> listItems) {
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.grey[600]),
        child: Center(
            child: Text(listItems[index],
                style: TextStyle(
                  color: Colors.white,
                ))));
  }

  Widget _getInformationMessage(String message) {
    return Center(
      child: Text(message,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.w900, color: Colors.grey[500])),
    );
  }
}
