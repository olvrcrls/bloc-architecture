import 'package:flutter/material.dart';
import 'package:bloc_architecture/events/home_event.dart';
import 'package:bloc_architecture/models/home_model.dart';
import 'package:bloc_architecture/states/home_state.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final model = HomeModel();
  @override
  void initState() {
    model.dispatch(FetchData());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            model.dispatch(FetchData(hasData: false));
          },
        ),
        backgroundColor: Colors.grey[900],
        body: StreamBuilder(
            stream: model.homeState,
            builder: (buildContext, snapshot) {
              if (snapshot.hasError) {
                return _getInformationMessage(snapshot.error);
              }

              var homeState = snapshot.data;
              print('Home State: $homeState');

              if (!snapshot.hasData || homeState is BusyHomeState) {
                return Center(child: CircularProgressIndicator());
              }

              if (homeState is DataFetchedHomeState) {
                if (!homeState.hasData) {
                  return _getInformationMessage("No data found on your account.\nAdd something and come back.");
                }
              }
              return ListView.builder(
                itemCount: homeState.data.length,
                itemBuilder: (buildContext, index) =>
                    _getListItemUi(index, homeState.data),
              );
            }));
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
