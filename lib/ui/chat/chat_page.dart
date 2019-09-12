
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:built_collection/built_collection.dart';
import 'package:inject/inject.dart';

import 'ImageSection.dart';
import 'comment_item.dart';
import 'contract.dart';

@provide
class ChatPage extends StatefulWidget {

  final ChatPresenter presenter;

  ChatPage(this.presenter);

  @override
  State<StatefulWidget> createState() => ChatPageState();

}

class ChatPageState extends State<ChatPage> implements ChatView{

  BuiltChat chat;

  @override
  void initState() {
    super.initState();
    widget.presenter.attachView(this);
    widget.presenter.downloadChat(666);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:
        chat == null ? _LoadingMessage() :
            ListView(
              shrinkWrap: true,
              children:
                  [
                    _rootQuestionSection(),
                    SizedBox(height: 10),
                    _commentsSummary(),
                    _nestedCommentListView()
                  ]
          ),

    );
  }


  List<Widget> _commentsSection(){
    final flattenedComments = widget.presenter.flattenChats(chat);
    final List<Widget> res = [];
    flattenedComments.forEach((c) => res.addAll(CommentItemPage.getViews(c)));
    return res;
  }

  Widget _nestedCommentListView() =>
    Container(
      height: 400,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool b){
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              leading: Container(width: 10),
//              title: _commentsSummary(),
              pinned: false,
              flexibleSpace:
                FlexibleSpaceBar()
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: _commentsSection()
          ),
        ),
      )
    );
  
  Widget _commentsSummary() =>
    Row(
      children: <Widget>[
        SizedBox(width: 10),
        _commentIcon(),
        SizedBox(width: 10),
        _commentsAmount()
      ],
    );

  Widget _commentIcon() =>
    Icon(Icons.mode_comment, color: Colors.black,);

  Widget _commentsAmount() =>
    Text(
      "${chat.commentsAmount} komentarz(y)",
      style: TextStyle(color: Colors.black, fontSize: 15),
    );

  Widget _appBar() =>
      AppBar(
        centerTitle: true,
        title: Text("Dyskusja"),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.favorite),
            onPressed: () {},
          ),
          IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {},
          )
        ],
      );

  Widget _rootQuestionSection() =>
      Container(
        height: 400.0,
        child: Column(
          children: <Widget>[
            _chatRootHeader(),
            _rootComment(),
            _maybeImgSection(),
          ],
        )
      );

  Widget _maybeImgSection() {
    final fileInfo = chat.chatRoot.fileInfo;
    return fileInfo == null ? Container() : ImageSection(fileInfo: fileInfo);
  }

  Widget _chatRootHeader() =>
    Container(
      height: 35,
      color: Color(0x0F000000),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          _authorImg(chat.chatRoot.user.avatarUrl),
          SizedBox(width: 10),
          _authorName(),
          _expandedDiscussionCreationTime(),
          SizedBox(width: 10)
        ],
      ),
    );


  Widget _expandedDiscussionCreationTime() =>
    Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          chat.chatRoot.creationTime,
          style: TextStyle(fontSize: 16)
        ),
      ),
    );

  Widget _authorName() =>
    Text(
      chat.chatRoot.user.userName,
      style: TextStyle(fontSize: 16)
    );

  Widget _authorImg(String url) =>
      Container(
        width: 20,
        height: 20,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.fill
            )
        ),
      );

  Widget _rootComment() =>
     Padding(
       padding: const EdgeInsets.all(12.0),
       child: Text(
         chat.chatRoot.text,
         style: TextStyle(
           fontSize: 22
         )
       ),
     );

  @override
  void displayAllChats(BuiltList<BuiltChat> chats) {
    // TODO: implement displayAllChats
  }

  @override
  void displayChat(BuiltChat chat) {
    print("displaying chat");
    setState(
        (){this.chat = chat;}
    );
  }
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
