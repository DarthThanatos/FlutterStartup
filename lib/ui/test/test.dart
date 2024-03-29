import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/service/chat_service.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/di/main_app.dart';
import 'package:inject/inject.dart';

@provide
class TestPage extends StatefulWidget {

  final ChatService chatService;

  TestPage(this.chatService);

  @override
  State<StatefulWidget> createState() => TestPageState();

}

class TestPageState extends State<TestPage>{

  ChatService get chatService => widget.chatService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: <Widget>[
          FlatButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MainContainer.container.fileViewer
                    )
                );
              },
              child: Text("Go to file viewer page")
          ),
          _futureIntList(chatService),
          _futureInt(chatService),
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

  FutureBuilder<Response> _futureChatServiceHandler<T>(
      ChatService chatService,
      Future<Response<T>> Function() getter,
      Widget Function(T) onLoaded
      ) =>
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
