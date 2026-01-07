import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Classe de base abstraite pour tous les use cases de l'application.
///
/// Un use case représente une action métier atomique.
/// Il prend des paramètres en entrée et retourne un résultat.
///
/// [Type] - Le type de retour en cas de succès
/// [Params] - Le type des paramètres d'entrée
abstract class UseCase<Type, Params> {
  /// Exécute le use case avec les paramètres fournis.
  ///
  /// Retourne [Right(Type)] en cas de succès,
  /// ou [Left(Failure)] en cas d'erreur.
  Future<Either<Failure, Type>> call(Params params);
}

/// Classe utilisée quand un use case ne nécessite pas de paramètres.
class NoParams {
  const NoParams();
}
