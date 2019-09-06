// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_chat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BuiltChat> _$builtChatSerializer = new _$BuiltChatSerializer();

class _$BuiltChatSerializer implements StructuredSerializer<BuiltChat> {
  @override
  final Iterable<Type> types = const [BuiltChat, _$BuiltChat];
  @override
  final String wireName = 'BuiltChat';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltChat object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'chatId',
      serializers.serialize(object.chatId, specifiedType: const FullType(int)),
      'chatItems',
      serializers.serialize(object.chatItems,
          specifiedType:
              const FullType(BuiltList, const [const FullType(BuiltChatItem)])),
    ];

    return result;
  }

  @override
  BuiltChat deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltChatBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'chatId':
          result.chatId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'chatItems':
          result.chatItems.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BuiltChatItem)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltChat extends BuiltChat {
  @override
  final int chatId;
  @override
  final BuiltList<BuiltChatItem> chatItems;

  factory _$BuiltChat([void Function(BuiltChatBuilder) updates]) =>
      (new BuiltChatBuilder()..update(updates)).build();

  _$BuiltChat._({this.chatId, this.chatItems}) : super._() {
    if (chatId == null) {
      throw new BuiltValueNullFieldError('BuiltChat', 'chatId');
    }
    if (chatItems == null) {
      throw new BuiltValueNullFieldError('BuiltChat', 'chatItems');
    }
  }

  @override
  BuiltChat rebuild(void Function(BuiltChatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltChatBuilder toBuilder() => new BuiltChatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltChat &&
        chatId == other.chatId &&
        chatItems == other.chatItems;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, chatId.hashCode), chatItems.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltChat')
          ..add('chatId', chatId)
          ..add('chatItems', chatItems))
        .toString();
  }
}

class BuiltChatBuilder implements Builder<BuiltChat, BuiltChatBuilder> {
  _$BuiltChat _$v;

  int _chatId;
  int get chatId => _$this._chatId;
  set chatId(int chatId) => _$this._chatId = chatId;

  ListBuilder<BuiltChatItem> _chatItems;
  ListBuilder<BuiltChatItem> get chatItems =>
      _$this._chatItems ??= new ListBuilder<BuiltChatItem>();
  set chatItems(ListBuilder<BuiltChatItem> chatItems) =>
      _$this._chatItems = chatItems;

  BuiltChatBuilder();

  BuiltChatBuilder get _$this {
    if (_$v != null) {
      _chatId = _$v.chatId;
      _chatItems = _$v.chatItems?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltChat other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltChat;
  }

  @override
  void update(void Function(BuiltChatBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltChat build() {
    _$BuiltChat _$result;
    try {
      _$result = _$v ??
          new _$BuiltChat._(chatId: chatId, chatItems: chatItems.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'chatItems';
        chatItems.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltChat', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
