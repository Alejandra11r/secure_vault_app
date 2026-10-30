import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'vault_database.g.dart';

class VaultNotes extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  BlobColumn get nonce => blob()();
  BlobColumn get cipherText => blob()();
  BlobColumn get mac => blob()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VaultCategories extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  BlobColumn get nonce => blob()();
  BlobColumn get cipherText => blob()();
  BlobColumn get mac => blob()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VaultFiles extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  BlobColumn get metadataNonce => blob()();
  BlobColumn get metadataCipherText => blob()();
  BlobColumn get metadataMac => blob()();
  BlobColumn get nonce => blob()();
  BlobColumn get cipherText => blob()();
  BlobColumn get mac => blob()();
  IntColumn get plainSize => integer()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VaultCryptoUsage extends Table {
  TextColumn get accountId => text()();
  IntColumn get encryptions => integer().withDefault(const Constant(0))();
  @override
  Set<Column<Object>> get primaryKey => {accountId};
}

@DriftDatabase(
    tables: [VaultNotes, VaultCategories, VaultFiles, VaultCryptoUsage],)
class VaultDatabase extends _$VaultDatabase {
  VaultDatabase()
      : super(driftDatabase(
          name: 'secure_vault',
          native: DriftNativeOptions(
            setup: (database) {
              database.execute('PRAGMA secure_delete = ON');
              database.execute('PRAGMA journal_mode = DELETE');
              database.execute('PRAGMA foreign_keys = ON');
            },
          ),
        ),);
  VaultDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Future<void> deleteAccountData(String accountId) async {
    await transaction(() async {
      await (delete(vaultNotes)
            ..where((row) => row.accountId.equals(accountId)))
          .go();
      await (delete(vaultCategories)
            ..where((row) => row.accountId.equals(accountId)))
          .go();
      await (delete(vaultFiles)
            ..where((row) => row.accountId.equals(accountId)))
          .go();
      await (delete(vaultCryptoUsage)
            ..where((row) => row.accountId.equals(accountId)))
          .go();
    });
  }

  Future<void> reserveEncryption(String accountId) async {
    await transaction(() async {
      final row = await (select(vaultCryptoUsage)
            ..where((r) => r.accountId.equals(accountId)))
          .getSingleOrNull();
      final count = row?.encryptions ?? 0;
      if (count >= 1 << 20) throw StateError('Vault encryption limit reached.');
      await into(vaultCryptoUsage).insertOnConflictUpdate(
        VaultCryptoUsageCompanion.insert(
            accountId: accountId, encryptions: Value(count + 1),),
      );
    });
  }
}
