// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      adminUserId: json['admin_user_id'] as String,
      token: (json['token'] as num).toInt(),
      tokenUserId: json['token_user_id'] as String?,
      isActive: json['is_active'] as bool,
      inviteId: json['invite_id'] as String,
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'admin_user_id': instance.adminUserId,
      'token': instance.token,
      'token_user_id': instance.tokenUserId,
      'is_active': instance.isActive,
      'invite_id': instance.inviteId,
    };
