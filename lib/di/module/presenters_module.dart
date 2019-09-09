import 'package:flutter_app/chat/chat_presenter.dart';
import 'package:flutter_app/chat/contract.dart';
import 'package:inject/inject.dart';

@module
class PresentersModule{

  @provide
  ChatPresenter chatPresenter() => ChatPresenterImpl();

}