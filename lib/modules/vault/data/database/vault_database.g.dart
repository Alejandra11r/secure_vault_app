// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_database.dart';

class $VaultNotesTable extends VaultNotes
    with TableInfo<$VaultNotesTable, VaultNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<Uint8List> nonce = GeneratedColumn<Uint8List>(
      'nonce', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _cipherTextMeta =
      const VerificationMeta('cipherText');
  @override
  late final GeneratedColumn<Uint8List> cipherText = GeneratedColumn<Uint8List>(
      'cipher_text', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _macMeta = const VerificationMeta('mac');
  @override
  late final GeneratedColumn<Uint8List> mac = GeneratedColumn<Uint8List>(
      'mac', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, accountId, nonce, cipherText, mac, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_notes';
  @override
  VerificationContext validateIntegrity(Insertable<VaultNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('cipher_text')) {
      context.handle(
          _cipherTextMeta,
          cipherText.isAcceptableOrUnknown(
              data['cipher_text']!, _cipherTextMeta));
    } else if (isInserting) {
      context.missing(_cipherTextMeta);
    }
    if (data.containsKey('mac')) {
      context.handle(
          _macMeta, mac.isAcceptableOrUnknown(data['mac']!, _macMeta));
    } else if (isInserting) {
      context.missing(_macMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultNote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}nonce'])!,
      cipherText: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}cipher_text'])!,
      mac: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}mac'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VaultNotesTable createAlias(String alias) {
    return $VaultNotesTable(attachedDatabase, alias);
  }
}

class VaultNote extends DataClass implements Insertable<VaultNote> {
  final String id;
  final String accountId;
  final Uint8List nonce;
  final Uint8List cipherText;
  final Uint8List mac;
  final DateTime createdAt;
  const VaultNote(
      {required this.id,
      required this.accountId,
      required this.nonce,
      required this.cipherText,
      required this.mac,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['nonce'] = Variable<Uint8List>(nonce);
    map['cipher_text'] = Variable<Uint8List>(cipherText);
    map['mac'] = Variable<Uint8List>(mac);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VaultNotesCompanion toCompanion(bool nullToAbsent) {
    return VaultNotesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      nonce: Value(nonce),
      cipherText: Value(cipherText),
      mac: Value(mac),
      createdAt: Value(createdAt),
    );
  }

  factory VaultNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultNote(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      nonce: serializer.fromJson<Uint8List>(json['nonce']),
      cipherText: serializer.fromJson<Uint8List>(json['cipherText']),
      mac: serializer.fromJson<Uint8List>(json['mac']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'nonce': serializer.toJson<Uint8List>(nonce),
      'cipherText': serializer.toJson<Uint8List>(cipherText),
      'mac': serializer.toJson<Uint8List>(mac),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VaultNote copyWith(
          {String? id,
          String? accountId,
          Uint8List? nonce,
          Uint8List? cipherText,
          Uint8List? mac,
          DateTime? createdAt}) =>
      VaultNote(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        nonce: nonce ?? this.nonce,
        cipherText: cipherText ?? this.cipherText,
        mac: mac ?? this.mac,
        createdAt: createdAt ?? this.createdAt,
      );
  VaultNote copyWithCompanion(VaultNotesCompanion data) {
    return VaultNote(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      cipherText:
          data.cipherText.present ? data.cipherText.value : this.cipherText,
      mac: data.mac.present ? data.mac.value : this.mac,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultNote(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('nonce: $nonce, ')
          ..write('cipherText: $cipherText, ')
          ..write('mac: $mac, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      $driftBlobEquality.hash(nonce),
      $driftBlobEquality.hash(cipherText),
      $driftBlobEquality.hash(mac),
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultNote &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          $driftBlobEquality.equals(other.nonce, this.nonce) &&
          $driftBlobEquality.equals(other.cipherText, this.cipherText) &&
          $driftBlobEquality.equals(other.mac, this.mac) &&
          other.createdAt == this.createdAt);
}

class VaultNotesCompanion extends UpdateCompanion<VaultNote> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<Uint8List> nonce;
  final Value<Uint8List> cipherText;
  final Value<Uint8List> mac;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VaultNotesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.nonce = const Value.absent(),
    this.cipherText = const Value.absent(),
    this.mac = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultNotesCompanion.insert({
    required String id,
    required String accountId,
    required Uint8List nonce,
    required Uint8List cipherText,
    required Uint8List mac,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        nonce = Value(nonce),
        cipherText = Value(cipherText),
        mac = Value(mac),
        createdAt = Value(createdAt);
  static Insertable<VaultNote> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<Uint8List>? nonce,
    Expression<Uint8List>? cipherText,
    Expression<Uint8List>? mac,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (nonce != null) 'nonce': nonce,
      if (cipherText != null) 'cipher_text': cipherText,
      if (mac != null) 'mac': mac,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultNotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<Uint8List>? nonce,
      Value<Uint8List>? cipherText,
      Value<Uint8List>? mac,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return VaultNotesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      nonce: nonce ?? this.nonce,
      cipherText: cipherText ?? this.cipherText,
      mac: mac ?? this.mac,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<Uint8List>(nonce.value);
    }
    if (cipherText.present) {
      map['cipher_text'] = Variable<Uint8List>(cipherText.value);
    }
    if (mac.present) {
      map['mac'] = Variable<Uint8List>(mac.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultNotesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('nonce: $nonce, ')
          ..write('cipherText: $cipherText, ')
          ..write('mac: $mac, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaultCategoriesTable extends VaultCategories
    with TableInfo<$VaultCategoriesTable, VaultCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<Uint8List> nonce = GeneratedColumn<Uint8List>(
      'nonce', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _cipherTextMeta =
      const VerificationMeta('cipherText');
  @override
  late final GeneratedColumn<Uint8List> cipherText = GeneratedColumn<Uint8List>(
      'cipher_text', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _macMeta = const VerificationMeta('mac');
  @override
  late final GeneratedColumn<Uint8List> mac = GeneratedColumn<Uint8List>(
      'mac', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, accountId, nonce, cipherText, mac];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_categories';
  @override
  VerificationContext validateIntegrity(Insertable<VaultCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('cipher_text')) {
      context.handle(
          _cipherTextMeta,
          cipherText.isAcceptableOrUnknown(
              data['cipher_text']!, _cipherTextMeta));
    } else if (isInserting) {
      context.missing(_cipherTextMeta);
    }
    if (data.containsKey('mac')) {
      context.handle(
          _macMeta, mac.isAcceptableOrUnknown(data['mac']!, _macMeta));
    } else if (isInserting) {
      context.missing(_macMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}nonce'])!,
      cipherText: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}cipher_text'])!,
      mac: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}mac'])!,
    );
  }

  @override
  $VaultCategoriesTable createAlias(String alias) {
    return $VaultCategoriesTable(attachedDatabase, alias);
  }
}

class VaultCategory extends DataClass implements Insertable<VaultCategory> {
  final String id;
  final String accountId;
  final Uint8List nonce;
  final Uint8List cipherText;
  final Uint8List mac;
  const VaultCategory(
      {required this.id,
      required this.accountId,
      required this.nonce,
      required this.cipherText,
      required this.mac});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['nonce'] = Variable<Uint8List>(nonce);
    map['cipher_text'] = Variable<Uint8List>(cipherText);
    map['mac'] = Variable<Uint8List>(mac);
    return map;
  }

  VaultCategoriesCompanion toCompanion(bool nullToAbsent) {
    return VaultCategoriesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      nonce: Value(nonce),
      cipherText: Value(cipherText),
      mac: Value(mac),
    );
  }

  factory VaultCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultCategory(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      nonce: serializer.fromJson<Uint8List>(json['nonce']),
      cipherText: serializer.fromJson<Uint8List>(json['cipherText']),
      mac: serializer.fromJson<Uint8List>(json['mac']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'nonce': serializer.toJson<Uint8List>(nonce),
      'cipherText': serializer.toJson<Uint8List>(cipherText),
      'mac': serializer.toJson<Uint8List>(mac),
    };
  }

  VaultCategory copyWith(
          {String? id,
          String? accountId,
          Uint8List? nonce,
          Uint8List? cipherText,
          Uint8List? mac}) =>
      VaultCategory(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        nonce: nonce ?? this.nonce,
        cipherText: cipherText ?? this.cipherText,
        mac: mac ?? this.mac,
      );
  VaultCategory copyWithCompanion(VaultCategoriesCompanion data) {
    return VaultCategory(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      cipherText:
          data.cipherText.present ? data.cipherText.value : this.cipherText,
      mac: data.mac.present ? data.mac.value : this.mac,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultCategory(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('nonce: $nonce, ')
          ..write('cipherText: $cipherText, ')
          ..write('mac: $mac')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, $driftBlobEquality.hash(nonce),
      $driftBlobEquality.hash(cipherText), $driftBlobEquality.hash(mac));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultCategory &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          $driftBlobEquality.equals(other.nonce, this.nonce) &&
          $driftBlobEquality.equals(other.cipherText, this.cipherText) &&
          $driftBlobEquality.equals(other.mac, this.mac));
}

class VaultCategoriesCompanion extends UpdateCompanion<VaultCategory> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<Uint8List> nonce;
  final Value<Uint8List> cipherText;
  final Value<Uint8List> mac;
  final Value<int> rowid;
  const VaultCategoriesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.nonce = const Value.absent(),
    this.cipherText = const Value.absent(),
    this.mac = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultCategoriesCompanion.insert({
    required String id,
    required String accountId,
    required Uint8List nonce,
    required Uint8List cipherText,
    required Uint8List mac,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        nonce = Value(nonce),
        cipherText = Value(cipherText),
        mac = Value(mac);
  static Insertable<VaultCategory> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<Uint8List>? nonce,
    Expression<Uint8List>? cipherText,
    Expression<Uint8List>? mac,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (nonce != null) 'nonce': nonce,
      if (cipherText != null) 'cipher_text': cipherText,
      if (mac != null) 'mac': mac,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<Uint8List>? nonce,
      Value<Uint8List>? cipherText,
      Value<Uint8List>? mac,
      Value<int>? rowid}) {
    return VaultCategoriesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      nonce: nonce ?? this.nonce,
      cipherText: cipherText ?? this.cipherText,
      mac: mac ?? this.mac,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<Uint8List>(nonce.value);
    }
    if (cipherText.present) {
      map['cipher_text'] = Variable<Uint8List>(cipherText.value);
    }
    if (mac.present) {
      map['mac'] = Variable<Uint8List>(mac.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('nonce: $nonce, ')
          ..write('cipherText: $cipherText, ')
          ..write('mac: $mac, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaultFilesTable extends VaultFiles
    with TableInfo<$VaultFilesTable, VaultFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metadataNonceMeta =
      const VerificationMeta('metadataNonce');
  @override
  late final GeneratedColumn<Uint8List> metadataNonce =
      GeneratedColumn<Uint8List>('metadata_nonce', aliasedName, false,
          type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _metadataCipherTextMeta =
      const VerificationMeta('metadataCipherText');
  @override
  late final GeneratedColumn<Uint8List> metadataCipherText =
      GeneratedColumn<Uint8List>('metadata_cipher_text', aliasedName, false,
          type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _metadataMacMeta =
      const VerificationMeta('metadataMac');
  @override
  late final GeneratedColumn<Uint8List> metadataMac =
      GeneratedColumn<Uint8List>('metadata_mac', aliasedName, false,
          type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<Uint8List> nonce = GeneratedColumn<Uint8List>(
      'nonce', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _cipherTextMeta =
      const VerificationMeta('cipherText');
  @override
  late final GeneratedColumn<Uint8List> cipherText = GeneratedColumn<Uint8List>(
      'cipher_text', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _macMeta = const VerificationMeta('mac');
  @override
  late final GeneratedColumn<Uint8List> mac = GeneratedColumn<Uint8List>(
      'mac', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _plainSizeMeta =
      const VerificationMeta('plainSize');
  @override
  late final GeneratedColumn<int> plainSize = GeneratedColumn<int>(
      'plain_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        metadataNonce,
        metadataCipherText,
        metadataMac,
        nonce,
        cipherText,
        mac,
        plainSize
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_files';
  @override
  VerificationContext validateIntegrity(Insertable<VaultFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('metadata_nonce')) {
      context.handle(
          _metadataNonceMeta,
          metadataNonce.isAcceptableOrUnknown(
              data['metadata_nonce']!, _metadataNonceMeta));
    } else if (isInserting) {
      context.missing(_metadataNonceMeta);
    }
    if (data.containsKey('metadata_cipher_text')) {
      context.handle(
          _metadataCipherTextMeta,
          metadataCipherText.isAcceptableOrUnknown(
              data['metadata_cipher_text']!, _metadataCipherTextMeta));
    } else if (isInserting) {
      context.missing(_metadataCipherTextMeta);
    }
    if (data.containsKey('metadata_mac')) {
      context.handle(
          _metadataMacMeta,
          metadataMac.isAcceptableOrUnknown(
              data['metadata_mac']!, _metadataMacMeta));
    } else if (isInserting) {
      context.missing(_metadataMacMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('cipher_text')) {
      context.handle(
          _cipherTextMeta,
          cipherText.isAcceptableOrUnknown(
              data['cipher_text']!, _cipherTextMeta));
    } else if (isInserting) {
      context.missing(_cipherTextMeta);
    }
    if (data.containsKey('mac')) {
      context.handle(
          _macMeta, mac.isAcceptableOrUnknown(data['mac']!, _macMeta));
    } else if (isInserting) {
      context.missing(_macMeta);
    }
    if (data.containsKey('plain_size')) {
      context.handle(_plainSizeMeta,
          plainSize.isAcceptableOrUnknown(data['plain_size']!, _plainSizeMeta));
    } else if (isInserting) {
      context.missing(_plainSizeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultFile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      metadataNonce: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}metadata_nonce'])!,
      metadataCipherText: attachedDatabase.typeMapping.read(
          DriftSqlType.blob, data['${effectivePrefix}metadata_cipher_text'])!,
      metadataMac: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}metadata_mac'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}nonce'])!,
      cipherText: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}cipher_text'])!,
      mac: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}mac'])!,
      plainSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plain_size'])!,
    );
  }

  @override
  $VaultFilesTable createAlias(String alias) {
    return $VaultFilesTable(attachedDatabase, alias);
  }
}

class VaultFile extends DataClass implements Insertable<VaultFile> {
  final String id;
  final String accountId;
  final Uint8List metadataNonce;
  final Uint8List metadataCipherText;
  final Uint8List metadataMac;
  final Uint8List nonce;
  final Uint8List cipherText;
  final Uint8List mac;
  final int plainSize;
  const VaultFile(
      {required this.id,
      required this.accountId,
      required this.metadataNonce,
      required this.metadataCipherText,
      required this.metadataMac,
      required this.nonce,
      required this.cipherText,
      required this.mac,
      required this.plainSize});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['metadata_nonce'] = Variable<Uint8List>(metadataNonce);
    map['metadata_cipher_text'] = Variable<Uint8List>(metadataCipherText);
    map['metadata_mac'] = Variable<Uint8List>(metadataMac);
    map['nonce'] = Variable<Uint8List>(nonce);
    map['cipher_text'] = Variable<Uint8List>(cipherText);
    map['mac'] = Variable<Uint8List>(mac);
    map['plain_size'] = Variable<int>(plainSize);
    return map;
  }

  VaultFilesCompanion toCompanion(bool nullToAbsent) {
    return VaultFilesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      metadataNonce: Value(metadataNonce),
      metadataCipherText: Value(metadataCipherText),
      metadataMac: Value(metadataMac),
      nonce: Value(nonce),
      cipherText: Value(cipherText),
      mac: Value(mac),
      plainSize: Value(plainSize),
    );
  }

  factory VaultFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultFile(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      metadataNonce: serializer.fromJson<Uint8List>(json['metadataNonce']),
      metadataCipherText:
          serializer.fromJson<Uint8List>(json['metadataCipherText']),
      metadataMac: serializer.fromJson<Uint8List>(json['metadataMac']),
      nonce: serializer.fromJson<Uint8List>(json['nonce']),
      cipherText: serializer.fromJson<Uint8List>(json['cipherText']),
      mac: serializer.fromJson<Uint8List>(json['mac']),
      plainSize: serializer.fromJson<int>(json['plainSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'metadataNonce': serializer.toJson<Uint8List>(metadataNonce),
      'metadataCipherText': serializer.toJson<Uint8List>(metadataCipherText),
      'metadataMac': serializer.toJson<Uint8List>(metadataMac),
      'nonce': serializer.toJson<Uint8List>(nonce),
      'cipherText': serializer.toJson<Uint8List>(cipherText),
      'mac': serializer.toJson<Uint8List>(mac),
      'plainSize': serializer.toJson<int>(plainSize),
    };
  }

  VaultFile copyWith(
          {String? id,
          String? accountId,
          Uint8List? metadataNonce,
          Uint8List? metadataCipherText,
          Uint8List? metadataMac,
          Uint8List? nonce,
          Uint8List? cipherText,
          Uint8List? mac,
          int? plainSize}) =>
      VaultFile(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        metadataNonce: metadataNonce ?? this.metadataNonce,
        metadataCipherText: metadataCipherText ?? this.metadataCipherText,
        metadataMac: metadataMac ?? this.metadataMac,
        nonce: nonce ?? this.nonce,
        cipherText: cipherText ?? this.cipherText,
        mac: mac ?? this.mac,
        plainSize: plainSize ?? this.plainSize,
      );
  VaultFile copyWithCompanion(VaultFilesCompanion data) {
    return VaultFile(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      metadataNonce: data.metadataNonce.present
          ? data.metadataNonce.value
          : this.metadataNonce,
      metadataCipherText: data.metadataCipherText.present
          ? data.metadataCipherText.value
          : this.metadataCipherText,
      metadataMac:
          data.metadataMac.present ? data.metadataMac.value : this.metadataMac,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      cipherText:
          data.cipherText.present ? data.cipherText.value : this.cipherText,
      mac: data.mac.present ? data.mac.value : this.mac,
      plainSize: data.plainSize.present ? data.plainSize.value : this.plainSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultFile(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('metadataNonce: $metadataNonce, ')
          ..write('metadataCipherText: $metadataCipherText, ')
          ..write('metadataMac: $metadataMac, ')
          ..write('nonce: $nonce, ')
          ..write('cipherText: $cipherText, ')
          ..write('mac: $mac, ')
          ..write('plainSize: $plainSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      $driftBlobEquality.hash(metadataNonce),
      $driftBlobEquality.hash(metadataCipherText),
      $driftBlobEquality.hash(metadataMac),
      $driftBlobEquality.hash(nonce),
      $driftBlobEquality.hash(cipherText),
      $driftBlobEquality.hash(mac),
      plainSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultFile &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          $driftBlobEquality.equals(other.metadataNonce, this.metadataNonce) &&
          $driftBlobEquality.equals(
              other.metadataCipherText, this.metadataCipherText) &&
          $driftBlobEquality.equals(other.metadataMac, this.metadataMac) &&
          $driftBlobEquality.equals(other.nonce, this.nonce) &&
          $driftBlobEquality.equals(other.cipherText, this.cipherText) &&
          $driftBlobEquality.equals(other.mac, this.mac) &&
          other.plainSize == this.plainSize);
}

class VaultFilesCompanion extends UpdateCompanion<VaultFile> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<Uint8List> metadataNonce;
  final Value<Uint8List> metadataCipherText;
  final Value<Uint8List> metadataMac;
  final Value<Uint8List> nonce;
  final Value<Uint8List> cipherText;
  final Value<Uint8List> mac;
  final Value<int> plainSize;
  final Value<int> rowid;
  const VaultFilesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.metadataNonce = const Value.absent(),
    this.metadataCipherText = const Value.absent(),
    this.metadataMac = const Value.absent(),
    this.nonce = const Value.absent(),
    this.cipherText = const Value.absent(),
    this.mac = const Value.absent(),
    this.plainSize = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultFilesCompanion.insert({
    required String id,
    required String accountId,
    required Uint8List metadataNonce,
    required Uint8List metadataCipherText,
    required Uint8List metadataMac,
    required Uint8List nonce,
    required Uint8List cipherText,
    required Uint8List mac,
    required int plainSize,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        metadataNonce = Value(metadataNonce),
        metadataCipherText = Value(metadataCipherText),
        metadataMac = Value(metadataMac),
        nonce = Value(nonce),
        cipherText = Value(cipherText),
        mac = Value(mac),
        plainSize = Value(plainSize);
  static Insertable<VaultFile> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<Uint8List>? metadataNonce,
    Expression<Uint8List>? metadataCipherText,
    Expression<Uint8List>? metadataMac,
    Expression<Uint8List>? nonce,
    Expression<Uint8List>? cipherText,
    Expression<Uint8List>? mac,
    Expression<int>? plainSize,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (metadataNonce != null) 'metadata_nonce': metadataNonce,
      if (metadataCipherText != null)
        'metadata_cipher_text': metadataCipherText,
      if (metadataMac != null) 'metadata_mac': metadataMac,
      if (nonce != null) 'nonce': nonce,
      if (cipherText != null) 'cipher_text': cipherText,
      if (mac != null) 'mac': mac,
      if (plainSize != null) 'plain_size': plainSize,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultFilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<Uint8List>? metadataNonce,
      Value<Uint8List>? metadataCipherText,
      Value<Uint8List>? metadataMac,
      Value<Uint8List>? nonce,
      Value<Uint8List>? cipherText,
      Value<Uint8List>? mac,
      Value<int>? plainSize,
      Value<int>? rowid}) {
    return VaultFilesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      metadataNonce: metadataNonce ?? this.metadataNonce,
      metadataCipherText: metadataCipherText ?? this.metadataCipherText,
      metadataMac: metadataMac ?? this.metadataMac,
      nonce: nonce ?? this.nonce,
      cipherText: cipherText ?? this.cipherText,
      mac: mac ?? this.mac,
      plainSize: plainSize ?? this.plainSize,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (metadataNonce.present) {
      map['metadata_nonce'] = Variable<Uint8List>(metadataNonce.value);
    }
    if (metadataCipherText.present) {
      map['metadata_cipher_text'] =
          Variable<Uint8List>(metadataCipherText.value);
    }
    if (metadataMac.present) {
      map['metadata_mac'] = Variable<Uint8List>(metadataMac.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<Uint8List>(nonce.value);
    }
    if (cipherText.present) {
      map['cipher_text'] = Variable<Uint8List>(cipherText.value);
    }
    if (mac.present) {
      map['mac'] = Variable<Uint8List>(mac.value);
    }
    if (plainSize.present) {
      map['plain_size'] = Variable<int>(plainSize.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultFilesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('metadataNonce: $metadataNonce, ')
          ..write('metadataCipherText: $metadataCipherText, ')
          ..write('metadataMac: $metadataMac, ')
          ..write('nonce: $nonce, ')
          ..write('cipherText: $cipherText, ')
          ..write('mac: $mac, ')
          ..write('plainSize: $plainSize, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaultCryptoUsageTable extends VaultCryptoUsage
    with TableInfo<$VaultCryptoUsageTable, VaultCryptoUsageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultCryptoUsageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encryptionsMeta =
      const VerificationMeta('encryptions');
  @override
  late final GeneratedColumn<int> encryptions = GeneratedColumn<int>(
      'encryptions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [accountId, encryptions];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_crypto_usage';
  @override
  VerificationContext validateIntegrity(
      Insertable<VaultCryptoUsageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('encryptions')) {
      context.handle(
          _encryptionsMeta,
          encryptions.isAcceptableOrUnknown(
              data['encryptions']!, _encryptionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  VaultCryptoUsageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultCryptoUsageData(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      encryptions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}encryptions'])!,
    );
  }

  @override
  $VaultCryptoUsageTable createAlias(String alias) {
    return $VaultCryptoUsageTable(attachedDatabase, alias);
  }
}

class VaultCryptoUsageData extends DataClass
    implements Insertable<VaultCryptoUsageData> {
  final String accountId;
  final int encryptions;
  const VaultCryptoUsageData(
      {required this.accountId, required this.encryptions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['encryptions'] = Variable<int>(encryptions);
    return map;
  }

  VaultCryptoUsageCompanion toCompanion(bool nullToAbsent) {
    return VaultCryptoUsageCompanion(
      accountId: Value(accountId),
      encryptions: Value(encryptions),
    );
  }

  factory VaultCryptoUsageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultCryptoUsageData(
      accountId: serializer.fromJson<String>(json['accountId']),
      encryptions: serializer.fromJson<int>(json['encryptions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'encryptions': serializer.toJson<int>(encryptions),
    };
  }

  VaultCryptoUsageData copyWith({String? accountId, int? encryptions}) =>
      VaultCryptoUsageData(
        accountId: accountId ?? this.accountId,
        encryptions: encryptions ?? this.encryptions,
      );
  VaultCryptoUsageData copyWithCompanion(VaultCryptoUsageCompanion data) {
    return VaultCryptoUsageData(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      encryptions:
          data.encryptions.present ? data.encryptions.value : this.encryptions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultCryptoUsageData(')
          ..write('accountId: $accountId, ')
          ..write('encryptions: $encryptions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accountId, encryptions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultCryptoUsageData &&
          other.accountId == this.accountId &&
          other.encryptions == this.encryptions);
}

class VaultCryptoUsageCompanion extends UpdateCompanion<VaultCryptoUsageData> {
  final Value<String> accountId;
  final Value<int> encryptions;
  final Value<int> rowid;
  const VaultCryptoUsageCompanion({
    this.accountId = const Value.absent(),
    this.encryptions = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultCryptoUsageCompanion.insert({
    required String accountId,
    this.encryptions = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<VaultCryptoUsageData> custom({
    Expression<String>? accountId,
    Expression<int>? encryptions,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (encryptions != null) 'encryptions': encryptions,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultCryptoUsageCompanion copyWith(
      {Value<String>? accountId, Value<int>? encryptions, Value<int>? rowid}) {
    return VaultCryptoUsageCompanion(
      accountId: accountId ?? this.accountId,
      encryptions: encryptions ?? this.encryptions,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (encryptions.present) {
      map['encryptions'] = Variable<int>(encryptions.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultCryptoUsageCompanion(')
          ..write('accountId: $accountId, ')
          ..write('encryptions: $encryptions, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$VaultDatabase extends GeneratedDatabase {
  _$VaultDatabase(QueryExecutor e) : super(e);
  $VaultDatabaseManager get managers => $VaultDatabaseManager(this);
  late final $VaultNotesTable vaultNotes = $VaultNotesTable(this);
  late final $VaultCategoriesTable vaultCategories =
      $VaultCategoriesTable(this);
  late final $VaultFilesTable vaultFiles = $VaultFilesTable(this);
  late final $VaultCryptoUsageTable vaultCryptoUsage =
      $VaultCryptoUsageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [vaultNotes, vaultCategories, vaultFiles, vaultCryptoUsage];
}

typedef $$VaultNotesTableCreateCompanionBuilder = VaultNotesCompanion Function({
  required String id,
  required String accountId,
  required Uint8List nonce,
  required Uint8List cipherText,
  required Uint8List mac,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$VaultNotesTableUpdateCompanionBuilder = VaultNotesCompanion Function({
  Value<String> id,
  Value<String> accountId,
  Value<Uint8List> nonce,
  Value<Uint8List> cipherText,
  Value<Uint8List> mac,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$VaultNotesTableFilterComposer
    extends Composer<_$VaultDatabase, $VaultNotesTable> {
  $$VaultNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$VaultNotesTableOrderingComposer
    extends Composer<_$VaultDatabase, $VaultNotesTable> {
  $$VaultNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VaultNotesTableAnnotationComposer
    extends Composer<_$VaultDatabase, $VaultNotesTable> {
  $$VaultNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<Uint8List> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => column);

  GeneratedColumn<Uint8List> get mac =>
      $composableBuilder(column: $table.mac, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VaultNotesTableTableManager extends RootTableManager<
    _$VaultDatabase,
    $VaultNotesTable,
    VaultNote,
    $$VaultNotesTableFilterComposer,
    $$VaultNotesTableOrderingComposer,
    $$VaultNotesTableAnnotationComposer,
    $$VaultNotesTableCreateCompanionBuilder,
    $$VaultNotesTableUpdateCompanionBuilder,
    (VaultNote, BaseReferences<_$VaultDatabase, $VaultNotesTable, VaultNote>),
    VaultNote,
    PrefetchHooks Function()> {
  $$VaultNotesTableTableManager(_$VaultDatabase db, $VaultNotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<Uint8List> nonce = const Value.absent(),
            Value<Uint8List> cipherText = const Value.absent(),
            Value<Uint8List> mac = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultNotesCompanion(
            id: id,
            accountId: accountId,
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required Uint8List nonce,
            required Uint8List cipherText,
            required Uint8List mac,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultNotesCompanion.insert(
            id: id,
            accountId: accountId,
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaultNotesTableProcessedTableManager = ProcessedTableManager<
    _$VaultDatabase,
    $VaultNotesTable,
    VaultNote,
    $$VaultNotesTableFilterComposer,
    $$VaultNotesTableOrderingComposer,
    $$VaultNotesTableAnnotationComposer,
    $$VaultNotesTableCreateCompanionBuilder,
    $$VaultNotesTableUpdateCompanionBuilder,
    (VaultNote, BaseReferences<_$VaultDatabase, $VaultNotesTable, VaultNote>),
    VaultNote,
    PrefetchHooks Function()>;
typedef $$VaultCategoriesTableCreateCompanionBuilder = VaultCategoriesCompanion
    Function({
  required String id,
  required String accountId,
  required Uint8List nonce,
  required Uint8List cipherText,
  required Uint8List mac,
  Value<int> rowid,
});
typedef $$VaultCategoriesTableUpdateCompanionBuilder = VaultCategoriesCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<Uint8List> nonce,
  Value<Uint8List> cipherText,
  Value<Uint8List> mac,
  Value<int> rowid,
});

class $$VaultCategoriesTableFilterComposer
    extends Composer<_$VaultDatabase, $VaultCategoriesTable> {
  $$VaultCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnFilters(column));
}

class $$VaultCategoriesTableOrderingComposer
    extends Composer<_$VaultDatabase, $VaultCategoriesTable> {
  $$VaultCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnOrderings(column));
}

class $$VaultCategoriesTableAnnotationComposer
    extends Composer<_$VaultDatabase, $VaultCategoriesTable> {
  $$VaultCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<Uint8List> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => column);

  GeneratedColumn<Uint8List> get mac =>
      $composableBuilder(column: $table.mac, builder: (column) => column);
}

class $$VaultCategoriesTableTableManager extends RootTableManager<
    _$VaultDatabase,
    $VaultCategoriesTable,
    VaultCategory,
    $$VaultCategoriesTableFilterComposer,
    $$VaultCategoriesTableOrderingComposer,
    $$VaultCategoriesTableAnnotationComposer,
    $$VaultCategoriesTableCreateCompanionBuilder,
    $$VaultCategoriesTableUpdateCompanionBuilder,
    (
      VaultCategory,
      BaseReferences<_$VaultDatabase, $VaultCategoriesTable, VaultCategory>
    ),
    VaultCategory,
    PrefetchHooks Function()> {
  $$VaultCategoriesTableTableManager(
      _$VaultDatabase db, $VaultCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<Uint8List> nonce = const Value.absent(),
            Value<Uint8List> cipherText = const Value.absent(),
            Value<Uint8List> mac = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultCategoriesCompanion(
            id: id,
            accountId: accountId,
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required Uint8List nonce,
            required Uint8List cipherText,
            required Uint8List mac,
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultCategoriesCompanion.insert(
            id: id,
            accountId: accountId,
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaultCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$VaultDatabase,
    $VaultCategoriesTable,
    VaultCategory,
    $$VaultCategoriesTableFilterComposer,
    $$VaultCategoriesTableOrderingComposer,
    $$VaultCategoriesTableAnnotationComposer,
    $$VaultCategoriesTableCreateCompanionBuilder,
    $$VaultCategoriesTableUpdateCompanionBuilder,
    (
      VaultCategory,
      BaseReferences<_$VaultDatabase, $VaultCategoriesTable, VaultCategory>
    ),
    VaultCategory,
    PrefetchHooks Function()>;
typedef $$VaultFilesTableCreateCompanionBuilder = VaultFilesCompanion Function({
  required String id,
  required String accountId,
  required Uint8List metadataNonce,
  required Uint8List metadataCipherText,
  required Uint8List metadataMac,
  required Uint8List nonce,
  required Uint8List cipherText,
  required Uint8List mac,
  required int plainSize,
  Value<int> rowid,
});
typedef $$VaultFilesTableUpdateCompanionBuilder = VaultFilesCompanion Function({
  Value<String> id,
  Value<String> accountId,
  Value<Uint8List> metadataNonce,
  Value<Uint8List> metadataCipherText,
  Value<Uint8List> metadataMac,
  Value<Uint8List> nonce,
  Value<Uint8List> cipherText,
  Value<Uint8List> mac,
  Value<int> plainSize,
  Value<int> rowid,
});

class $$VaultFilesTableFilterComposer
    extends Composer<_$VaultDatabase, $VaultFilesTable> {
  $$VaultFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get metadataNonce => $composableBuilder(
      column: $table.metadataNonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get metadataCipherText => $composableBuilder(
      column: $table.metadataCipherText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get metadataMac => $composableBuilder(
      column: $table.metadataMac, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get plainSize => $composableBuilder(
      column: $table.plainSize, builder: (column) => ColumnFilters(column));
}

class $$VaultFilesTableOrderingComposer
    extends Composer<_$VaultDatabase, $VaultFilesTable> {
  $$VaultFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get metadataNonce => $composableBuilder(
      column: $table.metadataNonce,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get metadataCipherText => $composableBuilder(
      column: $table.metadataCipherText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get metadataMac => $composableBuilder(
      column: $table.metadataMac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get plainSize => $composableBuilder(
      column: $table.plainSize, builder: (column) => ColumnOrderings(column));
}

class $$VaultFilesTableAnnotationComposer
    extends Composer<_$VaultDatabase, $VaultFilesTable> {
  $$VaultFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<Uint8List> get metadataNonce => $composableBuilder(
      column: $table.metadataNonce, builder: (column) => column);

  GeneratedColumn<Uint8List> get metadataCipherText => $composableBuilder(
      column: $table.metadataCipherText, builder: (column) => column);

  GeneratedColumn<Uint8List> get metadataMac => $composableBuilder(
      column: $table.metadataMac, builder: (column) => column);

  GeneratedColumn<Uint8List> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<Uint8List> get cipherText => $composableBuilder(
      column: $table.cipherText, builder: (column) => column);

  GeneratedColumn<Uint8List> get mac =>
      $composableBuilder(column: $table.mac, builder: (column) => column);

  GeneratedColumn<int> get plainSize =>
      $composableBuilder(column: $table.plainSize, builder: (column) => column);
}

class $$VaultFilesTableTableManager extends RootTableManager<
    _$VaultDatabase,
    $VaultFilesTable,
    VaultFile,
    $$VaultFilesTableFilterComposer,
    $$VaultFilesTableOrderingComposer,
    $$VaultFilesTableAnnotationComposer,
    $$VaultFilesTableCreateCompanionBuilder,
    $$VaultFilesTableUpdateCompanionBuilder,
    (VaultFile, BaseReferences<_$VaultDatabase, $VaultFilesTable, VaultFile>),
    VaultFile,
    PrefetchHooks Function()> {
  $$VaultFilesTableTableManager(_$VaultDatabase db, $VaultFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<Uint8List> metadataNonce = const Value.absent(),
            Value<Uint8List> metadataCipherText = const Value.absent(),
            Value<Uint8List> metadataMac = const Value.absent(),
            Value<Uint8List> nonce = const Value.absent(),
            Value<Uint8List> cipherText = const Value.absent(),
            Value<Uint8List> mac = const Value.absent(),
            Value<int> plainSize = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultFilesCompanion(
            id: id,
            accountId: accountId,
            metadataNonce: metadataNonce,
            metadataCipherText: metadataCipherText,
            metadataMac: metadataMac,
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            plainSize: plainSize,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required Uint8List metadataNonce,
            required Uint8List metadataCipherText,
            required Uint8List metadataMac,
            required Uint8List nonce,
            required Uint8List cipherText,
            required Uint8List mac,
            required int plainSize,
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultFilesCompanion.insert(
            id: id,
            accountId: accountId,
            metadataNonce: metadataNonce,
            metadataCipherText: metadataCipherText,
            metadataMac: metadataMac,
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            plainSize: plainSize,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaultFilesTableProcessedTableManager = ProcessedTableManager<
    _$VaultDatabase,
    $VaultFilesTable,
    VaultFile,
    $$VaultFilesTableFilterComposer,
    $$VaultFilesTableOrderingComposer,
    $$VaultFilesTableAnnotationComposer,
    $$VaultFilesTableCreateCompanionBuilder,
    $$VaultFilesTableUpdateCompanionBuilder,
    (VaultFile, BaseReferences<_$VaultDatabase, $VaultFilesTable, VaultFile>),
    VaultFile,
    PrefetchHooks Function()>;
typedef $$VaultCryptoUsageTableCreateCompanionBuilder
    = VaultCryptoUsageCompanion Function({
  required String accountId,
  Value<int> encryptions,
  Value<int> rowid,
});
typedef $$VaultCryptoUsageTableUpdateCompanionBuilder
    = VaultCryptoUsageCompanion Function({
  Value<String> accountId,
  Value<int> encryptions,
  Value<int> rowid,
});

class $$VaultCryptoUsageTableFilterComposer
    extends Composer<_$VaultDatabase, $VaultCryptoUsageTable> {
  $$VaultCryptoUsageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get encryptions => $composableBuilder(
      column: $table.encryptions, builder: (column) => ColumnFilters(column));
}

class $$VaultCryptoUsageTableOrderingComposer
    extends Composer<_$VaultDatabase, $VaultCryptoUsageTable> {
  $$VaultCryptoUsageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get encryptions => $composableBuilder(
      column: $table.encryptions, builder: (column) => ColumnOrderings(column));
}

class $$VaultCryptoUsageTableAnnotationComposer
    extends Composer<_$VaultDatabase, $VaultCryptoUsageTable> {
  $$VaultCryptoUsageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get encryptions => $composableBuilder(
      column: $table.encryptions, builder: (column) => column);
}

class $$VaultCryptoUsageTableTableManager extends RootTableManager<
    _$VaultDatabase,
    $VaultCryptoUsageTable,
    VaultCryptoUsageData,
    $$VaultCryptoUsageTableFilterComposer,
    $$VaultCryptoUsageTableOrderingComposer,
    $$VaultCryptoUsageTableAnnotationComposer,
    $$VaultCryptoUsageTableCreateCompanionBuilder,
    $$VaultCryptoUsageTableUpdateCompanionBuilder,
    (
      VaultCryptoUsageData,
      BaseReferences<_$VaultDatabase, $VaultCryptoUsageTable,
          VaultCryptoUsageData>
    ),
    VaultCryptoUsageData,
    PrefetchHooks Function()> {
  $$VaultCryptoUsageTableTableManager(
      _$VaultDatabase db, $VaultCryptoUsageTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultCryptoUsageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultCryptoUsageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultCryptoUsageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> accountId = const Value.absent(),
            Value<int> encryptions = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultCryptoUsageCompanion(
            accountId: accountId,
            encryptions: encryptions,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String accountId,
            Value<int> encryptions = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaultCryptoUsageCompanion.insert(
            accountId: accountId,
            encryptions: encryptions,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaultCryptoUsageTableProcessedTableManager = ProcessedTableManager<
    _$VaultDatabase,
    $VaultCryptoUsageTable,
    VaultCryptoUsageData,
    $$VaultCryptoUsageTableFilterComposer,
    $$VaultCryptoUsageTableOrderingComposer,
    $$VaultCryptoUsageTableAnnotationComposer,
    $$VaultCryptoUsageTableCreateCompanionBuilder,
    $$VaultCryptoUsageTableUpdateCompanionBuilder,
    (
      VaultCryptoUsageData,
      BaseReferences<_$VaultDatabase, $VaultCryptoUsageTable,
          VaultCryptoUsageData>
    ),
    VaultCryptoUsageData,
    PrefetchHooks Function()>;

class $VaultDatabaseManager {
  final _$VaultDatabase _db;
  $VaultDatabaseManager(this._db);
  $$VaultNotesTableTableManager get vaultNotes =>
      $$VaultNotesTableTableManager(_db, _db.vaultNotes);
  $$VaultCategoriesTableTableManager get vaultCategories =>
      $$VaultCategoriesTableTableManager(_db, _db.vaultCategories);
  $$VaultFilesTableTableManager get vaultFiles =>
      $$VaultFilesTableTableManager(_db, _db.vaultFiles);
  $$VaultCryptoUsageTableTableManager get vaultCryptoUsage =>
      $$VaultCryptoUsageTableTableManager(_db, _db.vaultCryptoUsage);
}
