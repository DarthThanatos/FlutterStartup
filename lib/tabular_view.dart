import 'package:flutter/material.dart';

import 'details/details_presenter.dart';
import 'details/details_view_screen.dart';

class TabDemo extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => TabDemoState();

}

class TabDemoState extends State<TabDemo> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener((){
      print("Navigating to tab " + _tabController.index.toString());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var yo = DetailsScreen(presenter: DetailsPresenter());
    print(yo == null);
    return Scaffold(
        appBar: AppBar(
          title: Text('Tabs Demo'),
        ),
        body:
        Column(
          children: <Widget>[
            Text('opis produktu'),
            Container(
              color: Colors.blue,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "SZCZEGÓŁY"),
                  Tab(text: "OFERTY"),
                  Tab(text: "DYSKUSJA"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
              controller: _tabController,
                children: [
                  new Text("This is call Tab View"),
                  new Text("This is chat Tab View"),
                  new Text("This is notification Tab View"),
                ])
            )
          ],
        )
    );
  }

}