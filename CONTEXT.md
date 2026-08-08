# Piscine Mobile — Contexte de travail (Flutter)

> Fichier pour reprendre le travail d'une machine à l'autre (maison ⇄ école ⇄ téléphone).
> **État : reprise à zéro en Flutter/Dart.** L'ancien code React Native a été supprimé
> (il reste dans l'historique git, voir « Historique »).
> **En cours : module 0, ex00** — squelette de `main.dart` posé, il reste le `children:`.

## Le projet

Piscine Mobile de 42 : 6 modules (0 → 5), à valider **dans l'ordre** (impossible de
s'inscrire au suivant sans valider le précédent). Chaque module est un dossier `mobileModuleXX`
contenant une ou plusieurs applis.

**Stack : Flutter + Dart.** C'est la stack native du sujet (le PDF parle directement de
widgets, `AppBar`, `TabBarView`, `math_expressions`, `table_calendar`…). Plus besoin de
traduire quoi que ce soit : le sujet se lit littéralement.

**Pourquoi ce changement :** stage à venir dans une boîte mobile qui bosse en Flutter.
Objectif double = valider la piscine **et** être opérationnel en Dart/Flutter à l'arrivée.

**Rôle de l'assistant (Claude) :** j'assiste, j'explique, je review. **C'est moi (Rayane) qui
code de A à Z.** Ne pas demander de solutions complètes clé en main.

Je suis **débutant complet en Dart et en Flutter**.

## Autres stacks : est-ce que j'ai besoin d'autre chose ?

**Non.** Pour les 6 modules, Flutter + Dart suffisent, plus Firebase (Auth + Firestore) sur
les modules 4 et 5. Aucun backend maison n'est requis : le sujet du module 4 dit « you may
use an authentication system like Firebase, AWS, etc. », et Open-Meteo (modules 2-3) est une
API publique sans clé.

**NestJS n'a pas sa place ici** — sauf en bonus perso si je veux impressionner en stage :
remplacer Firebase par un micro-service NestJS (OAuth Google/GitHub + Postgres/Mongo) sur les
modules 4-5. C'est légal vis-à-vis du sujet, mais ça double la charge de travail et ça
complique la soutenance (l'évaluateur doit pouvoir lancer l'appli sans démarrer mon backend).
**Décision : Firebase pour la piscine.** Le NestJS, éventuellement après, comme projet séparé.

## Structure globale : 6 modules, 9 applis

Une appli par « Files to turn in » du sujet (pas par exo) :

| Dossier | Appli(s) | Sujet |
|---|---|---|
| `mobileModule00` | `ex00`, `ex01`, `ex02`, `calculator_app` | Bases + calculatrice (SEUL module avec 1 appli/exo) |
| `mobileModule01` | `weather_app` | Structure : AppBar (search + géoloc) + BottomBar 3 onglets, clic **et** swipe |
| `mobileModule02` | `medium_weather_app` | GPS du device + APIs Open-Meteo (geocoding + forecast) + remplir les vues + erreurs |
| `mobileModule03` | `advanced_weather_app` | Design : search bar, fond fixe, icônes météo, graphiques de température |
| `mobileModule04` | `diary_app` | Auth Firebase (Google/GitHub) + Firestore, login + profil (CRUD entrées) |
| `mobileModule05` | `advanced_diary_app` | Profil enrichi (stats %) + page agenda (calendrier) |

Chaque appli = **un projet Flutter complet et autonome** (son propre `pubspec.yaml`,
son propre `lib/`, son propre dossier `android/`). Les modules 2, 3 et 5 sont des
**copies** du projet du module précédent, renommées puis enrichies (le sujet l'exige
explicitement : « copy your previous project into a new folder »).

## Setup technique

### Machine « maison » (WSL) — DÉJÀ INSTALLÉE ✅

- Repo : `/home/gekido/dev/mobile` (dans le FS WSL), branche `claude/mobile-piscine-flutter-5250uq`.
- **Flutter 3.44.9 / Dart 3.12.2**, installé dans `~/flutter` (tarball officiel décompressé,
  pas d'apt, pas de sudo requis).
- `export PATH="$HOME/flutter/bin:$PATH"` a été ajouté à `~/.bashrc` → ouvrir un **nouveau**
  terminal pour que `flutter` soit reconnu.

Si un jour l'install est à refaire ailleurs sans droits root :

```bash
curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json  # trouver l'URL stable
curl -o /tmp/flutter.tar.xz <url_du_tarball> && tar xf /tmp/flutter.tar.xz -C ~
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
```

### Ce qui manque encore sur cette machine

`flutter doctor` est rouge sur trois lignes, et c'est **normal / sans impact pour l'instant** :

| Manquant | Bloque quoi | Quand le régler |
|---|---|---|
| Android toolchain | émulateur + vrai téléphone | **avant le module 02** (GPS) |
| Chrome | `flutter run -d chrome` | jamais (on passe par `web-server`) |
| Linux toolchain | `flutter run -d linux` | jamais (besoin de `ninja-build`, `libgtk-3-dev`, `clang`) |

### Comment je lance l'appli aujourd'hui

Pas de Chrome ni d'Android sur cette machine → **`web-server`** : Flutter sert l'appli en HTTP,
et je l'ouvre dans le navigateur **Windows** (WSL2 forwarde `localhost` tout seul).

```bash
cd ~/dev/mobile/mobileModule00/ex00
flutter run -d web-server --web-port 8080
# puis http://localhost:8080 dans le navigateur Windows
```

Laisser ce terminal ouvert : c'est lui qui donne **`r`** (hot reload), **`R`** (hot restart),
**`q`** (quitter), et qui affiche les `debugPrint`.

**Attention pour la suite :** le module 02 exige le **GPS du device** (API externe interdite),
et les modules 04-05 utilisent Firebase Auth. Le web ne suffira plus — il faudra un vrai
Android. Deux voies : installer l'Android SDK dans WSL + **débogage sans fil**
(`adb pair` / `adb connect <ip>:<port>` vers le téléphone du même réseau), ou basculer tout le
setup côté Windows. **La soutenance se fait sur un device/émulateur Android**, pas sur le web.

### Commandes du quotidien

```bash
flutter create --platforms=android,web --org com.rayane ex00   # crée un projet (pas d'ios/desktop inutiles)
cd ex00
flutter pub get                 # installe les deps (équivalent npm install)
flutter pub add math_expressions # ajoute une dépendance
flutter run                     # lance ; 'r' = hot reload, 'R' = hot restart, 'q' = quitter
flutter devices                 # liste les cibles détectées
flutter analyze                 # linter — DOIT être clean avant de commit
flutter format .                # (ou `dart format .`) formatage officiel
```

- Le code se tape dans **`lib/main.dart`** (puis on découpe en fichiers dans `lib/`).
- **Hot reload** : sauvegarder → l'appli se remet à jour en gardant son état. Si l'état
  devient incohérent (changement de `initState`, de type de widget), faire un **hot restart**.
- « Display in the debug console » (module 0, ex00 et ex02) → `debugPrint('Button pressed')`
  (préférable à `print` : `debugPrint` n'est pas tronqué et est fait pour ça).

### Dépendances par module (à installer au fil de l'eau, pas d'avance)

| Module | Packages |
|---|---|
| 00 | `math_expressions` (explicitement suggéré par le sujet) |
| 02 | `geolocator` (GPS + permissions), `http` |
| 03 | `fl_chart` (courbes de température), `intl` (formatage dates) |
| 04 | `firebase_core`, `firebase_auth`, `cloud_firestore`, `google_sign_in` |
| 05 | `table_calendar` (explicitement suggéré par le sujet) |

Vérifier l'API sur **pub.dev** avant d'écrire du code : `google_sign_in` a changé d'API en
v7 (`initialize()` / `authenticate()` au lieu de `signIn()`), les tutos en ligne sont périmés.
Pour GitHub, passer par `firebase_auth` → `signInWithProvider(GithubAuthProvider())`.

## Avancement

### Module 0 — EN COURS (Introduction to Mobile Development)

- [ ] **ex00 — A basic display** — *en cours*. Un `Text` + un bouton en dessous, tous deux
      centrés horizontalement et verticalement. Clic → `debugPrint('Button pressed')` dans la
      console de debug. Responsive.
      **Fait :** projet créé (`flutter create --platforms=android,web --org com.rayane
      mobileModule00/ex00`), code de démo supprimé, squelette de `main.dart` écrit et validé
      par `flutter analyze`.
      **Reste :** remplir le `children:` de la `Column` (le `Text` + l'`ElevatedButton`),
      brancher le `onPressed`, supprimer `test/widget_test.dart` (il référence encore la
      classe `MyApp` du code de démo → seule erreur restante de `flutter analyze`).
- [ ] **ex01 — Say Hello to the World** : nouveau projet repris de ex00. Le texte bascule
      entre le texte initial et `"Hello World!"` à chaque clic. → **Concept clé :
      `StatefulWidget` + `setState()`.**
- [ ] **ex02 — More Buttons** : nouveau projet. `AppBar` titrée **"Calculator"**, deux
      `TextField` (expression / résultat) affichant `"0"` pour l'instant, et la grille de
      boutons : chiffres `0`-`9`, `.`, `AC`, `C`, `=`, `+`, `-`, `*`, `/`. Chaque clic
      `debugPrint` le label du bouton. **Responsive sur téléphone ET tablette.**
- [ ] **calculator_app — It's Alive!** : la calculatrice fonctionne pour de vrai
      (`math_expressions`). Les deux `TextField` affichent l'expression et son résultat.
      Doit gérer : `+ - * /`, expressions multi-opérations (`1 + 2 * 3 - 5 / 2`), **nombres
      négatifs** (`-` avant le nombre), **décimaux**, `C` (efface le dernier caractère),
      `AC` (efface tout). **L'appli ne doit JAMAIS crasher** : expression invalide, division
      par 0, très grands nombres → tout doit être rattrapé (`try/catch`).

### Module 1 — À FAIRE (weather_app)

- [ ] **ex00 — BottomBar** : `BottomAppBar` avec 3 onglets **Currently / Today / Weekly**,
      chacun avec un **nom + une icône**. Changement d'onglet au **clic ET au swipe** (les
      deux doivent marcher). Chaque onglet affiche juste son nom en texte pour l'instant.
      **Currently** sélectionné au démarrage.
      → Widgets suggérés par le sujet : `TabBar`, `TabBarView`, `BottomAppBar`
      (typiquement `DefaultTabController` + `TabBarView` pour le swipe, et la `TabBar`
      posée dans le `bottomNavigationBar` du `Scaffold`).
- [ ] **ex01 — TopBar** : `AppBar` contenant un `TextField` de recherche + un bouton de
      géolocalisation. Taper du texte → les 3 onglets affichent « nom de l'onglet + le texte
      saisi ». Cliquer le bouton géoloc → les 3 onglets affichent « nom de l'onglet +
      Geolocation ». Les deux doivent fonctionner.

> Le sujet précise que ce projet **continue au module suivant** → soigner la structure
> (séparer les vues dans `lib/`, ne pas tout entasser dans `main.dart`).

### Module 2 — À FAIRE (medium_weather_app)

Copie de `weather_app` → `medium_weather_app`, puis :

- [ ] **ex00 — Where are we?** : géoloc via le **GPS du device** (`geolocator`), au démarrage
      ET au clic sur le bouton. Demander la permission. Gérer les **deux** cas :
      - permission accordée → récupérer les coordonnées, les afficher en texte pour l'instant ;
      - permission refusée → l'appli continue de marcher via la recherche par ville, mais
        l'utilisateur est **informé** qu'on n'a pas accès à sa position.
      ⚠️ **Interdit** d'utiliser une API externe pour la géoloc : c'est le GPS ou rien.
- [ ] **ex01 — Searcher** : recherche par nom de ville/pays/région via l'**API Geocoding
      Open-Meteo**. Liste de **suggestions** mise à jour **dynamiquement** pendant la frappe,
      chaque suggestion affichant **nom de ville + région + pays**. Sélectionner une
      suggestion → météo de cette ville. La recherche doit aussi marcher **sans** choisir
      dans la liste.
- [ ] **ex02 — Fill the Views** : remplir les 3 vues avec l'**API Weather Forecast Open-Meteo**.
      - *Currently* : localisation (ville, région, pays), température actuelle (°C),
        description météo, vitesse du vent (km/h).
      - *Today* : localisation + liste heure par heure (heure, température, description, vent km/h).
      - *Weekly* : localisation + liste jour par jour (date, temp. min et max, description).
      Règles : démarrage sur *Currently* ; après une recherche on **reste sur l'onglet
      courant** ; en changeant d'onglet on voit **les données de la dernière recherche**
      (→ l'état météo vit **au-dessus** des onglets, pas dedans). Design : on s'en fiche
      ici, c'est le module 3.
- [ ] **ex03 — What's wrong with you?** : gérer **ville inexistante** et **échec de connexion
      à l'API**. Message d'erreur explicite qui **reste affiché** tant que l'utilisateur n'a
      pas saisi une ville valide / que la connexion n'est pas revenue.

> Note : l'API Open-Meteo renvoie un **`weather_code`** (WMO) numérique, pas un texte →
> prévoir une fonction de mapping code → description (et plus tard code → icône).

### Module 3 — À FAIRE (advanced_weather_app)

Copie de `medium_weather_app` → `advanced_weather_app`. Module 100 % design.

- [ ] **ex00 — Search bar** : barre de recherche et liste de suggestions lisibles et
      soignées, bouton géoloc bien visible. **Maximum 5 suggestions affichées à la fois.**
- [ ] **ex01 — Background** : image de fond pertinente, plein écran, qui **n'écrase pas** les
      infos, **fixe** quand on change d'onglet, et déclarée **une seule fois** à la base de
      l'appli (pas dupliquée dans chaque vue).
- [ ] **ex02 — Current weather** : localisation, température, description, **icône météo**,
      vent. Lisible en moins de 3 secondes.
- [ ] **ex03 — Today's weather** : localisation + **graphique de la courbe de température de
      la journée** (heures en abscisse) + liste **scrollable** (heure, température, icône ou
      texte de condition, vent).
- [ ] **ex04 — Weekly weather** : localisation + **graphique à deux courbes** (min et max par
      jour) + liste **scrollable** (jour de la semaine, min, max, condition).

### Module 4 — À FAIRE (diary_app)

Nouveau projet (pas une copie). Appli de journal intime protégée par authentification.

- [ ] **ex00 — Login Page** : bouton de login qui redirige vers la page d'auth, ou
      directement vers le journal si l'utilisateur est **déjà connecté**. Connexion via
      compte **Google ou GitHub** (Firebase Auth).
- [ ] **ex01 — Profile Page** : accessible **uniquement** si connecté. Firestore stocke pour
      chaque entrée : **email de l'utilisateur, date, titre, ressenti (feeling), contenu**.
      CRUD (create / read / delete). La page affiche : la liste de toutes les entrées, un
      bouton pour en créer une, l'ouverture d'une entrée au tap pour la lire, un bouton pour
      la supprimer. **La liste se met à jour** à chaque création et suppression.

> Pour la soutenance : **créer un compte Google dédié à l'évaluateur** et le pré-remplir
> avec quelques entrées.

### Module 5 — À FAIRE (advanced_diary_app)

Copie de `diary_app` → `advanced_diary_app`. 3 pages : login, profil, agenda.

- [ ] **ex00 — Profile Page** enrichie : nom de l'utilisateur ; bouton **logout** (retour à
      la page de login) ; les **2 dernières entrées** (date, ressenti, titre) ; ouverture
      d'une entrée pour la lire et la supprimer ; le **nombre total d'entrées** ; la liste
      des **ressentis avec leur pourcentage d'utilisation** sur l'ensemble des entrées ;
      un bouton pour ajouter une entrée. Tout doit se mettre à jour **en temps réel** à
      l'ajout et à la suppression (→ `StreamBuilder` sur Firestore).
- [ ] **ex01 — Agenda Page** : un calendrier (`table_calendar`, suggéré par le sujet) ouvert
      sur la **date du jour**. Sélectionner une date → liste **scrollable** des entrées de ce
      jour. Ouvrir une entrée pour la lire. Supprimer une entrée → la liste se met à jour.

## Prochaines étapes immédiates

1. `rm mobileModule00/ex00/test/widget_test.dart` (test de démo cassé).
2. Remplir le `children:` de la `Column` : un `Text` et un `ElevatedButton`.
3. Brancher le bouton : `onPressed: () { debugPrint('Button pressed'); }`.
4. Vérifier le centrage vertical (voir le piège `Column` plus bas), puis `flutter analyze`.

## Où j'en suis dans `main.dart` (ex00)

État validé par `flutter analyze` — il ne manque que le `children:` :

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            // ← children: [ Text, ElevatedButton ]
          ),
        ),
      ),
    ),
  );
}
```

Choix assumé pour ex00 : **pas de classe `MyApp`**, `runApp()` reçoit directement l'arbre.
L'écran est statique, donc `StatelessWidget` + `build()` + `@override` seraient du bruit.
**Ça ne tiendra plus dès ex01** (le texte change au clic → `StatefulWidget` → il faudra une classe).

## Concepts Flutter à assimiler (mémo, à remplir au fur et à mesure)

### Acquis au module 0

- **Un widget s'écrit comme un appel de fonction** : `Text('salut')`.
- **Les paramètres sont nommés** : `nom: valeur`, avec une **virgule après chaque valeur**
  (y compris la dernière — c'est ce qui fait que `dart format` aère le code verticalement au
  lieu de tout tasser sur une ligne).
- **Un `nom:` n'existe jamais seul** : il vit toujours *dans les parenthèses du widget à qui
  il appartient*. `home:` → `MaterialApp`, `body:` → `Scaffold`, `child:` → `Center`,
  `children:` → `Column`. ← *l'erreur qui m'a coûté deux essais.*
- **`child:` = un seul enfant, `children: [ ]` = une liste.** C'est pour ça qu'il faut
  `Center` **et** `Column` : `Center` ne peut pas contenir deux choses à lui seul.
- **Piège du centrage** : une `Column` prend toute la hauteur et colle ses enfants **en haut**
  par défaut. Leviers : `mainAxisAlignment` (axe de la colonne = vertical),
  `crossAxisAlignment` (perpendiculaire = horizontal), `mainAxisSize` (occuper toute la place
  ou juste celle des enfants).
- **Responsive = aucun pixel fixe** pour les positions/tailles. `Center` + `Column` +
  `Expanded` sont responsives par construction. Un `SizedBox(height: 20)` d'espacement voulu
  reste légitime. Débordement = rayures jaunes et noires à l'écran.

### À venir

- **Tout est widget.** Un widget = une description immuable d'un bout d'UI. On ne « modifie »
  pas un widget, on en **reconstruit** un nouveau.
- **`StatelessWidget`** = pas de mémoire, se contente de dessiner à partir de ses paramètres.
  **`StatefulWidget`** = a un `State` qui survit aux reconstructions ; on le modifie **via
  `setState(() { ... })`**, jamais en assignant directement (sinon rien ne se redessine).
  C'est l'équivalent exact du `useState` de React.
- **`build()`** est rappelée à chaque changement d'état : elle doit être rapide et sans effet
  de bord.
- **Layout** : `Column` (vertical) / `Row` (horizontal) avec `mainAxisAlignment` (le long de
  l'axe) et `crossAxisAlignment` (perpendiculaire) — même logique que Flexbox. `Expanded` /
  `Flex` pour raisonner en **parts** plutôt qu'en pixels → c'est ça, le responsive.
  `Center`, `Padding`, `SizedBox` pour le reste.
- **`Scaffold`** = la structure d'une page (`appBar`, `body`, `bottomNavigationBar`).
- **Dart** : typage statique (`final`, `var`, types explicites), **null safety** (`String?` vs
  `String`, `?.`, `??`, `!`), `async` / `await` / `Future` pour les appels réseau.
- **`FutureBuilder` / `StreamBuilder`** : construire l'UI à partir d'un appel async ou d'un
  flux (Firestore) sans gérer la plomberie à la main.
- Style de code : suivre `flutter format` (formatage **officiel**, non négociable, il diffère
  des accolades Allman de la Norme 42 — ici c'est le style Dart qui prime) et garder
  `flutter analyze` clean.

## Workflow reprise (école, ou nouvelle machine)

```bash
git clone git@github.com:gekid00/piscine_mobile.git   # ou git pull si déjà cloné
cd piscine_mobile/mobileModule00/ex00
flutter pub get                            # deps non versionnées → réinstaller
flutter run -d web-server --web-port 8080  # ou -d chrome / -d <device android>
```

Si Flutter n'est pas installé sur la machine : voir « Machine maison (WSL) » plus haut, la
méthode par tarball marche sans droits root.

## Travailler depuis le téléphone (Remote Control)

Pour continuer **la même session Claude Code** depuis le téléphone, avec le contexte, les
fichiers locaux et le Flutter installé — la session tourne sur le PC, le téléphone la pilote :

```bash
claude --remote-control
```

Puis retrouver la session depuis Claude sur le téléphone.

À ne pas confondre avec `claude --cloud` / claude.ai/code : ça crée une session dans un
environnement **distant**, qui n'a ni les fichiers locaux ni Flutter installé.

Le flag se pose **au démarrage** d'une session : une session déjà lancée sans lui ne peut pas
être récupérée. D'où l'intérêt de tenir ce fichier à jour — c'est lui, et pas l'historique de
chat, qui assure la continuité entre machines.

## Historique

Les modules 0 et 1 avaient été faits en **React Native + Expo** avant la bascule vers Flutter.
Ce code a été supprimé du repo pour repartir propre ; il reste consultable dans l'historique
git (commit `8dca611`, sur `main`). Ce qui reste utile de cette première passe, c'est la
**compréhension des exercices**, pas le code.
