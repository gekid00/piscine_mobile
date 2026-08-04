# Piscine Mobile — Contexte de travail

> Fichier pour reprendre le travail d'une machine à l'autre (maison ⇄ école).
> Dernière mise à jour : **modules 0 et 1 TERMINÉS**. Prochain : module 2 (medium_weather_app).

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

### Module 1 — TERMINÉ ✅ (weather_app)
- [x] **ex00 BottomBar** : 3 onglets (Currently/Today/Weekly) avec icône + nom,
      navigation clic + swipe, Currently par défaut.
- [x] **ex01 TopBar** : champ de recherche + bouton géoloc. Taper du texte ou cliquer
      géoloc met à jour les 3 vues (affichent nom onglet + valeur).

Choix techniques module 1 :
- Lib onglets : **`react-native-tab-view`** (+ `react-native-pager-view`) — gère
  clic + swipe. Barre en bas via `tabBarPosition="bottom"`.
- Icônes : **`@expo/vector-icons`** (`Ionicons`), déjà inclus dans Expo.
- API v4 : les icônes/labels de la barre se passent via la prop **`options`** de `<TabBar>`
  (objet keyé par `route.key`), branchée par un `renderTabBar` custom.
- État partagé : un state `search` dans `App`, lu par `renderScene` → toutes les vues
  se mettent à jour. `TextInput` contrôlé (`value` + `onChangeText`).

### Module 2 — À FAIRE (medium_weather_app)
Continuation de weather_app : voir `module2.pdf`. En résumé :
- Copier weather_app → medium_weather_app.
- Géoloc réelle via GPS du device (**`expo-location`**, PAS d'API externe pour ça).
  Gérer permission accordée ET refusée.
- APIs Open-Meteo (pas de clé requise) : Geocoding (ville→coords + suggestions) +
  Weather Forecast. Remplir les 3 vues (Currently/Today/Weekly) avec vraies données.
- Liste de suggestions de villes dynamique sous la recherche.
- Gestion d'erreurs : ville inexistante, connexion API échouée.

## Prochaines étapes immédiates

1. Copier `mobileModule01/weather_app` → `mobileModule02/medium_weather_app`.
2. Installer `expo-location`.
3. Attaquer ex00 (géoloc GPS + affichage des coordonnées).

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
