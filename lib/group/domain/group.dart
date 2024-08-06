import "package:freezed_annotation/freezed_annotation.dart";

part "group.freezed.dart";
part "group.g.dart";

@freezed
class Group with _$Group {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Group(
      {required int id,
      required DateTime createdAt,
      required String adminUserId,
      required int token,
      required String? tokenUserId,
      required bool isActive,
      required String inviteId}) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}



/*
{id: 22, created_at: 2024-08-06T06:17:37.268966+00:00, admin_user_id: eaebd285-3313-47fb-8887-c4c5543cc13b, token: 0, token_user_id: null, is_active: false, invite_id: b83a0c56-b544-414a-baec-03f4b5e8ed49}
*/