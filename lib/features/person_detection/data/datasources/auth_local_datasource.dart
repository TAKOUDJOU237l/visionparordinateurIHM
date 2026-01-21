import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../models/user_model.dart';
import 'database_helper.dart';

/// Data source local pour l'authentification (SQLite)
class AuthLocalDataSource {
  final DatabaseHelper dbHelper;
  final Uuid uuid;

  AuthLocalDataSource({
    required this.dbHelper,
    Uuid? uuid,
  }) : uuid = uuid ?? const Uuid();

  /// Inscription d'un nouvel utilisateur
  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    final db = await dbHelper.database;

    // Hasher le mot de passe
    final passwordHash = _hashPassword(password);

    // Créer l'utilisateur
    final userId = uuid.v4();
    final now = DateTime.now();

    final user = UserModel(
      id: userId,
      email: email.toLowerCase(),
      username: username,
      fullName: fullName,
      createdAt: now,
    );

    // Insérer dans la base de données
    await db.insert(
      'users',
      {
        ...user.toDatabase(),
        'password_hash': passwordHash,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return user;
  }

  /// Connexion d'un utilisateur
  Future<UserModel> login(String email, String password) async {
    final db = await dbHelper.database;

    // Récupérer l'utilisateur par email
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('Email ou mot de passe incorrect');
    }

    final userData = results.first;
    final storedPasswordHash = userData['password_hash'] as String;

    // Vérifier le mot de passe
    if (!_verifyPassword(password, storedPasswordHash)) {
      throw Exception('Email ou mot de passe incorrect');
    }

    return UserModel.fromDatabase(userData);
  }

  /// Enregistrer la session utilisateur
  Future<void> saveSession(String userId) async {
    final db = await dbHelper.database;

    // Supprimer l'ancienne session
    await db.delete('session');

    // Créer la nouvelle session
    await db.insert(
      'session',
      {'id': 1, 'user_id': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Récupérer l'utilisateur de la session active
  Future<UserModel?> getCurrentUser() async {
    final db = await dbHelper.database;

    // Récupérer la session
    final sessionResults = await db.query('session', limit: 1);

    if (sessionResults.isEmpty) {
      return null;
    }

    final userId = sessionResults.first['user_id'] as String;

    // Récupérer l'utilisateur
    final userResults = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (userResults.isEmpty) {
      return null;
    }

    return UserModel.fromDatabase(userResults.first);
  }

  /// Déconnexion
  Future<void> logout() async {
    final db = await dbHelper.database;
    await db.delete('session');
  }

  /// Mettre à jour le profil
  Future<UserModel> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? profileImagePath,
  }) async {
    final db = await dbHelper.database;

    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (username != null) updateData['username'] = username;
    if (fullName != null) updateData['full_name'] = fullName;
    if (profileImagePath != null) {
      updateData['profile_image_path'] = profileImagePath;
    }

    await db.update(
      'users',
      updateData,
      where: 'id = ?',
      whereArgs: [userId],
    );

    // Récupérer l'utilisateur mis à jour
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    return UserModel.fromDatabase(results.first);
  }

  /// Changer le mot de passe
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final db = await dbHelper.database;

    // Vérifier le mot de passe actuel
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('Utilisateur non trouvé');
    }

    final storedPasswordHash = results.first['password_hash'] as String;

    if (!_verifyPassword(currentPassword, storedPasswordHash)) {
      throw Exception('Mot de passe actuel incorrect');
    }

    // Hasher le nouveau mot de passe
    final newPasswordHash = _hashPassword(newPassword);

    // Mettre à jour
    await db.update(
      'users',
      {
        'password_hash': newPasswordHash,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Supprimer le compte
  Future<void> deleteAccount(String userId) async {
    final db = await dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  /// Vérifier si un email existe
  Future<bool> emailExists(String email) async {
    final db = await dbHelper.database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  /// Vérifier si un username existe
  Future<bool> usernameExists(String username) async {
    final db = await dbHelper.database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  /// Hasher un mot de passe
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Vérifier un mot de passe
  bool _verifyPassword(String password, String storedHash) {
    final hash = _hashPassword(password);
    return hash == storedHash;
  }
}