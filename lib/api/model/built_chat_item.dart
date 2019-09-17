import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'built_comment_author.dart';
import 'built_file_info.dart';
import 'package:built_collection/built_collection.dart';

part 'built_chat_item.g.dart';

abstract class BuiltChatItem implements Built<BuiltChatItem, BuiltChatItemBuilder> {

  int get chatItemId;
  int get chatId;
  BuiltCommentAuthor get user;
  String get text;
  String get creationTime;
  @nullable
  BuiltList<BuiltChatItem> get children;
  @nullable
  BuiltList<BuiltFileInfo> get fileInfos;
  @nullable
  int get parentId;

  BuiltChatItem._();

  factory BuiltChatItem([updates(BuiltChatItemBuilder b)]) = _$BuiltChatItem;

  static Serializer<BuiltChatItem> get serializer => _$builtChatItemSerializer;
}