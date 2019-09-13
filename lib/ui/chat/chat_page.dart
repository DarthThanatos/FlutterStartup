
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/ui/chat/comment_input.dart';
import 'package:flutter_app/ui/chat/root_comment_button_section.dart';
import 'package:flutter_app/util/list-util.dart';
import 'package:inject/inject.dart';

import 'image_section.dart';
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

  ScrollController _scrollController;
  ScrollController _nestedScrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _nestedScrollController = ScrollController();
    widget.presenter.attachView(this);
    widget.presenter.downloadChat(666);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nestedScrollController.dispose();
    widget.presenter.detachView();
    super.dispose();
  }

  // to prevent invoking build() on tapping the text field
  // https://github.com/flutter/flutter/issues/36271
  var _bottomSheetWidget = BottomSheetWidget();

  @override
  Widget build(BuildContext context) {
    return
      chat == null
          ? _LoadingMessage()
          : Scaffold(
            appBar: _appBar(),
            bottomSheet:
              _bottomSheetWidget,
            body:
                ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  children:
                      ListUtil.mergedList(_rootQuestionSection(), [_nestedCommentListView()])
                ),
            floatingActionButton: FloatingActionButton(
              onPressed: _scrollToTop,
              tooltip: 'scroll top',
              child: Icon(Icons.keyboard_arrow_up),
            )
          );
  }

  void _scrollToTop(){
    _scrollToTopHaving(_scrollController);
    _scrollToTopHaving(_nestedScrollController);
  }

  void _scrollToTopHaving(ScrollController ctrl) {
    ctrl.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  List<Widget> _commentsSection(){
    final flattenedComments = widget.presenter.flattenChats(chat);
    final List<Widget> res = [];
    flattenedComments.forEach((c) => res.addAll(CommentItemPage.getViews(c)));
    res.add(Container(height: 100));
    return res;
  }

  Widget _nestedCommentListView() =>
        Container(
            height: 400,
            child: NestedScrollView(
              controller: _nestedScrollController,
              headerSliverBuilder: (BuildContext context, bool b){
                return [
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: false,
                      title: MediaQuery.removePadding(
                        removeLeft: true,
                        child: _commentsSummary(),
                        context: context,
                      ),
                      pinned: false,
                      automaticallyImplyLeading: false,
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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

  List<Widget> _rootQuestionSection() =>
    [
      _chatRootHeader(),
      _rootComment(),
      _maybeImgSection(),
      SizedBox(height: 25),
      RootCommentButtonSection()
    ];

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
       child:
        Text(
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
      bottom: Text('Loading...', style: TextStyle(decoration: TextDecoration.none)),
    );
  }

}


class BottomSheetWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context)=>
    Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(),
        CommentInput(),
      ],
    );

}
