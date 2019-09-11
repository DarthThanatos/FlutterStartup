import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'built_file_info.g.dart';

abstract class BuiltFileInfo implements Built<BuiltFileInfo, BuiltFileInfoBuilder> {

  String get filename;
  String get sizeDesc;
  String get url;

  BuiltFileInfo._();

  factory BuiltFileInfo([updates(BuiltFileInfoBuilder b)]) = _$BuiltFileInfo;

  static Serializer<BuiltFileInfo> get serializer => _$builtFileInfoSerializer;
}