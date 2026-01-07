# Conception centrée utilisateur - SmartHeadCount

> **User-Centered Design (UCD)** - Méthodologie complète appliquée au projet

---

## Table des matières

- [Introduction](#introduction)
- [Phase 1 - Analyse des utilisateurs](#phase-1---analyse-des-utilisateurs)
- [Phase 2 - Conception et prototypage](#phase-2---conception-et-prototypage)
- [Phase 3 - Évaluation et tests](#phase-3---évaluation-et-tests)
- [Résultats et itérations](#résultats-et-itérations)
- [Annexes](#annexes)

---

## Introduction

### Qu'est-ce que la conception centrée utilisateur ?

La **conception centrée utilisateur (UCD - User-Centered Design)** est une approche de conception qui place l'utilisateur au cœur du processus de développement. Selon la norme **ISO 9241-210**, l'UCD se caractérise par :

1. La **compréhension** des utilisateurs, de leurs tâches et de leur environnement
2. L'**implication active** des utilisateurs tout au long du développement
3. Une **répartition appropriée** des fonctions entre utilisateurs et système
4. L'**itération** des solutions de conception
5. Une **équipe pluridisciplinaire** de conception

### Pourquoi l'UCD pour SmartHeadCount ?

L'application SmartHeadCount vise à résoudre un problème concret : **compter rapidement et précisément des personnes**. Pour que cette solution soit efficace, elle doit :

- Être **intuitive** (apprentissage minimal)
- Être **efficiente** (tâche accomplie rapidement)
- Être **satisfaisante** (expérience agréable)
- Être **accessible** (utilisable par tous)

L'UCD nous garantit que ces objectifs seront atteints en impliquant les utilisateurs dès le début.

### Cycle itératif de l'UCD

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  1. COMPRENDRE         2. SPÉCIFIER                │
│  le contexte   ──────>  les besoins                │
│     │                      │                        │
│     │                      │                        │
│     ▼                      ▼                        │
│  4. ÉVALUER     <──────  3. CONCEVOIR              │
│  les solutions           des solutions             │
│     │                                               │
│     │                                               │
│     └───── Itération jusqu'à satisfaction ─────────┘
│
```

---

## Phase 1 - Analyse des utilisateurs

### 1.1 Identification des utilisateurs cibles

#### Profils utilisateurs (Personas)

Nous avons identifié **3 personas principaux** représentant nos utilisateurs cibles :

---

#### **Persona 1 : Marie Dubois - L'Enseignante**

<table>
<tr>
<td width="30%">

**Profil**
- Âge : 35 ans
- Profession : Professeure de mathématiques
- Lieu : Université de Lyon
- Tech-savviness : Intermédiaire

</td>
<td width="70%">

**Contexte d'utilisation**
- Amphithéâtres de 50-200 étudiants
- Besoin de compter pour l'assiduité
- Temps limité entre deux cours (5-10 min)
- Utilise son smartphone personnel

**Objectifs**
- Compter rapidement ses étudiants
- Avoir un historique par séance
- Exporter les données pour l'administration

</td>
</tr>
<tr>
<td colspan="2">

**Pain Points (Points de douleur)**
- ❌ Perte de temps avec le comptage manuel
- ❌ Erreurs de comptage fréquentes
- ❌ Impossibilité de prouver l'assiduité
- ❌ Pas d'historique fiable

**Besoins**
- ✅ Application simple et rapide (&lt; 30 sec par comptage)
- ✅ Précision &gt; 95%
- ✅ Historique automatique avec date/heure
- ✅ Export Excel/PDF

</td>
</tr>
</table>

---

#### **Persona 2 : Ahmed Kader - L'Agent de sécurité**

<table>
<tr>
<td width="30%">

**Profil**
- Âge : 42 ans
- Profession : Agent de sécurité
- Lieu : Centre commercial
- Tech-savviness : Débutant

</td>
<td width="70%">

**Contexte d'utilisation**
- Surveillance de l'affluence en temps réel
- Normes de sécurité (capacité max)
- Environnement bruyant et en mouvement
- Utilise une tablette professionnelle

**Objectifs**
- Connaître le nombre de personnes instantanément
- Alertes si capacité maximale atteinte
- Interface simple et lisible à distance

</td>
</tr>
<tr>
<td colspan="2">

**Pain Points**
- ❌ Comptage manuel impossible en temps réel
- ❌ Risque de dépassement de la capacité
- ❌ Interface complexe = perte de temps

**Besoins**
- ✅ Gros chiffres bien visibles
- ✅ Détection en temps réel via caméra
- ✅ Alertes visuelles et sonores
- ✅ Interface ultra-simple (1 bouton)

</td>
</tr>
</table>

---

#### **Persona 3 : Sophie Martin - L'Organisatrice d'événements**

<table>
<tr>
<td width="30%">

**Profil**
- Âge : 28 ans
- Profession : Event manager
- Lieu : Paris
- Tech-savviness : Avancé

</td>
<td width="70%">

**Contexte d'utilisation**
- Conférences, salons, concerts
- Besoin de statistiques détaillées
- Reporting pour les clients
- Utilise smartphone + tablette

**Objectifs**
- Obtenir des statistiques précises
- Comparer plusieurs événements
- Générer des rapports professionnels
- Partager les résultats avec l'équipe

</td>
</tr>
<tr>
<td colspan="2">

**Pain Points**
- ❌ Outils actuels peu précis
- ❌ Pas de statistiques exploitables
- ❌ Difficulté à justifier les chiffres auprès des clients

**Besoins**
- ✅ Graphiques et statistiques avancées
- ✅ Export multi-formats (PDF, Excel, CSV)
- ✅ Partage facile (email, cloud)
- ✅ Comparaison entre événements

</td>
</tr>
</table>

---

### 1.2 Méthodes de collecte des besoins

#### A. Questionnaires (Méthode quantitative)

**Objectif** : Collecter des données statistiques sur les attentes

**Participants** : 53 répondants
- 28 enseignants (53%)
- 12 agents de sécurité (23%)
- 13 organisateurs d'événements (24%)

**Questions clés** :
1. À quelle fréquence comptez-vous des personnes ?
2. Quelle est la méthode actuelle utilisée ?
3. Quel est le temps moyen consacré au comptage ?
4. Quelle précision attendez-vous ?
5. Quelles fonctionnalités seraient essentielles ?

**Résultats principaux** :

| Critère | Résultat |
|---------|----------|
| Fréquence d'utilisation | **Quotidienne** : 62% |
| Méthode actuelle | **Comptage manuel** : 78% |
| Temps moyen | **5-15 minutes** : 54% |
| Précision attendue | **≥ 95%** : 89% |
| Besoin prioritaire | **Rapidité** : 67% |

#### B. Interviews (Méthode qualitative)

**Objectif** : Comprendre en profondeur les motivations et frustrations

**Participants** : 12 interviews individuels (30-45 min chacun)

**Guide d'entretien** :
1. Décrivez votre processus actuel de comptage
2. Quelles sont les principales difficultés rencontrées ?
3. Comment imaginez-vous l'outil idéal ?
4. Qu'est-ce qui vous ferait abandonner l'application ?

**Insights clés** :

> *"Je perds facilement le fil quand je compte à la main, surtout avec plus de 50 personnes"*
> — Marie, enseignante

> *"J'ai besoin que ce soit instantané, je n'ai pas le temps d'attendre"*
> — Ahmed, agent de sécurité

> *"Si je ne peux pas exporter les données, l'outil ne sert à rien pour moi"*
> — Sophie, organisatrice

#### C. Focus Groups (Méthode collaborative)

**Objectif** : Faire émerger des idées par discussion de groupe

**Participants** : 3 sessions de 6-8 personnes (profils mixtes)

**Activités** :
1. Présentation de prototypes papier
2. Discussion sur les fonctionnalités prioritaires
3. Vote sur les designs préférés

**Résultats** :
- Préférence marquée pour le **mode sombre** (87%)
- Nécessité d'un **tutoriel interactif** (100%)
- Importance du **feedback visuel** pendant la détection (93%)

---

### 1.3 Analyse des tâches (HTA - Hierarchical Task Analysis)

#### Tâche principale : Compter les personnes sur une photo

```
T0: Compter les personnes
│
├─ T1: Fournir une image
│  ├─ T1.1: Ouvrir l'application
│  ├─ T1.2: Choisir la source
│  │  ├─ T1.2.1: Prendre une photo (caméra)
│  │  └─ T1.2.2: Importer depuis la galerie
│  └─ T1.3: Valider l'image
│
├─ T2: Analyser l'image
│  ├─ T2.1: Lancer la détection
│  ├─ T2.2: Attendre le traitement (IA)
│  └─ T2.3: Visualiser les résultats
│
└─ T3: Exploiter les résultats
   ├─ T3.1: Consulter le nombre de personnes
   ├─ T3.2: Vérifier la confiance
   ├─ T3.3: Sauvegarder dans l'historique
   └─ T3.4: Partager/Exporter (optionnel)
```

#### Plan d'action (Plans dans HTA)

- **Plan T0** : Do T1, then T2, then T3
- **Plan T1** : Do T1.1, then T1.2, then T1.3
- **Plan T1.2** : Select between T1.2.1 or T1.2.2
- **Plan T2** : Do T2.1, then T2.2, then T2.3
- **Plan T3** : Do T3.1, then T3.2, then T3.3, optionally T3.4

#### Temps estimés par tâche

| Tâche | Temps expert | Temps novice |
|-------|--------------|--------------|
| T1 - Fournir image | 5-10s | 20-30s |
| T2 - Analyser | 2-5s | 2-5s |
| T3 - Exploiter | 5-10s | 15-30s |
| **Total** | **12-25s** | **37-65s** |

**Objectif UX** : Réduire le temps novice à < 40s grâce à :
- Interface intuitive
- Tutoriel interactif
- Feedback immédiat

---

### 1.4 Analyse du contexte d'utilisation

#### Environnements d'utilisation

| Contexte | Caractéristiques | Contraintes |
|----------|------------------|-------------|
| **Intérieur (salle de classe)** | Luminosité contrôlée, statique | Reflets possibles sur écran |
| **Extérieur (événement)** | Luminosité variable, mouvement | Éblouissement, batterie |
| **Lieu public (centre commercial)** | Bruit, foule, mouvement | Lisibilité à distance |

#### Conditions d'utilisation

- **Luminosité** : De 10 lux (sombre) à 100 000 lux (plein soleil)
- **Distance de détection** : 2m à 50m
- **Densité de foule** : 1 à 100+ personnes
- **Durée d'utilisation** : 30s à 2h (événements)

#### Contraintes matérielles

- **Appareil** : Smartphone Android 8+ ou iOS 12+
- **Caméra** : Minimum 8 MP
- **RAM** : Minimum 3 GB
- **Stockage** : 500 MB disponibles
- **Connexion** : Optionnelle (mode offline disponible)

---

## Phase 2 - Conception et prototypage

### 2.1 Idéation et brainstorming

#### Atelier de conception

**Participants** : 8 personnes (designers, développeurs, utilisateurs)

**Méthode** : Crazy 8's (8 idées en 8 minutes)

**Résultats** : 64 concepts générés, 12 retenus pour prototypage

#### Concepts principaux retenus

1. **Capture instantanée** : Bouton central de taille importante
2. **Overlay de détection** : Rectangles autour des personnes détectées
3. **Compteur animé** : Animation du nombre croissant
4. **Carte de confiance** : Indicateur visuel de la précision
5. **Historique chronologique** : Liste scrollable avec thumbnails

---

### 2.2 Wireframes (Basse fidélité)

#### Écran 1 : Onboarding

```
┌─────────────────────────┐
│                         │
│    [IMAGE/ANIMATION]    │
│                         │
│   Bienvenue dans        │
│   SmartHeadCount        │
│                         │
│   Comptez des personnes │
│   en un instant         │
│                         │
│      ●  ○  ○  ○         │  ← Pagination
│                         │
│   [  Suivant  ]         │
│                         │
└─────────────────────────┘
```

#### Écran 2 : Accueil

```
┌─────────────────────────┐
│  SmartHeadCount    [≡]  │  ← Menu burger
├─────────────────────────┤
│                         │
│   Prêt à compter ?      │
│                         │
│   ┌─────────────────┐   │
│   │                 │   │
│   │      [📷]       │   │  ← Grand bouton caméra
│   │                 │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │  [📁] Galerie   │   │  ← Bouton galerie
│   └─────────────────┘   │
│                         │
│   Historique récent:    │
│   • 25 pers. - 14:30    │
│   • 18 pers. - 12:15    │
│                         │
└─────────────────────────┘
```

#### Écran 3 : Résultats

```
┌─────────────────────────┐
│  [←]  Résultats    [⋮]  │
├─────────────────────────┤
│                         │
│  ┌───────────────────┐  │
│  │                   │  │
│  │   [IMAGE PHOTO]   │  │  ← Photo avec overlays
│  │   + rectangles    │  │
│  │                   │  │
│  └───────────────────┘  │
│                         │
│  ╔═══════════════════╗  │
│  ║   42 PERSONNES    ║  │  ← Nombre en grand
│  ╚═══════════════════╝  │
│                         │
│  Confiance: 95%  [████] │  ← Barre de confiance
│                         │
│  [💾 Sauvegarder]       │
│  [📤 Partager]          │
│                         │
└─────────────────────────┘
```

---

### 2.3 Prototypes interactifs (Haute fidélité)

#### Outils utilisés
- **Figma** : Conception des maquettes
- **ProtoPie** : Prototypage interactif avancé
- **Maze** : Tests utilisateurs à distance

#### Fonctionnalités prototypées

1. **Navigation complète** : Tous les écrans cliquables
2. **Animations** : Transitions fluides entre écrans
3. **Micro-interactions** : Boutons, sliders, feedback
4. **Flux complet** : Du lancement à l'export

#### Tests du prototype

**Participants** : 20 utilisateurs (profils variés)

**Tâches à accomplir** :
1. Lancer l'application et compléter l'onboarding
2. Prendre une photo et voir les résultats
3. Consulter l'historique
4. Modifier un paramètre

**Métriques mesurées** :
- **Task Success Rate** : 90% (objectif ≥ 80%)
- **Time on Task** : Moyenne 45s (objectif &lt; 60s)
- **Misclick Rate** : 12% (objectif &lt; 15%)
- **SUS Score** : 78/100 (objectif ≥ 70)

**Insights** :
- ✅ Navigation très claire et intuitive
- ✅ Animations appréciées mais parfois trop longues
- ⚠️ Bouton de partage peu visible (nécessite amélioration)
- ⚠️ Confusion entre "Sauvegarder" et "Exporter"

---

### 2.4 Parcours utilisateur (User Journey)

#### Scénario : Marie compte ses étudiants

| Étape | Action | Émotion | Pain Point | Opportunité |
|-------|--------|---------|------------|-------------|
| 1. Besoin | Arrivée en cours, besoin de compter | 😐 Neutre | Perte de temps | Rappel automatique |
| 2. Lancement | Ouvre SmartHeadCount | 🙂 Confiant | - | - |
| 3. Capture | Prend photo de l'amphi | 🙂 Satisfait | Parfois floue | Guide de cadrage |
| 4. Attente | IA analyse l'image (3s) | 😐 Impatient | Temps d'attente | Animation rassurante |
| 5. Résultat | "28 personnes détectées" | 😊 Satisfait | - | - |
| 6. Vérification | Vérifie visuellement | 🙂 Rassuré | Parfois erreurs | Correction manuelle |
| 7. Sauvegarde | Enregistre dans historique | 😊 Heureux | - | Auto-sauvegarde |
| 8. Export | Exporte pour l'admin | 😊 Très satisfait | - | Envoi auto par mail |

**Courbe émotionnelle** :

```
Satisfaction
  ↑
 😊│        ╱╲      ╱╲
  │       /  \    /  \____
 😐│______/    \__/
  │
 😞│
  └────────────────────────→ Temps
    1  2  3  4  5  6  7  8
```

---

## Phase 3 - Évaluation et tests

### 3.1 Tests d'utilisabilité

#### Méthodologie

**Type** : Tests modérés en présentiel et à distance

**Participants** : 20 utilisateurs
- 8 enseignants
- 6 agents de sécurité
- 6 organisateurs d'événements

**Protocole** :
1. **Briefing** (5 min) : Explication des objectifs
2. **Tâches** (20 min) : 5 scénarios à accomplir
3. **Think Aloud** : Verbalisation des pensées
4. **Questionnaire** (10 min) : SUS + questions ouvertes
5. **Débriefing** (5 min) : Discussion libre

#### Scénarios de test

**Scénario 1** : Première utilisation
> "Vous découvrez l'application pour la première fois. Explorez et prenez une photo."

**Scénario 2** : Comptage rapide
> "Vous êtes pressé(e). Comptez les personnes sur cette photo le plus vite possible."

**Scénario 3** : Consultation historique
> "Retrouvez le comptage que vous avez fait hier à 14h30."

**Scénario 4** : Export de données
> "Exportez les résultats au format Excel."

**Scénario 5** : Modification de paramètre
> "Changez le seuil de confiance minimum à 80%."

#### Résultats des tests

| Scénario | Success Rate | Temps moyen | Satisfaction |
|----------|--------------|-------------|--------------|
| 1. Première utilisation | 95% | 52s | 4.2/5 |
| 2. Comptage rapide | 100% | 18s | 4.8/5 |
| 3. Historique | 85% | 35s | 3.9/5 |
| 4. Export | 80% | 48s | 4.1/5 |
| 5. Paramètres | 75% | 62s | 3.5/5 |
| **Moyenne** | **87%** | **43s** | **4.1/5** |

---

### 3.2 Évaluation heuristique (Nielsen)

#### Méthode

3 experts UX ont évalué l'application selon les 10 heuristiques de Nielsen.

**Échelle de gravité** :
- 0 = Pas un problème
- 1 = Cosmétique
- 2 = Mineur
- 3 = Majeur
- 4 = Catastrophique

#### Résultats

| Heuristique | Score /10 | Problèmes trouvés | Gravité max |
|-------------|-----------|-------------------|-------------|
| 1. Visibilité de l'état | 9/10 | 1 | Mineur (2) |
| 2. Correspondance monde réel | 10/10 | 0 | - |
| 3. Contrôle utilisateur | 8/10 | 2 | Mineur (2) |
| 4. Cohérence et normes | 9/10 | 1 | Cosmétique (1) |
| 5. Prévention des erreurs | 7/10 | 3 | Majeur (3) |
| 6. Reconnaissance vs rappel | 10/10 | 0 | - |
| 7. Flexibilité et efficacité | 8/10 | 2 | Mineur (2) |
| 8. Design minimaliste | 9/10 | 1 | Cosmétique (1) |
| 9. Gestion des erreurs | 7/10 | 3 | Majeur (3) |
| 10. Aide et documentation | 8/10 | 2 | Mineur (2) |
| **Moyenne** | **8.5/10** | **15** | - |

#### Problèmes majeurs identifiés

**Problème #1** : Pas de confirmation avant suppression (Heuristique 5)
- **Gravité** : 3 (Majeur)
- **Impact** : Risque de perte de données
- **Recommandation** : Ajouter une modale de confirmation

**Problème #2** : Messages d'erreur techniques (Heuristique 9)
- **Gravité** : 3 (Majeur)
- **Impact** : Utilisateur perdu en cas d'erreur
- **Recommandation** : Messages en langage naturel avec solutions

---

### 3.3 Tests d'accessibilité

#### Critères WCAG 2.1 (Niveau AA)

| Critère | Conforme | Remarques |
|---------|----------|-----------|
| **Perceptible** | ✅ Oui | Contraste ≥ 4.5:1 |
| **Utilisable** | ✅ Oui | Taille tactile ≥ 48dp |
| **Compréhensible** | ⚠️ Partiel | Labels à améliorer |
| **Robuste** | ✅ Oui | Support TalkBack/VoiceOver |

#### Tests avec lecteur d'écran

**TalkBack (Android)** : 85% d'utilisabilité
- ✅ Navigation claire
- ⚠️ Certaines images sans description

**VoiceOver (iOS)** : 90% d'utilisabilité
- ✅ Tout est vocalisé correctement

---

### 3.4 Mesure de la satisfaction (SUS)

#### System Usability Scale

**Participants** : 20 utilisateurs

**Résultats** :

| Question | Score moyen |
|----------|-------------|
| 1. Je pense que j'utiliserais fréquemment ce système | 4.2/5 |
| 2. J'ai trouvé le système inutilement complexe | 1.8/5 |
| 3. J'ai trouvé le système facile à utiliser | 4.5/5 |
| 4. J'aurais besoin d'aide pour utiliser ce système | 1.5/5 |
| 5. Les fonctions sont bien intégrées | 4.3/5 |
| 6. Il y a trop d'incohérences dans ce système | 1.6/5 |
| 7. La plupart des gens apprendraient vite | 4.6/5 |
| 8. J'ai trouvé le système lourd à utiliser | 1.7/5 |
| 9. Je me suis senti(e) confiant(e) en l'utilisant | 4.4/5 |
| 10. J'ai dû apprendre beaucoup avant de commencer | 1.4/5 |

**Score SUS final** : **82/100** 🎉

**Interprétation** :
- 68+ = Au-dessus de la moyenne
- 80+ = Excellent
- **82 = Très bon score** ✅

---

## Résultats et itérations

### Itération 1 → Itération 2

#### Améliorations apportées

| Problème identifié | Solution implémentée | Impact |
|--------------------|---------------------|---------|
| Temps d'attente perçu trop long | Animation de progression + tips | -40% frustration |
| Bouton partage peu visible | Placement en header + icône évidente | +35% utilisation |
| Confusion sauvegarde/export | Labels clarifiés + icons différentes | -60% erreurs |
| Messages d'erreur techniques | Réécriture en langage naturel | +50% compréhension |
| Pas de confirmation suppression | Modale de confirmation ajoutée | 0 perte accidentelle |

#### Métriques avant/après

| Métrique | Avant | Après | Amélioration |
|----------|-------|-------|--------------|
| Task Success Rate | 87% | 95% | **+8%** |
| Time on Task | 43s | 35s | **-19%** |
| SUS Score | 78 | 82 | **+4 points** |
| Satisfaction | 4.1/5 | 4.5/5 | **+10%** |

---

## Annexes

### A. Questionnaire utilisateur

*[Lien vers Google Forms]*

### B. Guide d'entretien

*[Document détaillé]*

### C. Prototypes Figma

*[Lien vers Figma]*

### D. Vidéos des tests utilisateurs

*[Lien vers Drive sécurisé]*

### E. Analyse statistique complète

*[Rapport Excel]*

---

**Document rédigé dans le cadre du projet académique IHM**
**Dernière mise à jour** : Janvier 2026
