
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

class ChatPageState extends State<ChatPage> implements ChatView, RespondToCommentListener {

  BuiltChat chat;
  BuiltChatItem currentlyRespondingChatItem;

  ScrollController _nestedController;

  @override
  void initState() {
    super.initState();
    _nestedController = ScrollController();
    widget.presenter.attachView(this);
    widget.presenter.downloadChat(666);
  }

  @override
  void dispose() {
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
      _bottomSheetWidget = BottomSheetWidget(respondToCommentListener: this);
    }
    else {
      _bottomSheetWidget =
        currentlyRespondingChatItem == _bottomSheetWidget.currentlyRespondingChatItem
            ? _bottomSheetWidget
            : BottomSheetWidget(
              currentlyRespondingChatItem: currentlyRespondingChatItem,
              respondToCommentListener: this
            );
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
    return Container(
        height: 400,
        child:
        NestedList(
            controller: _nestedController,
            body:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Builder(builder: (BuildContext context){
                    WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _logNestedOffset(context)
                    );
                    return ListView.builder(
                        itemCount: flattenedComments.length + 2,
                        itemBuilder: (BuildContext context, int index)
                          => _commentSectionIndexToView(index, flattenedComments)
                    );
                  })
            )
        )
    );
  }

  Widget _commentSectionIndexToView(int index, BuiltList<BuiltChatItem> items){
    if(index == 0) return _moreCommentsBtn();
    if(index <= items.length) {
      final item = items[index - 1];
      final relatedComment = widget.presenter.getRelatedOrNull(item);
      return
        Builder(
          builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _logSizeOf(context, index - 1)
            );
            return CommentItemPage(chatItem: item, respondListener: this, relatedComment: relatedComment);
          }
        );
    }
    return Container(height: 75);
  }

  Map<int, double> _indexToPosition = Map();
  double _nestedOffset = 0;


  @override
  void onGoToComment(BuiltChatItem chatItem) {
    int index = widget.presenter.idToIndex(chatItem.chatItemId);
    if(index == null) return;
    double scrollPosition = _indexToPosition[index];
    print("Going to comment with id: ${chatItem.chatItemId} $scrollPosition $index");
    _nestedController.animateTo(scrollPosition, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
  
  void _logNestedOffset(BuildContext context){
    final RenderBox renderBoxRed = context.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    _nestedOffset = positionRed.dy;
  }

  void _logSizeOf(BuildContext context, int index) async {
    final RenderBox renderBoxRed = context.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset(0, _nestedOffset));
    double pY = positionRed.dy - _nestedOffset;
    _indexToPosition[index] = pY;
    print("SIZE of Red: $pY $_nestedOffset $index");
  }

  Widget _moreCommentsBtn() =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(child: Text("Wczytaj więcej"), onPressed: (){},),
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
    print("displaying chat");
    setState(
        (){this.chat = chat;}
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

  BottomSheetWidget({Key key, this.currentlyRespondingChatItem, @required this.respondToCommentListener});

  @override
  Widget build(BuildContext context)=>
    Card(
      elevation: 5.0,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CommentInput(maybeRelatedComment: currentlyRespondingChatItem, respondToCommentListener: respondToCommentListener),
        ],
      ),
    );

}
