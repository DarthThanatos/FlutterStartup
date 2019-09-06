import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'built_chat_item.g.dart';

abstract class BuiltChatItem implements Built<BuiltChatItem, BuiltChatItemBuilder>{
  int get chatItemId;
  int get chatId;
  String get text;

  BuiltChatItem._();

  factory BuiltChatItem([updates(BuiltChatItemBuilder b)]) = _$BuiltChatItem;

  static Serializer<BuiltChatItem> get serializer => _$builtChatItemSerializer;
}