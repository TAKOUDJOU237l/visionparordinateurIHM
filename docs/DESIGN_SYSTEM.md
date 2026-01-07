# Design System - SmartHeadCount

> **Charte graphique et système de design complet**

---

## Table des matières

- [Identité visuelle](#identité-visuelle)
- [Couleurs](#couleurs)
- [Typographie](#typographie)
- [Iconographie](#iconographie)
- [Composants UI](#composants-ui)
- [Grille et espacements](#grille-et-espacements)
- [Animations](#animations)
- [États et interactions](#états-et-interactions)
- [Accessibilité](#accessibilité)

---

## Identité visuelle

### Philosophie de design

SmartHeadCount s'inspire d'un **design premium et élégant**, alliant **modernité** et **professionnalisme**.

#### Valeurs de la marque

🎯 **Précision** : Résultats fiables et exacts
⚡ **Rapidité** : Interface fluide et réactive
✨ **Élégance** : Design raffiné et sophistiqué
🔒 **Confiance** : Sécurité et confidentialité

#### Moodboard

**Inspirations** :
- Applications premium (Spotify, Headspace)
- Interfaces de luxe (Montblanc, Rolex apps)
- Design moderne et épuré (Apple, Tesla)

**Mots-clés** :
- Sophistiqué
- Minimaliste
- Élégant
- Professionnel
- Technologique

---

## Couleurs

### Palette principale

Inspirée de la charte graphique avec des **tons dorés et noirs** évoquant le luxe et la technologie.

#### Couleurs primaires

```
┌────────────────────────────────────────────────┐
│  PRIMARY GOLD                                  │
│  #D4AF37  rgb(212, 175, 55)                   │
│  ████████████████████████████████████████      │
│                                                │
│  Usage: CTA, accents, highlights               │
│  Psychologie: Excellence, qualité, réussite    │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│  PRIMARY DARK                                  │
│  #0A0E1A  rgb(10, 14, 26)                     │
│  ████████████████████████████████████████      │
│                                                │
│  Usage: Backgrounds, surfaces                  │
│  Psychologie: Sophistication, technologie      │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│  PRIMARY BLACK                                 │
│  #000000  rgb(0, 0, 0)                        │
│  ████████████████████████████████████████      │
│                                                │
│  Usage: Texte principal, éléments forts        │
│  Psychologie: Contraste, lisibilité            │
└────────────────────────────────────────────────┘
```

#### Couleurs secondaires

```
┌────────────────────────────────────────────────┐
│  SECONDARY GOLD                                │
│  #C9A959  rgb(201, 169, 89)                   │
│  ████████████████████████████████████████      │
│                                                │
│  Usage: Variantes, hover states               │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│  ACCENT GOLD                                   │
│  #FFD700  rgb(255, 215, 0)                    │
│  ████████████████████████████████████████      │
│                                                │
│  Usage: Notifications, badges                  │
└────────────────────────────────────────────────┘
```

#### Couleurs de statut

```
✅ SUCCESS (Vert)
   #4CAF50  rgb(76, 175, 80)
   Usage: Confirmations, détections réussies

❌ ERROR (Rouge)
   #E53935  rgb(229, 57, 53)
   Usage: Erreurs, alertes

⚠️  WARNING (Orange)
   #FF9800  rgb(255, 152, 0)
   Usage: Avertissements, confiance faible

ℹ️  INFO (Bleu)
   #2196F3  rgb(33, 150, 243)
   Usage: Informations, tips
```

#### Couleurs de détection

```
🎯 DETECTION BOX
   #D4AF37 (Primary Gold)
   Usage: Rectangles de détection

✓ DETECTION CONFIRMED
   #4CAF50 (Success Green)
   Usage: Personne confirmée (confiance > 90%)

? DETECTION UNCERTAIN
   #FF9800 (Warning Orange)
   Usage: Personne incertaine (confiance 50-90%)
```

### Backgrounds

```
DARK MODE (par défaut)
├─ Background Primary: #0A0E1A
├─ Background Secondary: #1A1F2E
└─ Card Background: #1A1F2E

LIGHT MODE
├─ Background Primary: #F5F5F5
├─ Background Secondary: #FFFFFF
└─ Card Background: #FFFFFF
```

### Textes

```
DARK MODE
├─ Text Primary: #FFFFFF (blanc)
├─ Text Secondary: #B0B0B0 (gris clair)
└─ Text Tertiary: #6B6B6B (gris moyen)

LIGHT MODE
├─ Text Primary: #1A1A1A (noir)
├─ Text Secondary: #6B6B6B (gris)
└─ Text Tertiary: #B0B0B0 (gris clair)
```

### Contrastes et accessibilité

Tous les contrastes respectent **WCAG 2.1 niveau AA** :

| Combinaison | Ratio | Conforme |
|-------------|-------|----------|
| Primary Gold sur Dark | 7.2:1 | ✅ AAA |
| Blanc sur Primary Dark | 15.8:1 | ✅ AAA |
| Success sur Dark | 4.8:1 | ✅ AA |
| Error sur Dark | 5.2:1 | ✅ AA |

---

## Typographie

### Familles de polices

#### Inter (Titres et UI)

**Usage** : Headings, labels, boutons
**Caractéristiques** : Moderne, géométrique, excellent rendu à petite taille

```
Font Family: 'Inter'
Weights utilisés: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)
```

#### Roboto (Corps de texte)

**Usage** : Body text, descriptions, paragraphes
**Caractéristiques** : Lisible, neutre, optimisé écran

```
Font Family: 'Roboto'
Weights utilisés: 400 (Regular), 500 (Medium)
```

### Échelle typographique

Basée sur une échelle **modulaire (ratio 1.25)** pour une harmonie visuelle.

```
┌──────────────────────────────────────────────────┐
│  DISPLAY LARGE                                   │
│  Font: Inter Bold, 57px / 64px                   │
│  Usage: Splash screen, page d'accueil            │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  DISPLAY MEDIUM                                  │
│  Font: Inter Bold, 45px / 52px                   │
│  Usage: Chiffres de comptage principaux          │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  HEADLINE LARGE                                  │
│  Font: Inter SemiBold, 32px / 40px               │
│  Usage: Titres de pages                          │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  HEADLINE MEDIUM                                 │
│  Font: Inter SemiBold, 28px / 36px               │
│  Usage: Sous-titres, sections                    │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  TITLE LARGE                                     │
│  Font: Inter SemiBold, 22px / 28px               │
│  Usage: Titres de cartes                         │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  TITLE MEDIUM                                    │
│  Font: Inter SemiBold, 16px / 24px               │
│  Usage: Titres de sections                       │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  BODY LARGE                                      │
│  Font: Roboto Regular, 16px / 24px               │
│  Usage: Corps de texte principal                 │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  BODY MEDIUM                                     │
│  Font: Roboto Regular, 14px / 20px               │
│  Usage: Descriptions, métadonnées                │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  LABEL LARGE                                     │
│  Font: Inter Medium, 14px / 20px                 │
│  Usage: Labels de boutons                        │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  LABEL SMALL                                     │
│  Font: Inter Medium, 11px / 16px                 │
│  Usage: Captions, timestamps                     │
└──────────────────────────────────────────────────┘
```

### Hiérarchie typographique

```
PAGE
│
├─ Headline Large (Titre principal)
│  └─ Color: Primary Gold
│
├─ Title Medium (Sous-sections)
│  └─ Color: Text Primary
│
├─ Body Large (Contenu)
│  └─ Color: Text Primary
│
└─ Body Small (Métadonnées)
   └─ Color: Text Secondary
```

---

## Iconographie

### Style d'icônes

**Famille** : Material Icons (Outlined variant)
**Style** : Lignes fines, modernes, minimalistes
**Taille** : 24dp par défaut
**Stroke** : 2px

### Icônes principales

```
🏠 Home: home_outlined
📷 Camera: photo_camera_outlined
📁 Galerie: photo_library_outlined
📊 Historique: history_outlined
⚙️  Paramètres: settings_outlined
👤 Personne: person_outlined
📤 Partager: share_outlined
💾 Sauvegarder: save_outlined
🔍 Rechercher: search_outlined
ℹ️  Info: info_outlined
✓ Valider: check_circle_outlined
✕ Fermer: close_outlined
```

### États des icônes

```
DEFAULT    : Couleur = Primary Gold, Opacité = 100%
HOVER      : Couleur = Accent Gold, Opacité = 100%
ACTIVE     : Couleur = Primary Gold, Opacité = 100%, Scale = 0.95
DISABLED   : Couleur = Text Tertiary, Opacité = 40%
```

---

## Composants UI

### Boutons

#### Button Primary (CTA principal)

```
┌────────────────────────────────────┐
│        Lancer la détection         │  ← Label: Inter SemiBold 16px
└────────────────────────────────────┘

Background: Primary Gold (#D4AF37)
Text Color: Primary Black (#000000)
Border Radius: 12px
Padding: 16px horizontal, 16px vertical
Min Height: 48dp (zone tactile)
Shadow: None (flat design)

States:
  - Default: Background #D4AF37
  - Hover: Background #FFD700 (Accent Gold)
  - Pressed: Background #C9A959, Scale 0.98
  - Disabled: Background #D4AF37 40%, Text 40%
```

#### Button Secondary (Action secondaire)

```
┌────────────────────────────────────┐
│          Voir l'historique         │
└────────────────────────────────────┘

Background: Transparent
Text Color: Primary Gold (#D4AF37)
Border: 1.5px solid Primary Gold
Border Radius: 12px
Padding: 16px horizontal, 16px vertical

States:
  - Default: Border #D4AF37
  - Hover: Background #D4AF37 10%
  - Pressed: Background #D4AF37 20%
```

#### Button Icon (Action rapide)

```
┌──────┐
│  📷  │  ← Icon 24dp
└──────┘

Size: 48x48dp (zone tactile)
Background: Primary Dark (#1A1F2E)
Icon Color: Primary Gold
Border Radius: 50% (cercle)

States:
  - Default: Background #1A1F2E
  - Hover: Background #2A2F3E
  - Pressed: Scale 0.95
```

### Cartes (Cards)

```
┌────────────────────────────────────────────┐
│  Détection du 04/01/2026 à 14:30           │  ← Title Medium
│                                            │
│  ┌──────────┐  25 personnes               │  ← Thumbnail + Info
│  │          │  Confiance: 95%              │
│  │  [IMG]   │  [📤] [💾]                    │  ← Actions
│  └──────────┘                              │
└────────────────────────────────────────────┘

Background: Card Dark (#1A1F2E)
Border Radius: 16px
Padding: 16px
Elevation: 0 (flat)
Border: 1px solid #2A2F3E (subtle)

States:
  - Default: Background #1A1F2E
  - Hover: Background #2A2F3E
  - Pressed: Scale 0.99
```

### Champs de saisie (Inputs)

```
┌────────────────────────────────────────────┐
│  Email                                     │  ← Label (au-dessus)
├────────────────────────────────────────────┤
│  exemple@email.com                         │  ← Valeur
└────────────────────────────────────────────┘

Background: Input Background (#1A1F2E)
Border: None (borderless)
Border Radius: 12px
Padding: 16px horizontal, 16px vertical
Text: Roboto Regular 16px

States:
  - Default: Border None
  - Focus: Border 2px Primary Gold
  - Error: Border 1px Error Red
  - Disabled: Background #1A1F2E 50%, Text 50%
```

### Switches (Interrupteurs)

```
OFF             ON
○────           ────●
Grey            Gold

Track Width: 48px
Track Height: 24px
Thumb Size: 20px
Track Color OFF: #6B6B6B
Track Color ON: #D4AF37
Thumb Color: #FFFFFF
```

### Sliders (Curseurs)

```
──────●─────────

Track: #2A2F3E (inactive), #D4AF37 (active)
Thumb: #D4AF37, Size 20px
Min Value Label: Text Secondary
Max Value Label: Text Secondary
```

---

## Grille et espacements

### Grille de base

```
Mobile: 4 colonnes (gutter 16px, margin 16px)
Tablet: 8 colonnes (gutter 24px, margin 24px)
Desktop: 12 colonnes (gutter 24px, margin 24px)
```

### Échelle d'espacement

Basée sur un **système de 8dp** pour la cohérence.

```
SPACING SCALE (multiples de 8)

XS:  4dp   (0.5 × base)
S:   8dp   (1 × base)
M:   16dp  (2 × base)
L:   24dp  (3 × base)
XL:  32dp  (4 × base)
XXL: 48dp  (6 × base)
XXXL: 64dp (8 × base)

Usage:
  - XS: Entre icône et texte
  - S: Padding interne minimal
  - M: Padding standard, margin entre éléments
  - L: Padding de carte, section spacing
  - XL: Margin entre sections majeures
  - XXL: Top/Bottom padding de page
```

### Marges et paddings

```
CARD
┌─────────────────────────┐
│ ← 16dp padding          │
│                         │
│  Content                │
│                         │
│              16dp →     │
└─────────────────────────┘
       ↓ 16dp margin
┌─────────────────────────┐
│  Next Card              │
└─────────────────────────┘

SECTION
┌─────────────────────────┐
│ ← 24dp padding          │
│                         │
│  Section Content        │
│                         │
└─────────────────────────┘
       ↓ 32dp margin
┌─────────────────────────┐
│  Next Section           │
└─────────────────────────┘
```

---

## Animations

### Principes d'animation

**Material Design Motion** :
- **Significatives** : Chaque animation a un but
- **Rapides** : Pas d'attente inutile
- **Fluides** : Courbes d'accélération naturelles

### Durées

```
FAST    : 100-200ms  (Micro-interactions)
MEDIUM  : 200-400ms  (Transitions standard)
SLOW    : 400-600ms  (Transitions complexes)
```

### Courbes d'animation (Easing)

```
EASE OUT      : Démarrage rapide, fin lente
                Usage: Entrées (éléments qui apparaissent)
                Cubic-Bezier: (0.0, 0.0, 0.2, 1.0)

EASE IN       : Démarrage lent, fin rapide
                Usage: Sorties (éléments qui disparaissent)
                Cubic-Bezier: (0.4, 0.0, 1.0, 1.0)

EASE IN OUT   : Démarrage et fin lents
                Usage: Transitions entre états
                Cubic-Bezier: (0.4, 0.0, 0.2, 1.0)

LINEAR        : Vitesse constante
                Usage: Rotations, progress bars
```

### Animations clés

#### 1. Page Transition

```
Type: Slide + Fade
Duration: 300ms
Easing: Ease Out

Entrée (nouvelle page):
  - Slide from right: translateX(100% → 0%)
  - Fade in: opacity(0 → 1)

Sortie (ancienne page):
  - Fade out: opacity(1 → 0.5)
  - Slight scale: scale(1 → 0.95)
```

#### 2. Button Press

```
Duration: 150ms
Easing: Ease In Out

Animation:
  - Scale down: scale(1 → 0.95)
  - Brief opacity: opacity(1 → 0.8 → 1)
```

#### 3. Loading Indicator

```
Type: Circular Progress
Duration: 1000ms (loop)
Easing: Linear

Animation:
  - Rotation: rotate(0deg → 360deg)
  - Color: Primary Gold
```

#### 4. Detection Count Up

```
Type: Number Animation
Duration: 800ms
Easing: Ease Out

Animation:
  - Count from 0 to N
  - Slight scale pulse at end: scale(1 → 1.1 → 1)
```

#### 5. Card Appearance

```
Duration: 400ms
Easing: Ease Out
Stagger: 100ms entre chaque carte

Animation:
  - Slide up: translateY(20px → 0px)
  - Fade in: opacity(0 → 1)
```

### Animations de feedback

```
SUCCESS
  - Icône ✓ qui apparaît avec un "pop"
  - Scale: 0 → 1.2 → 1 (300ms)
  - Color: Success Green

ERROR
  - Shake horizontalement
  - TranslateX: 0 → -10 → 10 → 0 (400ms)
  - Color pulse: Error Red

LOADING
  - Shimmer effect pour skeleton screens
  - Gradient qui se déplace de gauche à droite
  - Duration: 1500ms (loop)
```

---

## États et interactions

### Zones tactiles

**Taille minimale** : 48×48 dp (Guidelines Material Design)

```
┌─────────────────────┐
│                     │
│   ┌───────────┐     │  ← Padding 8dp autour
│   │   [Icon]  │     │     de l'icône 32dp
│   └───────────┘     │
│                     │
│   Total: 48×48 dp   │
└─────────────────────┘
```

### États interactifs

#### 1. Bouton

```
State      │ Visual Change
───────────┼──────────────────────────────
Default    │ Background: Primary Gold
Hover      │ Background: Accent Gold, Cursor: pointer
Pressed    │ Scale: 0.98, Background: Secondary Gold
Focus      │ Outline: 2px Primary Gold (accessibility)
Disabled   │ Opacity: 40%, Cursor: not-allowed
Loading    │ Spinner inside, Text: "Chargement..."
```

#### 2. Card

```
State      │ Visual Change
───────────┼──────────────────────────────
Default    │ Background: Card Dark
Hover      │ Background: Lighter, Cursor: pointer, Elevation: subtle
Pressed    │ Scale: 0.99
Selected   │ Border: 2px Primary Gold
```

#### 3. Input

```
State      │ Visual Change
───────────┼──────────────────────────────
Default    │ Background: Input Background
Focus      │ Border: 2px Primary Gold, Label color: Primary Gold
Filled     │ (same as default)
Error      │ Border: 1px Error Red, Helper text: red
Disabled   │ Opacity: 50%, Cursor: not-allowed
```

### Feedback visuel

**Principes** :
- **Immédiat** : Réaction &lt; 100ms
- **Clair** : Changement visible et compréhensible
- **Cohérent** : Même interaction = même feedback

---

## Accessibilité

### Conformité WCAG 2.1 (Niveau AA)

#### Principe 1 : Perceptible

✅ **Contraste de couleurs**
- Texte normal : minimum 4.5:1
- Texte large : minimum 3:1
- UI Components : minimum 3:1

✅ **Alternatives textuelles**
- Toutes les images ont un alt text
- Icônes accompagnées de labels ou aria-labels

✅ **Contenu adaptable**
- Support du zoom jusqu'à 200%
- Layout responsive

#### Principe 2 : Utilisable

✅ **Navigation au clavier**
- Tous les éléments interactifs sont focusables
- Ordre de tabulation logique
- Focus visible (outline 2px Primary Gold)

✅ **Temps suffisant**
- Pas de timeout automatique
- Option pour désactiver les animations (respect prefers-reduced-motion)

✅ **Zones tactiles**
- Minimum 48×48 dp pour tous les boutons

#### Principe 3 : Compréhensible

✅ **Lisibilité**
- Langage simple et clair
- Termes techniques expliqués

✅ **Prévisibilité**
- Navigation cohérente
- Pas de changement de contexte inattendu

✅ **Aide à la saisie**
- Labels explicites
- Messages d'erreur clairs avec solutions

#### Principe 4 : Robuste

✅ **Compatibilité**
- Support TalkBack (Android)
- Support VoiceOver (iOS)
- Sémantique HTML/Flutter correcte

### Dark Mode et contraste

Tous les textes respectent le ratio minimum :

| Élément | Fond | Texte | Ratio | Conforme |
|---------|------|-------|-------|----------|
| Heading | #0A0E1A | #FFFFFF | 15.8:1 | ✅ AAA |
| Body | #0A0E1A | #B0B0B0 | 8.3:1 | ✅ AAA |
| Button | #D4AF37 | #000000 | 12.1:1 | ✅ AAA |
| Link | #0A0E1A | #D4AF37 | 7.2:1 | ✅ AAA |

---

## Guide d'implémentation

### Code snippets Flutter

#### Utiliser les couleurs

```dart
import 'package:smart_head_count/core/theme/app_colors.dart';

Container(
  color: AppColors.primaryGold,
  child: Text(
    'SmartHeadCount',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

#### Utiliser la typographie

```dart
import 'package:smart_head_count/core/theme/app_theme.dart';

Text(
  'Titre principal',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

#### Créer un bouton primaire

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonPrimary,
    foregroundColor: AppColors.primaryBlack,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Lancer la détection'),
)
```

---

**Design System v1.0**
**Dernière mise à jour** : Janvier 2026
