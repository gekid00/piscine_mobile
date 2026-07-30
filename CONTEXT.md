# Piscine Mobile — Contexte de travail

> Fichier pour reprendre le travail d'une machine à l'autre (maison ⇄ école).
> Dernière mise à jour : module 0, exo 02 en cours.

## Le projet

Piscine Mobile de 42, réalisée en **React Native + Expo** (et non Flutter comme le sujet).
Le sujet emploie du vocabulaire Flutter → on le traduit en équivalents React Native.

**Rôle de l'assistant (Claude) :** j'assiste, j'explique, je review. **C'est moi (Rayane) qui code de A à Z.** Ne pas demander des solutions complètes clé en main.

Je suis **débutant complet en React**.

## Structure globale : 6 modules, 9 applis

Une appli par « Files to turn in » du sujet (pas par exo) :

| Dossier | Appli(s) | Sujet |
|---|---|---|
| `mobileModule00` | `ex00`, `ex01`, `ex02`, `calculator_app` | Bases + calculatrice (SEUL module avec 1 appli/exo) |
| `mobileModule01` | `weather_app` | Structure : 3 onglets bas (Currently/Today/Weekly) + barre haut (search + géoloc), swipe |
| `mobileModule02` | `medium_weather_app` | GPS device + APIs Open-Meteo (geocoding + forecast) + remplir vues + erreurs |
| `mobileModule03` | `advanced_weather_app` | Design : fond, icônes météo, graphiques de température |
| `mobileModule04` | `diary_app` | Auth Firebase (Google/GitHub) + Firestore, login + profil (CRUD) |
| `mobileModule05` | `advanced_diary_app` | Profil enrichi (stats %) + page agenda (calendrier) |

## Setup technique (IMPORTANT — spécificités WSL)

- On travaille sous **WSL** → le téléphone ne peut pas joindre l'IP interne de WSL.
  → Toujours lancer avec le **mode tunnel** : `npx expo start --tunnel`
  → `@expo/ngrok` est installé **en local** dans le projet (l'install globale échouait).
- Test sur **PC** possible : `npx expo start` puis touche **`w`** (navigateur).
  Support web déjà installé dans ex00 (`react-dom`, `react-native-web`, `@expo/metro-runtime`).
- **Expo Go du téléphone supporte le SDK 54** → les projets sont **épinglés au SDK 54**
  (create-expo-app installe le 57 par défaut, incompatible → toujours rétrograder :
  `npx expo install expo@~54.0.0` puis `npx expo install --fix`).
- Éditer le code : fichier **`App.js`** à la racine de chaque appli.
- Hot reload : sauvegarder (Ctrl+S) → l'appli se met à jour toute seule.
- Note : erreur `libnspr4.so` au démarrage = outil de debug annexe, sans impact, à ignorer.

## Avancement

- [x] **ex00** — texte + bouton centrés, clic → `console.log('Button pressed')`. Validé.
- [x] **ex01** — le texte bascule au clic (A simple text ⇄ Hello World!). **Concept appris : le state (`useState`).** Validé.
- [ ] **ex02** — coquille calculatrice (en cours) :
  - [x] barre du haut "Calculator" (`View` + `Text`, `height: 56`)
  - [x] 2 afficheurs à "0"
  - [x] grille de boutons (4 lignes, `flexDirection: 'row'`, boutons en `title="..."`)
  - [ ] **rendre responsive** : le `<Button>` RN n'est pas stylable/dimensionnable →
        envelopper chaque bouton dans `<View style={{ flex: 1 }}>` OU passer à `<Pressable>`.
  - [ ] **morceau 4** : au clic, chaque bouton fait `console.log('button pressed :', valeur)`.
- [ ] **calculator_app** — logique de calcul (lib `expr-eval`, `try/catch`, jamais planter).

## Prochaines étapes immédiates (ex02)

1. Rendre la grille responsive (wrapper `View flex:1` par bouton, ou `Pressable`).
2. Ajouter le `onPress` de chaque bouton → log de son texte dans la console.
3. Une fois ex02 validé → copier dans `calculator_app/` et attaquer la logique.

## Concepts déjà vus (mémo)

- **Composant** = fonction qui retourne de l'affichage (JSX). `App` = point d'entrée (`export default`).
- **JSX** = le "HTML dans le JS".
- **State** (`useState`) = valeur mémorisée ; on la change avec `setXxx(...)` (jamais à la main) → l'écran se redessine.
- **Closure** : une fonction définie DANS une autre voit les variables autour (d'où `handlePress` dans `App`).
- **Flexbox** (placement) : `flexDirection` (column/row), `justifyContent` (sens de la pile), `alignItems` (perpendiculaire). Responsive = raisonner en **`flex` (parts)** plutôt qu'en pixels fixes ; pixels fixes OK pour tailles constantes voulues (barre, marge).
- **`===` / `!==`** toujours (jamais `==` / `!=`).
- `export default` → import **sans** accolades ; `export` nommé → import **avec** `{ }`.

## Workflow reprise à l'école

```bash
git clone git@github.com:gekid00/piscine_mobile.git   # ou git pull si déjà cloné
cd piscine_mobile/mobileModule00/ex02
npm install          # node_modules non versionnés → réinstaller
npx expo start       # puis 'w' (web) ou --tunnel (tél)
```
