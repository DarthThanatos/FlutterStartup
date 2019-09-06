import 'package:chopper/chopper.dart';
import 'package:dependencies_flutter/dependencies_flutter.dart';
import 'package:flutter/material.dart';
import "package:dependencies/dependencies.dart";
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/service/chat_service.dart';
import 'package:built_collection/built_collection.dart';

class ChatPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ChatPageState();

}

class ChatPageState extends State<ChatPage> with InjectorWidgetMixin{

  @override
  Widget buildWithInjector(BuildContext context, Injector injector) {
    final chatService = injector.get<ChatService>();
    return Scaffold(
        appBar: _appBar(),
        body: Column(
            children: <Widget>[
              _futureInt(chatService),
              _futureIntList(chatService),
              _futureChatsList(chatService),
            ],
          ),
    );
  }

  FutureBuilder<Response> _futureChatsList(ChatService chatService) =>
    _futureChatServiceHandler<BuiltList<BuiltChat>>(chatService, chatService.getAllChats, _body);

  FutureBuilder<Response> _futureInt(ChatService chatService) =>
    _futureChatServiceHandler(chatService, chatService.getTestInt, _testText);

  FutureBuilder<Response> _futureIntList(ChatService chatService) =>
      _futureChatServiceHandler(chatService, chatService.getTestIntList, _testText);

  FutureBuilder<Response> _futureChatServiceHandler<T>(ChatService chatService, Future<Response<T>> Function() getter, Widget Function(T) onLoaded) =>
      FutureBuilder<Response>(
          future: getter(),
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.hasError) {
              return _ErrorMessage(error: snapshot.error.toString());
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return _LoadingMessage();
            }
            if (snapshot.hasData) {
              return onLoaded(snapshot.data.body);
            }
            if (snapshot.data.body.isEmpty) {
              return _EmptyMessage();
            }
            return _LoadingMessage();
          }
      );


  Widget _appBar() =>
      AppBar(
        title: Text("Chat space"),
      );

  Widget _body(BuiltList<BuiltChat> chats) =>
      Container(
        height: 50,
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            return Text("Chat with id: ${chats[index].chatId}");
          },
        ),
      );

  Widget _testText<T>(T test) =>
      Text("Test: ${test.toString()}");
}

class _Centered extends StatelessWidget {
  final Widget top;
  final Widget bottom;

  const _Centered({Key key, this.top, this.bottom}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            top,
            Container(
                height: 30
            ),
            bottom
          ],
        )
    );
  }
}

class _LoadingMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Centered(
      top: CircularProgressIndicator(),
      bottom: Text('Loading...'),
    );
  }

}

class _EmptyMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Centered(
        top: Icon(Icons.info),
        bottom: Text("No posts to show.")
    );
  }

}

class _ErrorMessage extends StatelessWidget {
  final String error;

  _ErrorMessage({@required this.error});

  @override
  Widget build(BuildContext context) {
    return _Centered(
        top: Icon(Icons.error),
        bottom: Text('There was an error: $error')
    );
  }

}
