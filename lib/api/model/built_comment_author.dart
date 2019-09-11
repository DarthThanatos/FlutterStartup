import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'built_comment_author.g.dart';

abstract class BuiltCommentAuthor implements Built<BuiltCommentAuthor, BuiltCommentAuthorBuilder> {

  int get userId;
  String get avatarUrl;
  String get userName;

  BuiltCommentAuthor._();

  factory BuiltCommentAuthor([updates(BuiltCommentAuthorBuilder b)]) = _$BuiltCommentAuthor;

  static Serializer<BuiltCommentAuthor> get serializer => _$builtCommentAuthorSerializer;
}