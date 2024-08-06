// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  int get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get adminUserId => throw _privateConstructorUsedError;
  int get token => throw _privateConstructorUsedError;
  String? get tokenUserId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get inviteId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call(
      {int id,
      DateTime createdAt,
      String adminUserId,
      int token,
      String? tokenUserId,
      bool isActive,
      String inviteId});
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? adminUserId = null,
    Object? token = null,
    Object? tokenUserId = freezed,
    Object? isActive = null,
    Object? inviteId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      adminUserId: null == adminUserId
          ? _value.adminUserId
          : adminUserId // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as int,
      tokenUserId: freezed == tokenUserId
          ? _value.tokenUserId
          : tokenUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      inviteId: null == inviteId
          ? _value.inviteId
          : inviteId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
          _$GroupImpl value, $Res Function(_$GroupImpl) then) =
      __$$GroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime createdAt,
      String adminUserId,
      int token,
      String? tokenUserId,
      bool isActive,
      String inviteId});
}

/// @nodoc
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
      _$GroupImpl _value, $Res Function(_$GroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? adminUserId = null,
    Object? token = null,
    Object? tokenUserId = freezed,
    Object? isActive = null,
    Object? inviteId = null,
  }) {
    return _then(_$GroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      adminUserId: null == adminUserId
          ? _value.adminUserId
          : adminUserId // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as int,
      tokenUserId: freezed == tokenUserId
          ? _value.tokenUserId
          : tokenUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      inviteId: null == inviteId
          ? _value.inviteId
          : inviteId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$GroupImpl implements _Group {
  const _$GroupImpl(
      {required this.id,
      required this.createdAt,
      required this.adminUserId,
      required this.token,
      required this.tokenUserId,
      required this.isActive,
      required this.inviteId});

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final String adminUserId;
  @override
  final int token;
  @override
  final String? tokenUserId;
  @override
  final bool isActive;
  @override
  final String inviteId;

  @override
  String toString() {
    return 'Group(id: $id, createdAt: $createdAt, adminUserId: $adminUserId, token: $token, tokenUserId: $tokenUserId, isActive: $isActive, inviteId: $inviteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.adminUserId, adminUserId) ||
                other.adminUserId == adminUserId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.tokenUserId, tokenUserId) ||
                other.tokenUserId == tokenUserId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.inviteId, inviteId) ||
                other.inviteId == inviteId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, adminUserId,
      token, tokenUserId, isActive, inviteId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(
      this,
    );
  }
}

abstract class _Group implements Group {
  const factory _Group(
      {required final int id,
      required final DateTime createdAt,
      required final String adminUserId,
      required final int token,
      required final String? tokenUserId,
      required final bool isActive,
      required final String inviteId}) = _$GroupImpl;

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get createdAt;
  @override
  String get adminUserId;
  @override
  int get token;
  @override
  String? get tokenUserId;
  @override
  bool get isActive;
  @override
  String get inviteId;
  @override
  @JsonKey(ignore: true)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
