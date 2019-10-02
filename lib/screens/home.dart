import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {  
  List<String> _pageData;
  bool get _fetchingData => _pageData == null;

  @override
  initState() {
    // You set condition here if there is data being fetched.
    // or if there is an error occured.
    _getListData().then((data) => setState(() {
      if (data.length == 0) {
        data.add("No data found for your account.");
      }
      _pageData = data;
    })).catchError((error) => setState(() {
      _pageData = [error];
    }));
    super.initState();
  }

  Widget build(BuildContext build) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _fetchingData ? Center(child: CircularProgressIndicator()) : 
      ListView.builder(
        itemCount: _pageData.length,
        itemBuilder: (buildContext, index) => _getListItemUi(index),
      )
    );
  }

  Future<List<String>> _getListData({bool hasError = false, bool hasData = true}) async {
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

  Widget _getListItemUi(int index) {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[600]
      ),
      child: Center(child: Text(_pageData[index], style: TextStyle(color: Colors.white,)))
    );
  }

}