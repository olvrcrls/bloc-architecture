import 'package:flutter/material.dart';

class Home extends StatelessWidget {
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
        body: FutureBuilder(
            future: _getListData(hasData: false),
            builder: (buildContext, snapshot) {

              if (snapshot.hasError) {
                return _getInformationMessage(snapshot.error);
              }

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var listItems = snapshot.data;
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

  Future<List<String>> _getListData(
      {bool hasError = false, bool hasData = true}) async {
    await Future.delayed(Duration(seconds: 2));
    if (hasError) {
      return Future.error("An error has occured please try again.");
    }

    if (hasData) {
      return List<String>.generate(10, (index) => '$index title');
    } else {
      return List<String>();
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
