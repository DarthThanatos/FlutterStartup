
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/ui/chat/comment_input.dart';
import 'package:flutter_app/ui/chat/root_comment_button_section.dart';
import 'package:flutter_app/widget/NestedList.dart';
import 'package:inject/inject.dart';

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

class ChatPageState extends State<ChatPage> implements ChatView, RespondToCommentListener, OnMessageReadyListener {

  BuiltChat chat;
  BuiltChatItem currentlyRespondingChatItem;
  bool _cleanInput = false;

  ScrollController _nestedController;
  ScrollController _outerController;

  @override
  void initState() {
    super.initState();
    _outerController = ScrollController();
    _nestedController = ScrollController();
    widget.presenter.attachView(this);
    widget.presenter.downloadChat(666);
  }

  @override
  void dispose() {
    _outerController.dispose();
    _nestedController.dispose();
    widget.presenter.detachView();
    super.dispose();
  }

  // to prevent invoking build() on tapping the text field
  // https://github.com/flutter/flutter/issues/36271
  // Also, at start we do not respond to anyone, so responding chat item is null (not-passed)
  var _bottomSheetWidget;

  Widget _upToDateBottomSheet(){
    if(_bottomSheetWidget == null){
      _bottomSheetWidget = BottomSheetWidget(respondToCommentListener: this, onMessageReadyListener: this);
    }
    else {
      _bottomSheetWidget =
        currentlyRespondingChatItem == _bottomSheetWidget.currentlyRespondingChatItem && !_cleanInput
            ? _bottomSheetWidget
            : BottomSheetWidget(
              currentlyRespondingChatItem: currentlyRespondingChatItem,
              respondToCommentListener: this,
              onMessageReadyListener: this
            );
      _cleanInput = false;
    }
    return _bottomSheetWidget;
  }

  @override
  Widget build(BuildContext context) {
    return
      chat == null
          ? _LoadingMessage()
          : Scaffold(
            appBar: _appBar(),
            bottomSheet:
              _upToDateBottomSheet(),
            body:
                ListView(
                  controller: _outerController,
                  children:
                    _rootQuestionSection()
                      ..add(SizedBox(height: 10))
                      ..add(_commentsSummary())
                      ..add(SizedBox(height: 10))
                      ..add(_nestedCommentListView())
                ),
          );
  }

  Widget _nestedCommentListView() {
    final flattenedComments = chat.comments;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom());

    return Container(
        height: 400,
        child:
        NestedList(
            body:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                ListView.builder(
                  controller: _nestedController,
                  itemCount: flattenedComments.length + 2,
                  itemBuilder: (BuildContext context, int index) =>
                      _commentSectionIndexToView(index, flattenedComments)
                )
            )
        )
    );
  }

  void _scrollToBottom() {
    _nestedController.animateTo(_nestedController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
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
    final relatedComment = widget.presenter.getRelatedOrNull(item);
    return
      Builder(builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _logCommentViewHeight(context, index));
        return CommentItemPage(chatItem: item, respondListener: this, relatedComment: relatedComment);
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

  Map<int, double> _commentViewsHeights = Map();

  void _logCommentViewHeight(BuildContext context, int index){
    _commentViewsHeights[index] = (context.findRenderObject() as RenderBox).size.height;
  }

  double _heightOfCommentViewsToIndex(int index){
    double sum = 0;
    for (var i = 0; i < index; i++){
      sum += _commentViewsHeights[i];
    }
    return sum;
  }

  @override
  void onGoToComment(BuiltChatItem chatItem) {
    int index = widget.presenter.idToIndex(chatItem.chatItemId);
    if(index == null) return;
    double y = _heightOfCommentViewsToIndex(index);
    _nestedController.animateTo(y, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }


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
      "${chat.commentsAmount} komentarz(y)",
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
                    chat.title,
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
      RootCommentButtonSection()
    ];

  Widget _imgsGrid(){
    final Set<String> photosPaths = chat.chatRoot.fileInfos.map((fileInfo) => fileInfo.url).toSet();
    return ImageGridSection(photosPaths: photosPaths);
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
    setState(
        (){
          this.chat = chat;
          currentlyRespondingChatItem = null;
          _cleanInput = true;
        }
    );
  }

  @override
  void onRespondToComment(BuiltChatItem comment) {
    setState(() {
      this.currentlyRespondingChatItem = comment;
    });
  }

  @override
  void onRemoveRelatedComment() {
    setState(() {
      currentlyRespondingChatItem = null;
    });
  }

  @override
  void onMessageReady(String text, int parentComment, Set<String> paths) {
    widget.presenter.sendMessage(paths, text, parentComment);
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

  final BuiltChatItem currentlyRespondingChatItem;
  final RespondToCommentListener respondToCommentListener;
  final OnMessageReadyListener onMessageReadyListener;

  BottomSheetWidget({
    Key key,
    this.currentlyRespondingChatItem,
    @required this.respondToCommentListener,
    @required this.onMessageReadyListener
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
              maybeRelatedComment: currentlyRespondingChatItem,
              respondToCommentListener: respondToCommentListener,
              onMessageReadyListener: onMessageReadyListener
          ),
        ],
      ),
    );

}
