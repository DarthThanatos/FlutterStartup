abstract class FileViewerView{

  void displayTestInt(int testInt);

}

abstract class FileViewerPresenter{

  void loadTest();
  void attachView(FileViewerView view);
  void detachView();

}