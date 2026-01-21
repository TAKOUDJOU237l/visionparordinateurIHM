import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper pour gérer la base de données SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smartheadcount.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        full_name TEXT,
        profile_image_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Table pour stocker la session (utilisateur connecté)
    await db.execute('''
      CREATE TABLE session (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        user_id TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Index pour améliorer les performances
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_users_username ON users(username)');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  /// Réinitialise complètement la base de données (utile pour le développement)
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smartheadcount.db');
    
    // Fermer la connexion existante
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    
    // Supprimer la base de données
    await deleteDatabase(path);
    
    // Recréer la base de données
    _database = await _initDB('smartheadcount.db');
  }
}