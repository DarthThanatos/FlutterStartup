import 'package:flutter_app/model/details.dart';

import 'details_view.dart';

class DetailsPresenter{
  DetailsView view;

  void updateView() {
    view.displayDetails(
        Details(description: "This is a description")
    );
  }

}