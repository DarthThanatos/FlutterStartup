import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

import 'package:built_collection/built_collection.dart';
part 'built_chat.g.dart';

abstract class BuiltChat implements Built<BuiltChat, BuiltChatBuilder>{
  int get chatId;
  BuiltChatItem get chatRoot;
  BuiltList<BuiltChatItem> get comments;
  String get title;
  int get commentsAmount;

  BuiltChat._();

  factory BuiltChat([updates(BuiltChatBuilder b)]) = _$BuiltChat;

  static Serializer<BuiltChat> get serializer => _$builtChatSerializer;
}