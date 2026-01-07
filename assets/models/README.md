# Modèle TensorFlow Lite pour la détection de personnes

## Modèle requis

L'application utilise le modèle **SSD MobileNet V1** pour la détection de personnes.

### Téléchargement du modèle

Téléchargez le modèle depuis TensorFlow Hub:
- **Nom du fichier**: `ssd_mobilenet_v1.tflite`
- **URL**: https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip

### Installation

1. Téléchargez et décompressez le fichier zip
2. Copiez le fichier `detect.tflite` dans ce dossier
3. Renommez-le en `ssd_mobilenet_v1.tflite`

### Alternative: Modèle COCO SSD

Vous pouvez également utiliser d'autres modèles de détection de personnes compatibles avec TensorFlow Lite.

## Mode simulation

Si le modèle n'est pas présent, l'application fonctionnera en mode simulation avec des détections aléatoires pour les tests.
