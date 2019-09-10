import 'package:flutter_app/api/service/chat_service.dart';
import 'package:inject/inject.dart';

import 'file_viewer_contract.dart';

@provide
class FileViewerPresenterImpl implements FileViewerPresenter{

  final ChatService chatService;
  FileViewerView view;

  FileViewerPresenterImpl(this.chatService);


  @override
  void attachView(FileViewerView view) {
    this.view = view;
  }

  @override
  void detachView() {
    this.view = null;
  }

  @override
  void loadTest() {
    chatService.getTestInt().then(
        (val){
          view.displayTestInt(val.body);
        }
      );
  }

}