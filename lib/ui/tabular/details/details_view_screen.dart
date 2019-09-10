import 'package:flutter/material.dart';
import 'package:flutter_app/model/details.dart';

import 'details_presenter.dart';
import 'details_view.dart';

class DetailsScreen extends StatefulWidget{

  final DetailsPresenter presenter;

  DetailsScreen({Key key, @required this.presenter}): super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();


}

class _DetailsViewState extends State<DetailsScreen>  implements DetailsView{

  Details _details;

  @override
  void initState(){
    super.initState();
    widget.presenter.view = this;
    widget.presenter.updateView();
  }

  @override
  Widget build(BuildContext context) =>
      Text("No description yet");

  @override
  void displayDetails(Details details) {
    setState((){
      _details = details;
    });
  }

}