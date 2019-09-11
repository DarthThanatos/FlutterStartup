import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

part 'built_chat.g.dart';

abstract class BuiltChat implements Built<BuiltChat, BuiltChatBuilder>{
  int get chatId;
  BuiltChatItem get chatRoot;
  String get title;
  int get commentsAmount;

  BuiltChat._();

  factory BuiltChat([updates(BuiltChatBuilder b)]) = _$BuiltChat;

  static Serializer<BuiltChat> get serializer => _$builtChatSerializer;
}