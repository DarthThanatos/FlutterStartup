import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

import 'package:built_collection/built_collection.dart';

import '../model/built_chat_item.dart';

part 'serializers.g.dart';

@SerializersFor(const [BuiltChatItem, BuiltChat])
final Serializers serializers =
  (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();