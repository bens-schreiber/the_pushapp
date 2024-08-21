import "package:freezed_annotation/freezed_annotation.dart";

part "group.freezed.dart";
part "group.g.dart";

@freezed
class Group with _$Group {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Group(
      {required String id,
      required DateTime createdAt,
      required String adminUserId,
      required int token,
      required String? tokenUserId,
      required bool isActive}) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
