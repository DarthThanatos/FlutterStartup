
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/ui/chat/comment_input.dart';
import 'package:flutter_app/ui/chat/root_comment_button_section.dart';
import 'package:flutter_app/widget/NestedList.dart';
import 'package:inject/inject.dart';

import 'progress_bar.dart';
import 'chat_scroll_navigator.dart';
import 'image_grid_section.dart';
import 'comment_item.dart';
import 'contract.dart';

@provide
class ChatPage extends StatefulWidget {

  final ChatPresenter presenter;

  ChatPage(this.presenter);

  @override
  State<StatefulWidget> createState() => ChatPageState();

}

class ChatPageState extends State<ChatPage> implements ChatView {

  BuiltChat _chat;
  ChatScrollNavigator _chatScrollNavigator;
  ProgressBar _sendingMsgProgressBar;
  bool _cleanInput = false;


  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
    _chatScrollNavigator = ChatScrollNavigator();
    _chatScrollNavigator.initState();
    widget.presenter.attachView(this);
    widget.presenter.downloadChat(666);
  }

  @override
  void dispose() {
    _sendingMsgProgressBar.hide();
    _chatScrollNavigator.dispose();
    widget.presenter.detachView();
    super.dispose();
  }

  // to prevent invoking build() on tapping the text field
  // https://github.com/flutter/flutter/issues/36271
  var _bottomSheetWidget;

  Widget _upToDateBottomSheet(){
    if(_bottomSheetWidget == null){
      _bottomSheetWidget = _newBottomSheet();
    }
    else {
      _bottomSheetWidget =
            !_cleanInput ? _bottomSheetWidget
            : _newBottomSheet();
    }
    _cleanInput = false;
    return _bottomSheetWidget;
  }

  Widget _newBottomSheet() =>
      BottomSheetWidget(
          chatPresenter: widget.presenter
      );

  @override
  Widget build(BuildContext context) {
    return
      _chat == null
          ? _LoadingMessage()
          : Scaffold(
            appBar: _appBar(),
            bottomSheet:
              _upToDateBottomSheet(),
            body:
                ListView(
                  controller: _chatScrollNavigator.outerController(),
                  children:
                    _rootQuestionSection()
                      ..add(SizedBox(height: 10))
                      ..add(_commentsSummary())
                      ..add(Divider())
                      ..add(_nestedCommentListView())
                ),
          );
  }

  Widget _nestedCommentListView() {
    final items = _chat.comments;
    _chatScrollNavigator.triggerNestedScrollBottom();
    return Container(
        height: 400,
        child:
        NestedList(
            body:
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child:
                ListView.builder(
                  controller: _chatScrollNavigator.nestedController(),
                  itemCount: items.length + 2,
                  itemBuilder: (BuildContext context, int index) =>
                      _commentSectionIndexToView(index, items)
                )
            )
        )
    );
  }


  Widget _commentSectionIndexToView(int index, BuiltList<BuiltChatItem> items){
    if(index < items.length)
      return _commentItemPageInstance(index, items);
    if(index == items.length)
      return _moreCommentsButton();
    return Container(height: 100);
  }

  Widget _commentItemPageInstance(int index, BuiltList<BuiltChatItem> items){
    final item = items[index];
    return
      Builder(builder: (BuildContext context) {
        _chatScrollNavigator.triggerLogCommentViewHeight(context, index);
        return CommentItemPage(chatItem: item, chatPresenter: widget.presenter);
      });
  }

  Widget _moreCommentsButton() =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () => widget.presenter.downloadChat(666),
          child: Text("Odśwież komentarze"),
        ),
      ],
    );
  
  Widget _commentsSummary() =>
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
      "${_chat.commentsAmount} komentarz(y)",
      style: TextStyle(color: Colors.black, fontSize: 15),
    );

  Widget _appBar() =>
      AppBar(
        centerTitle: true,
        title: Text("Dyskusja"),
        bottom:
          PreferredSize(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    _chat.title,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            preferredSize: Size(200, 15),
          ),
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
      _imgsGrid(),
      RootCommentButtonSection(rootItem: _chat.chatRoot, chatPresenter: widget.presenter)
    ];

  Widget _imgsGrid() =>
      ImageGridSection(inputMode: false, chatPresenter: widget.presenter, chatItem: _chat.chatRoot);


  Widget _chatRootHeader() =>
    Container(
      height: 35,
      color: Color(0x0F000000),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          _authorImg(_chat.chatRoot.user.avatarUrl),
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
          _chat.chatRoot.creationTime,
          style: TextStyle(fontSize: 16)
        ),
      ),
    );

  Widget _authorName() =>
    Text(
      _chat.chatRoot.user.userName,
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
           _chat.chatRoot.text,
           style: TextStyle(
             fontSize: 22
           )
         ),
     );


  @override
  void displayChat(BuiltChat chat) {
    setState(
        (){
          this._chat = chat;
          _cleanInput = true;
        }
    );
  }

  void _refresh() {
    setState(() {
      _cleanInput = true;
    });
  }

  @override
  void onGotoComment(int index){
    _chatScrollNavigator.goToComment(index);
  }

  @override
  void onImagesChanged() => _refresh();

  @override
  void onRelatedCommentChanged() => _refresh();

  @override
  void showSendingProgressBar() {
    _sendingMsgProgressBar.show(context);
  }

  @override
  void hideSendingProgressBar() {
    _sendingMsgProgressBar.hide();
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

  final ChatPresenter chatPresenter;

  BottomSheetWidget({
    Key key,
    @required this.chatPresenter
  });

  @override
  Widget build(BuildContext context)=>
    Card(
      elevation: 5.0,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CommentInput(
              chatPresenter: chatPresenter
          ),
        ],
      ),
    );

}
