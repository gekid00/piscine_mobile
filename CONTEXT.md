# Piscine Mobile — Contexte de travail

> Fichier pour reprendre le travail d'une machine à l'autre (maison ⇄ école).
> Dernière mise à jour : **module 0 TERMINÉ**. Prochain : module 1 (weather_app).

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

### Module 0 — TERMINÉ ✅
- [x] **ex00** — texte + bouton centrés, clic → `console.log('Button pressed')`.
- [x] **ex01** — le texte bascule au clic. **Concept : le state (`useState`).**
- [x] **ex02** — coquille calculatrice : barre "Calculator", 2 afficheurs, grille de
      boutons responsive via `<Pressable>` + composant réutilisable `CalcButton`, log au clic.
- [x] **calculator_app** — calcul fonctionnel avec `expr-eval` (`Parser.evaluate`),
      `try/catch` → jamais de crash. Gère négatifs, décimaux, priorités, C/AC/=, div par 0.

Patterns clés appris au module 0 :
- Composant réutilisable `CalcButton` (évite de répéter le code).
- **Passer une fonction en prop** parent→enfant : `<CalcButton onPress={handlePress} />`,
  l'enfant l'appelle `onPress(label)`. (handlePress DOIT être dans App pour voir les states.)
- `try/catch` autour de l'évaluation = garantie "never crash".
- Style de code : accolades Allman (à la 42), camelCase, `return (` collé (piège ASI).

### Module 1 — À FAIRE (weather_app)
Structure de l'appli météo : voir `module1.pdf`. En résumé :
- BottomBar 3 onglets : Currently / Today / Weekly.
- TopBar : barre de recherche + bouton géolocalisation.
- Navigation par clic d'onglet ET par swipe.
- Pas encore de vraies données : chaque onglet affiche juste son nom + le texte cherché.
- Libs probables : react-native-tab-view / @react-navigation (à décider au démarrage).

## Prochaines étapes immédiates

1. Créer le projet `mobileModule01/weather_app` (Expo, épinglé SDK 54).
2. Lire `module1.pdf` en détail et découper les 2 exos.
3. Choisir la lib de navigation/onglets.

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
