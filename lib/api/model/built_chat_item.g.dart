// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_chat_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BuiltChatItem> _$builtChatItemSerializer =
    new _$BuiltChatItemSerializer();

class _$BuiltChatItemSerializer implements StructuredSerializer<BuiltChatItem> {
  @override
  final Iterable<Type> types = const [BuiltChatItem, _$BuiltChatItem];
  @override
  final String wireName = 'BuiltChatItem';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltChatItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'chatItemId',
      serializers.serialize(object.chatItemId,
          specifiedType: const FullType(int)),
      'chatId',
      serializers.serialize(object.chatId, specifiedType: const FullType(int)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BuiltChatItem deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltChatItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'chatItemId':
          result.chatItemId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'chatId':
          result.chatId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltChatItem extends BuiltChatItem {
  @override
  final int chatItemId;
  @override
  final int chatId;
  @override
  final String text;

  factory _$BuiltChatItem([void Function(BuiltChatItemBuilder) updates]) =>
      (new BuiltChatItemBuilder()..update(updates)).build();

  _$BuiltChatItem._({this.chatItemId, this.chatId, this.text}) : super._() {
    if (chatItemId == null) {
      throw new BuiltValueNullFieldError('BuiltChatItem', 'chatItemId');
    }
    if (chatId == null) {
      throw new BuiltValueNullFieldError('BuiltChatItem', 'chatId');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('BuiltChatItem', 'text');
    }
  }

  @override
  BuiltChatItem rebuild(void Function(BuiltChatItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltChatItemBuilder toBuilder() => new BuiltChatItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltChatItem &&
        chatItemId == other.chatItemId &&
        chatId == other.chatId &&
        text == other.text;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, chatItemId.hashCode), chatId.hashCode), text.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltChatItem')
          ..add('chatItemId', chatItemId)
          ..add('chatId', chatId)
          ..add('text', text))
        .toString();
  }
}

class BuiltChatItemBuilder
    implements Builder<BuiltChatItem, BuiltChatItemBuilder> {
  _$BuiltChatItem _$v;

  int _chatItemId;
  int get chatItemId => _$this._chatItemId;
  set chatItemId(int chatItemId) => _$this._chatItemId = chatItemId;

  int _chatId;
  int get chatId => _$this._chatId;
  set chatId(int chatId) => _$this._chatId = chatId;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  BuiltChatItemBuilder();

  BuiltChatItemBuilder get _$this {
    if (_$v != null) {
      _chatItemId = _$v.chatItemId;
      _chatId = _$v.chatId;
      _text = _$v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltChatItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltChatItem;
  }

  @override
  void update(void Function(BuiltChatItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltChatItem build() {
    final _$result = _$v ??
        new _$BuiltChatItem._(
            chatItemId: chatItemId, chatId: chatId, text: text);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
