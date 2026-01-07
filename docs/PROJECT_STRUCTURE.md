# Structure du projet SmartHeadCount

Ce document fournit un aperçu complet de la structure du projet.

---

## Arborescence complète

```
SmartHeadCount/
│
├── .git/                                   # Historique Git
├── .gitignore                              # Fichiers ignorés par Git
│
├── README.md                               # Documentation principale
├── LICENSE                                 # Licence MIT
├── CONTRIBUTING.md                         # Guide de contribution
├── DEVELOPMENT.md                          # Documentation technique
│
├── pubspec.yaml                            # Configuration du projet Flutter
├── analysis_options.yaml                   # Configuration du linter
│
├── docs/                                   # Documentation du projet
│   ├── PROJECT_STRUCTURE.md               # Ce fichier
│   ├── USER_CENTERED_DESIGN.md            # Méthodologie UCD
│   ├── DESIGN_SYSTEM.md                   # Charte graphique
│   ├── architecture/                      # Diagrammes d'architecture
│   ├── design/                            # Maquettes et prototypes
│   └── ihm/                               # Documentation IHM
│
├── assets/                                # Ressources de l'application
│   ├── images/                           # Images et illustrations
│   ├── icons/                            # Icônes de l'application
│   ├── fonts/                            # Polices personnalisées
│   ├── models/                           # Modèles TensorFlow Lite
│   └── animations/                       # Animations Lottie
│
├── lib/                                   # Code source Dart/Flutter
│   ├── main.dart                         # Point d'entrée de l'app
│   ├── app.dart                          # Configuration de l'app
│   │
│   ├── core/                             # Code partagé entre features
│   │   ├── constants/
│   │   │   └── app_constants.dart       # Constantes globales
│   │   ├── theme/
│   │   │   ├── app_colors.dart          # Palette de couleurs
│   │   │   └── app_theme.dart           # Configuration du thème
│   │   ├── router/
│   │   │   └── app_router.dart          # Configuration de la navigation
│   │   ├── utils/
│   │   │   ├── dependency_injection.dart # GetIt configuration
│   │   │   └── helpers.dart             # Fonctions utilitaires
│   │   ├── errors/
│   │   │   ├── failures.dart            # Classes d'erreurs métier
│   │   │   └── exceptions.dart          # Exceptions techniques
│   │   ├── usecases/
│   │   │   └── usecase.dart             # Classe de base use cases
│   │   └── network/
│   │       └── network_info.dart        # Vérification connectivité
│   │
│   ├── features/                         # Fonctionnalités métier
│   │   │
│   │   ├── person_detection/            # Feature principale
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── person_detection_local_datasource.dart
│   │   │   │   │   └── person_detection_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── detection_result_model.dart
│   │   │   │   │   └── bounding_box_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── person_detection_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── detection_result.dart
│   │   │   │   │   └── bounding_box.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── person_detection_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── detect_persons.dart
│   │   │   │       ├── get_detection_history.dart
│   │   │   │       └── save_detection_result.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── camera_page.dart
│   │   │       │   ├── result_page.dart
│   │   │       │   └── history_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── detection_overlay.dart
│   │   │       │   ├── person_counter.dart
│   │   │       │   └── confidence_indicator.dart
│   │   │       └── providers/
│   │   │           ├── detection_provider.dart
│   │   │           └── history_provider.dart
│   │   │
│   │   ├── onboarding/                  # Écrans d'introduction
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── onboarding_page.dart
│   │   │       └── widgets/
│   │   │           └── onboarding_slide.dart
│   │   │
│   │   └── settings/                    # Paramètres
│   │       └── presentation/
│   │           ├── pages/
│   │           │   └── settings_page.dart
│   │           └── widgets/
│   │               └── setting_tile.dart
│   │
│   └── shared/                          # Composants partagés
│       ├── widgets/
│       │   ├── custom_button.dart
│       │   ├── loading_indicator.dart
│       │   ├── error_widget.dart
│       │   └── custom_app_bar.dart
│       └── utils/
│           ├── image_utils.dart
│           └── date_formatter.dart
│
└── test/                                # Tests
    ├── unit/                           # Tests unitaires
    │   ├── domain/
    │   │   ├── entities/
    │   │   └── usecases/
    │   └── data/
    │       ├── models/
    │       └── repositories/
    ├── widget/                         # Tests de widgets
    │   └── features/
    └── integration/                    # Tests d'intégration
        └── app_test.dart
```

---

## Fichiers principaux

### Configuration du projet

| Fichier | Description |
|---------|-------------|
| `pubspec.yaml` | Dépendances, assets, version de l'app |
| `analysis_options.yaml` | Règles de lint et analyse statique |
| `.gitignore` | Fichiers exclus du versioning Git |

### Documentation

| Fichier | Description |
|---------|-------------|
| `README.md` | Documentation principale du projet |
| `DEVELOPMENT.md` | Guide technique pour développeurs |
| `CONTRIBUTING.md` | Guide de contribution |
| `LICENSE` | Licence MIT du projet |

### Documentation IHM

| Fichier | Description |
|---------|-------------|
| `docs/USER_CENTERED_DESIGN.md` | Méthodologie UCD complète |
| `docs/DESIGN_SYSTEM.md` | Charte graphique et design system |
| `docs/PROJECT_STRUCTURE.md` | Structure du projet (ce fichier) |

---

## Répartition par couche (Clean Architecture)

### Presentation Layer (UI)

```
lib/features/*/presentation/
├── pages/          # Écrans complets
├── widgets/        # Composants UI
└── providers/      # State management (Riverpod)
```

**Responsabilité** : Affichage et interaction utilisateur

### Domain Layer (Business Logic)

```
lib/features/*/domain/
├── entities/       # Objets métier (immuables)
├── repositories/   # Interfaces des repositories
└── usecases/       # Actions métier atomiques
```

**Responsabilité** : Logique métier pure, indépendante de toute technologie

### Data Layer (Infrastructure)

```
lib/features/*/data/
├── datasources/    # Accès aux sources (API, DB)
├── models/         # Représentation des données (JSON, DB)
└── repositories/   # Implémentation des interfaces domain
```

**Responsabilité** : Accès aux données (API, BDD, fichiers)

---

## Convention de nommage des fichiers

### Règles générales

- **snake_case** pour tous les fichiers Dart
- Nom descriptif et explicite
- Suffixe indiquant le type de fichier

### Exemples

| Type | Convention | Exemple |
|------|-----------|---------|
| Page | `*_page.dart` | `camera_page.dart` |
| Widget | `*_widget.dart` ou nom simple | `detection_overlay.dart` |
| Provider | `*_provider.dart` | `detection_provider.dart` |
| Entity | Nom simple | `detection_result.dart` |
| Model | `*_model.dart` | `detection_result_model.dart` |
| Repository | `*_repository.dart` | `person_detection_repository.dart` |
| Repository Impl | `*_repository_impl.dart` | `person_detection_repository_impl.dart` |
| UseCase | Verbe à l'infinitif | `detect_persons.dart` |
| DataSource | `*_datasource.dart` | `person_detection_local_datasource.dart` |
| Test | `*_test.dart` | `detect_persons_test.dart` |

---

## Flux de données

### Exemple : Détection de personnes

```
User Action (UI)
    ↓
Page/Widget
    ↓
Provider (Riverpod)
    ↓
UseCase (Domain)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
DataSource (API/Local DB)
    ↓
External Data (TensorFlow, API)
    ↓
← Data flows back ←
    ↓
UI updates
```

### Détail des étapes

1. **User Action** : L'utilisateur clique sur "Détecter"
2. **Widget** : Le widget `CameraPage` capture l'action
3. **Provider** : Appelle `detectionProvider.detectPersons(imagePath)`
4. **UseCase** : `DetectPersons` use case exécuté
5. **Repository** : Interface `PersonDetectionRepository` appelée
6. **Implementation** : `PersonDetectionRepositoryImpl` exécute la logique
7. **DataSource** : `PersonDetectionLocalDataSource` utilise TensorFlow Lite
8. **Result** : Les données remontent jusqu'au UI
9. **UI Update** : Le widget affiche le résultat

---

## Assets et ressources

### Images

```
assets/images/
├── splash_logo.png          # Logo de démarrage
├── onboarding_1.png         # Illustrations onboarding
├── onboarding_2.png
├── onboarding_3.png
└── placeholder.png          # Image de remplacement
```

### Icônes

```
assets/icons/
├── app_icon.png             # Icône de l'application
├── detection.svg            # Icône de détection
├── history.svg              # Icône historique
└── settings.svg             # Icône paramètres
```

### Polices

```
assets/fonts/
├── Inter-Regular.ttf
├── Inter-Medium.ttf
├── Inter-SemiBold.ttf
├── Inter-Bold.ttf
├── Roboto-Regular.ttf
├── Roboto-Medium.ttf
└── Roboto-Bold.ttf
```

### Modèles IA

```
assets/models/
├── person_detection_model.tflite    # Modèle TensorFlow Lite
└── labels.txt                       # Labels des classes
```

### Animations

```
assets/animations/
├── loading.json                     # Animation de chargement
├── success.json                     # Animation de succès
└── error.json                       # Animation d'erreur
```

---

## Tests

### Structure des tests

```
test/
├── unit/                           # Tests unitaires
│   ├── domain/
│   │   ├── entities/
│   │   │   └── detection_result_test.dart
│   │   └── usecases/
│   │       └── detect_persons_test.dart
│   └── data/
│       ├── models/
│       │   └── detection_result_model_test.dart
│       └── repositories/
│           └── person_detection_repository_impl_test.dart
│
├── widget/                         # Tests de widgets
│   └── features/
│       └── person_detection/
│           ├── pages/
│           │   └── camera_page_test.dart
│           └── widgets/
│               └── detection_overlay_test.dart
│
└── integration/                    # Tests d'intégration
    └── app_test.dart
```

### Conventions de test

- **Fichier** : `nom_fichier_test.dart`
- **Groupe** : `group('NomClasse', () { })`
- **Test** : `test('should ... when ...', () { })`

---

## Prochaines étapes

### À implémenter

1. **Splash Screen** : Écran de démarrage avec logo
2. **Onboarding** : 3-4 slides d'introduction
3. **Camera Integration** : Intégration de la caméra
4. **TensorFlow Lite** : Intégration du modèle d'IA
5. **Detection UI** : Interface de détection avec overlay
6. **History** : Système d'historique avec Hive
7. **Settings** : Page de paramètres
8. **Export** : Fonctionnalité d'export (PDF, Excel, CSV)

### Features futures

- 🎥 Détection en temps réel via flux vidéo
- 📊 Statistiques avancées et graphiques
- ☁️ Synchronisation cloud
- 🌐 Mode multi-utilisateurs
- 🔔 Notifications et alertes
- 📍 Géolocalisation des détections

---

**Documentation maintenue à jour**
**Dernière mise à jour** : Janvier 2026
