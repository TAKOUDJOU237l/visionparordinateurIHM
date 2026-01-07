/// Exception serveur / API
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

/// Exception de cache / stockage local
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception de réseau / connectivité
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception de permissions
class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}

/// Exception de détection (modèle IA, traitement)
class DetectionException implements Exception {
  final String message;
  const DetectionException(this.message);

  @override
  String toString() => 'DetectionException: $message';
}
