# Piscine Mobile — Contexte de travail (Flutter)

> Fichier pour reprendre le travail d'une machine à l'autre (maison ⇄ école ⇄ téléphone).
> **État : reprise à zéro en Flutter/Dart.** L'ancien code React Native a été supprimé
> (il reste dans l'historique git, voir « Historique »).
> **Module 0 TERMINÉ ✅ (4/4)** — commits `34bb1ad`, `7990f23`, `9cffab1`.
> Prochain : **module 01 — weather_app** (`BottomBar` 3 onglets, clic **et** swipe).
>
> ⚠️ Jamais lancé dans un navigateur : tout est validé par tests automatisés (logique OK,
> rendu réel non vérifié). À faire une fois avant la soutenance, **sur Android** de
> préférence — c'est là que le correcteur évaluera.

## Le projet

Piscine Mobile de 42 : 6 modules (0 → 5), à valider **dans l'ordre** (impossible de
s'inscrire au suivant sans valider le précédent). Chaque module est un dossier `mobileModuleXX`
contenant une ou plusieurs applis.

**Stack : Flutter + Dart.** C'est la stack native du sujet (le PDF parle directement de
widgets, `AppBar`, `TabBarView`, `math_expressions`, `table_calendar`…). Plus besoin de
traduire quoi que ce soit : le sujet se lit littéralement.

**Pourquoi ce changement :** stage dans une boîte mobile qui bosse en Flutter — **il démarre
le 2026-08-17**. Objectif double = valider la piscine **et** être opérationnel en Dart/Flutter.

**Priorité assumée : maîtriser totalement les modules 00 → 02** plutôt que d'avancer vite
jusqu'au 05. Les bases (widgets, état, async, HTTP/JSON) valent plus que la surface.

**Ce que la piscine ne couvre PAS et qui se verra dès la première semaine de stage :**
la **gestion d'état** au-delà de `setState` (Provider / Riverpod / BLoC — c'est l'écart le
plus visible entre ce code et celui d'une boîte), la **navigation entre écrans**
(`Navigator`, routes, `go_router` — les onglets n'en sont pas), l'**architecture** en
`models/` `services/` `widgets/`, les tests, l'injection de dépendances.

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

### Android SDK + émulateur — INSTALLÉS ✅ (au moment d'attaquer le module 02)

Tout en espace utilisateur, **sans `sudo`** sauf un paquet système :

| Quoi | Où |
|---|---|
| JDK 17 Temurin | `~/jdk` |
| Android SDK 36 (platform-tools, build-tools, emulator) | `~/Android/Sdk` |
| AVD `piscine` | Pixel 7, Android 16, `google_apis_playstore`, x86_64 |

`~/.bashrc` exporte `JAVA_HOME`, `ANDROID_HOME` et complète le `PATH`.

L'image `google_apis_playstore` est volontaire : les services Google sont nécessaires pour
**Firebase aux modules 04-05**. Ne pas la remplacer par une image `default`.

Deux choses ont demandé `sudo` (à refaire sur une autre machine) :

```bash
sudo usermod -aG kvm $USER      # sinon l'émulateur tourne sans KVM = inutilisable
                                # puis `wsl --shutdown` depuis PowerShell, et rouvrir WSL
sudo apt install -y libnss3 libpulse0 libxcursor1 libxdamage1 libxcomposite1 \
                    libasound2t64 libglu1-mesa
```

Sans `libnss3`, l'émulateur démarre puis meurt sur
`qemu-system-x86_64: error while loading shared libraries: libnss3.so`.

Si l'install est à refaire : JDK via l'API Adoptium, puis
`commandlinetools-linux-*.zip` décompressé dans `~/Android/Sdk/cmdline-tools/latest`,
`sdkmanager --licenses`, puis `sdkmanager "platform-tools" "platforms;android-36"
"build-tools;36.0.0" "emulator" "system-images;android-36;google_apis_playstore;x86_64"`,
`flutter config --android-sdk ~/Android/Sdk`, `avdmanager create avd -n piscine -d pixel_7`.
Pas d'`unzip` sur cette machine → `python3 -m zipfile -e` + `chmod +x` sur les binaires.

### Ce qui manque encore (et qui ne sera jamais réglé)

| Manquant | Bloque quoi | Verdict |
|---|---|---|
| Chrome | `flutter run -d chrome` | inutile (on passe par `web-server` ou l'émulateur) |
| Linux toolchain | `flutter run -d linux` | inutile (`ninja-build`, `libgtk-3-dev`, `clang`) |

### Comment je lance l'appli

**Par le Makefile à la racine du repo**, qui exporte lui-même `JAVA_HOME` / `ANDROID_HOME` /
`PATH` (donc il marche même dans un terminal qui n'a pas rechargé le `.bashrc`) :

```bash
make                                 # démarre l'AVD si besoin, compile, installe, lance
make emu                             # juste l'émulateur, en arrière-plan
make web                             # repli navigateur, port 8080
make check                           # dart format + flutter analyze
make devices
make PROJ=mobileModule00/calculator_app   # cibler un autre projet
```

`PROJ` par défaut pointe sur le projet du module en cours — **à mettre à jour dans le
`Makefile` en changeant de module**.

Deux subtilités encodées dans le `Makefile` :

- l'AVD s'appelle `piscine` **tant qu'il est éteint**, puis `emulator-5554` une fois démarré →
  la cible `run` résout l'id réel avec `adb devices` au lieu de le coder en dur ;
- `flutter analyze` sort en **code 1 même pour un simple `info`** → `--no-fatal-infos`, sinon
  `make check` échoue sur une suggestion de style.

Laisser le terminal de `flutter run` ouvert : **`r`** (hot reload), **`R`** (hot restart),
**`q`** (quitter), et c'est là que s'affichent les `debugPrint`.

**Garder l'émulateur ouvert entre deux sessions** : ~60 s de démarrage contre 1 s de hot reload.
Premier build Gradle après un `flutter clean` : 1 à 3 min.

### Piloter l'émulateur en ligne de commande (test sans cliquer)

```bash
adb emu geo fix 2.3522 48.8566                    # injecter une position GPS (lon lat)
adb shell pm grant  <pkg> android.permission.ACCESS_FINE_LOCATION
adb shell pm revoke <pkg> android.permission.ACCESS_FINE_LOCATION
adb shell pm set-permission-flags <pkg> <perm> user-fixed   # simule un refus définitif
adb shell am force-stop <pkg>
adb shell monkey -p <pkg> -c android.intent.category.LAUNCHER 1
adb exec-out screencap -p > /tmp/shot.png         # capture d'écran
adb shell input tap <x> <y> / input text "Paris" / input keyevent 66
```

Package des projets : `com.example.<nom_du_projet>`.
Des dialogues système Android (« Try out your stylus ») peuvent s'intercaler et fausser
les taps — piloter les permissions par `pm grant`/`pm revoke` plutôt qu'en cliquant.

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

### Module 0 — TERMINÉ ✅ (Introduction to Mobile Development)

- [x] **ex00 — A basic display** ✅ — `Text` + `ElevatedButton` centrés sur les deux axes,
      clic → `debugPrint('Button pressed')`. `flutter analyze` clean, `dart format` passé.
      Centrage obtenu avec `Center` + `Column(mainAxisSize: MainAxisSize.min)` — choix assumé
      plutôt que `mainAxisAlignment: .center`, pour que chaque widget garde une seule
      responsabilité (`Center` centre, `Column` empile). À savoir défendre en peer-eval.
      `test/widget_test.dart` supprimé (il référençait la classe `MyApp` du code de démo).
- [x] **ex01 — Say Hello to the World** ✅ — `StatefulWidget` + `setState()`. La logique est
      dans une méthode `_basculerTexte()` du `State`, pas dans le `onPressed` (plus lisible
      dès que le corps dépasse 2 lignes). `onPressed: _basculerTexte` **sans parenthèses** :
      on passe la fonction, on ne l'appelle pas. Le sujet d'ex01 ne demande **aucun**
      `debugPrint` (vérifié dans le PDF) — c'est ex00 et ex02 qui l'exigent.
- [x] **ex02 — More Buttons** ✅ — `AppBar` "Calculator", deux `TextField` en `readOnly`
      affichant `"0"`, et 18 boutons **générés par un double `collection for`** depuis une
      `static const List<List<String>> touches` (5 lignes × 4 colonnes). Chaque clic
      `debugPrint` son label. Responsive via `Expanded` : autour de chaque `Row` (partage de
      la hauteur) et de chaque bouton (partage de la largeur) — **aucune taille en pixels**.
      Choix assumé : pas de `Spacer` sur la dernière ligne, donc `AC`/`C` font 50 % chacun.
- [x] **calculator_app — It's Alive!** ✅ — `StatefulWidget`, deux `TextEditingController`
      en membres du `State` (+ `dispose()`). `_appuyer(touche)` route vers `AC` / `C` / `=` /
      saisie. Évaluation via `ShuntingYardParser().parse()` + `RealEvaluator().evaluate()`
      (⚠️ `Parser` et `.evaluate(EvaluationType.REAL, ContextModel())` sont **dépréciés** en
      `math_expressions` 3.x). `try/catch` + test `isFinite` → `"Error"`.
      **Vérifié par test UI simulant les clics — 14 cas, aucun crash** : `1+2*3-5/2`=4.5,
      `-5+3`=-2, `2.5*4`=10, `5/0`/`1+`/`**`/`0...`→Error, `99999999*99999999` OK.
      Formatage : `toStringAsFixed(0)` si entier et `< 1e21`, sinon `toString()` — **pas**
      `toInt().toString()` qui affichait un `.0` parasite sur les grands nombres.

### Module 1 — TERMINÉ ✅ (weather_app) — commit `07d67e5`

- [x] **ex00 — BottomBar** ✅ — `DefaultTabController` enveloppant le `Scaffold`, `TabBar`
      dans `bottomNavigationBar: BottomAppBar(...)`, `TabBarView` en `body`. Le clic **et**
      le swipe marchent sans une ligne de code : les deux widgets écoutent le **même**
      `TabController`, qui ne stocke qu'un `int index`. `TabBarView` affiche `children[index]`
      → aucun `if`, c'est **la position dans les listes** qui fait le lien.
      Deux `collection for` sur la même liste `onglets` ⇒ ordre garanti identique.
- [x] **ex01 — TopBar** ✅ — passage en `StatefulWidget`. `TextField` dans `AppBar(title:)`,
      bouton géoloc dans `AppBar(actions:)`. `_lieu` vit dans le `State` **au-dessus** des
      3 onglets → un seul `setState` met à jour les trois.
      `TextEditingController` en champ du `State` + `dispose()`.

### Module 2 — EN COURS (medium_weather_app)

Projet créé **neuf** (`flutter create`) puis `lib/main.dart` repris du module 01 — plutôt
qu'un `cp -r` de `weather_app`, qui aurait traîné l'ancien nom de package partout.

- [x] **ex00 — Where are we?** ✅ — `geolocator`, permissions `ACCESS_FINE/COARSE_LOCATION`
      + `INTERNET` ajoutées à `android/app/src/main/AndroidManifest.xml`.
      État : `String _lieu` **et** `String? _erreur` (une seule `String` ne peut pas porter
      « voici une ville » et « voici une erreur » — le `build()` ne saurait pas laquelle il tient).
      Flux : `isLocationServiceEnabled()` → `checkPermission()` → `requestPermission()` si
      `denied` → `getCurrentPosition()`. `requestPermission()` **rend** la nouvelle valeur,
      donc pas de re-check. `deniedForever` traité à part : redemander n'affiche aucune boîte
      de dialogue et retombe immédiatement sur un refus.
      `initState()` couvre « au démarrage », l'`IconButton` couvre « au clic ».
      **Vérifié sur l'émulateur** (pas seulement compilé) : accordé → `48.8566, 2.3521983` ;
      refusé → message rouge ; recherche `Marseille` après refus → OK.
      Choix assumé, discutable en soutenance : chercher une ville **efface** le message de
      refus (l'utilisateur a trouvé le contournement proposé).
- [ ] **ex01 — Searcher** : recherche par nom de ville/pays/région via l'**API Geocoding
      Open-Meteo**. Liste de **suggestions** mise à jour **dynamiquement** pendant la frappe,
      chaque suggestion affichant **nom de ville + région + pays**. Sélectionner une
      suggestion → météo de cette ville. La recherche doit aussi marcher **sans** choisir
      dans la liste.
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

**Module 02 ex01 — Searcher.** Découpé, briques identifiées, **rien d'écrit encore** :

1. `lib/ville.dart` — classe `Ville` (5 champs `final` : `nom`, `region`, `pays`, `lat`, `lon`)
   + constructeur nommé `Ville.fromJson(Map<String, dynamic>)`.
2. `flutter pub add http` puis l'appel API.
3. Debounce sur `onChanged` du `TextField`.
4. Affichage de la liste de suggestions (ville + région + pays), clic → sélection.
   La recherche doit aussi marcher **sans** cliquer dans la liste.
5. Puis ex02 (remplir les 3 vues) et ex03 (gestion d'erreurs).

`PROJ` du `Makefile` pointe déjà sur `mobileModule02/medium_weather_app`.

### Ce que l'API Geocoding renvoie réellement (vérifié au `curl`)

`https://geocoding-api.open-meteo.com/v1/search?name=<q>&count=10&language=fr&format=json`

Une trentaine de champs par ville, dont 5 utiles :

```
name       "Marseille"        la ville
admin1     "Région PACA"      la région   ⚠ le champ s'appelle admin1, PAS region
country    "France"           le pays
latitude   43.29695           pour la météo à l'ex02
longitude  5.38107
```

⚠️ **Piège majeur, vaut l'ex03** : quand aucune ville ne correspond, l'API ne renvoie **pas**
un tableau vide mais un JSON **sans la clé `results`** :

```json
{"generationtime_ms": 0.41782856}
```

Donc `data['results']` vaut **`null`**, pas `[]` → boucler dessus crashe (déréférencement de
pointeur nul). Toujours tester `if (resultats == null)` avant la boucle.

Autres pièges du parsing : `admin1` et `country` sont parfois **absents** (petites localités,
îles) → `json['admin1'] ?? ''` ; les coordonnées arrivent parfois en `int` →
`(json['latitude'] as num).toDouble()`.

**Non commité à ce stade :** le `Makefile`, la mise à jour de ce fichier, et
`mobileModule02/` (ex00 terminé). Le module 01 est commité (`07d67e5`).

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
- **Certaines cases sont obligatoires** : `ElevatedButton` refuse de se construire sans
  `onPressed` **et** `child`. Le compilateur le dit : *« The named parameter X is required »*.
- **Enums** : `MainAxisSize.min`, `MainAxisAlignment.center`, `CrossAxisAlignment.start`…
  Attention à la casse : `mainAxisSize` = le paramètre, `MainAxisSize` = le type.
- **Fonction anonyme** (Dart) : `() { ... }`, l'équivalent du `() => {}` de JS. On la **donne**
  au bouton, on ne l'appelle pas → `onPressed: () { ... }`, jamais `onPressed: maFonction()`.
- **Erreur que j'ai faite 3 fois** : répéter à droite des `:` le nom de la case
  (`child: child`). À gauche = le nom imposé, à droite = le contenu. Jamais le même mot.
- **`dart format .`** (et pas `flutter format`, supprimé des versions récentes).
- **L'auto-import de VS Code ajoute des lignes en douce** en haut du fichier — il m'a collé un
  `import 'dart:math';` pendant que je tapais `MainAxisSize.min`. `flutter analyze` les
  attrape (*unused_import*).

### Acquis ex01 → ex03 (le dynamique)

Analogies C/C++ — c'est ce qui a fait tilt :

```
build()            une fonction appelée EN BOUCLE  →  on n'y alloue jamais rien
StatelessWidget    une fonction pure, aucun membre
State              l'objet qui vit, avec ses variables membres
dispose()          le destructeur (= free), appelé par Flutter, écrit par moi
final              T* const : le pointeur ne bouge plus, l'objet pointé si
State<Calculatrice>  un template C++, du TYPAGE — aucune donnée ne transite là-dedans
```

- **Pourquoi deux classes.** `MaPage extends StatefulWidget` est un **descripteur jetable**,
  détruit/reconstruit sans arrêt. `_MaPageState` est l'objet qui **survit**. Donc : rien dans
  la première (juste `createState()`), **tout** dans la seconde (variables, contrôleurs,
  méthodes, `build()`).
- `State<X> createState() => _XState();` se lit : *« quand on te le demande, fabrique-moi un
  `_XState` neuf »*. Appelée **une seule fois**, au premier affichage.
- **Deux façons de rafraîchir l'écran, ne pas les confondre :**
  ```
  variable nue (String)      →  ne prévient personne  →  setState() OBLIGATOIRE
  TextEditingController      →  ChangeNotifier, prévient tout seul  →  pas de setState
  ```
  `controller: _expr` **abonne** le `TextField` au contrôleur. Écrire `_expr.text = '7'`
  suffit : le champ se repeint seul, `build()` n'est **pas** rappelée.
- **Tout `final` créé dans un `State`** (contrôleur, animation, listener) **doit être libéré
  dans `dispose()`**, sinon fuite mémoire.
- **`collection for` / `collection if`** — la particularité Dart qui génère les 18 boutons :
  ```dart
  children: [
    for (final t in ligne) Expanded(child: ...),   // pas de .map(), pas de .toList()
    if (ligne.length < 4) Spacer(flex: 4 - ligne.length),
  ]
  ```
  **Pas d'accolades, pas de `;`** — c'est un `if`/`for` d'*expression*, pas d'instruction.
  Des `{ }` créeraient un `Set`. La boucle produit des **widgets**, pas du texte.
- **`flex` = un nombre de parts, pas de morceaux.** Chacun reçoit `son flex / somme des flex`
  de la ligne. Donc `1+1` et `2+2` donnent le **même** 50/50 : seul le rapport compte.
  Deux boutons seuls sur une `Row` prennent toujours 100 % → il faut un `Spacer` pour
  « réserver » les colonnes manquantes. `Spacer` impose `flex > 0` (d'où le `if`).
- **`Center` + `mainAxisSize.min` et `Expanded` sont contradictoires** : « je prends le
  minimum » contre « je prends tout le reste » → assertion. Contenu compact centré (ex00/01)
  ou remplir l'écran (calculatrice), il faut choisir.
- **`onPressed: _maMethode`** (sans parenthèses) si aucun argument ;
  **`onPressed: () => _maMethode(arg)`** s'il en faut un. Avec `_maMethode()` directement, la
  fonction s'exécute pendant le `build()` → crash.
- **Boutons renommés depuis Flutter 3** : `RaisedButton`→`ElevatedButton`,
  `FlatButton`→`TextButton`, `OutlineButton`→`OutlinedButton`. Les vieilles réponses Stack
  Overflow utilisent les noms morts.

### Acquis au module 1 (navigation, async)

- **`DefaultTabController`** crée et partage un `TabController` avec **tous ses descendants**.
  `TabBar` le récupère via `DefaultTabController.of(context)`, qui **remonte l'arbre** — d'où
  l'obligation de le placer **au-dessus** du `Scaffold`. Trop bas ⇒ `No TabController for TabBar`.
- Le contrôleur ne stocke qu'un **`int index`** et notifie ses abonnés (patron **observateur**).
  Clic sur `TabBar` ou swipe sur `TabBarView` → même index → l'autre suit. **Rien à coder.**
- **L'état monte au plus proche ancêtre commun** de ceux qui en ont besoin. `_lieu` est dans
  `_WeatherAppState`, au-dessus des 3 onglets → un `setState` les rafraîchit toutes les trois.
- **`initState()`** = 1 fois à la naissance, **`build()`** = N fois, **`dispose()`** = 1 fois à
  la mort définitive. `dispose` n'est **pas** appelé à chaque `setState` : c'est un destructeur
  C++, pas un `clear()`. Règle : tout `= XxxController()` se libère dans `dispose()`.
- **`Future<T>`** = `std::future<T>`. `await` n'est utilisable que dans une fonction `async`,
  et une fonction `async` retourne toujours un `Future`. Contrairement à `std::future::get`,
  `await` **ne bloque pas** : il rend la main à l'UI et reprend au retour.
- **`build()` ne peut jamais être `async`** — il doit rendre un widget immédiatement.
- **`setState(() async {...})` ne marche pas.** Tous les `await` d'abord, puis un `setState`
  purement synchrone qui ne fait qu'affecter les variables.
- **`String?`** = peut valoir `null` (l'absence, distincte de la chaîne vide). `String x = null;`
  ne compile pas. `x!` affirme au compilateur que ce n'est pas `null` à cet endroit.
- **`collection for` / `collection if`** : boucle et condition **dans** un littéral de liste.
  Ce sont des *expressions* → pas d'accolades, pas de `;`, une virgule à la fin. Équivalent du
  `push_back` en boucle, mais l'arbre reste déclaratif d'un seul tenant (et `const`-able).
  Version « classique » possible en construisant une `List<Widget>` avant le `return`, mais
  l'arbre devient discontinu. Pour une liste **longue ou scrollable** : `ListView.builder`,
  qui ne construit que les éléments visibles.
- **`flex` est un nombre de parts, pas un nombre de morceaux.** Chacun reçoit
  `son flex / somme des flex`, **recalculée par ligne**. Donc `1/1`, `2/2` et `50/50` donnent
  tous 50 % — mettre `flex: 2` sur les deux seuls boutons d'une ligne ne change **rien**.
  Pour aligner 2 boutons sur une grille de 4 colonnes : `Spacer(flex: 4 - ligne.length)`.
  ⚠️ `Spacer` impose `flex > 0` → garder le `if (ligne.length < 4)`, sinon crash à l'exécution.
- **`Expanded` vs `Flexible`** : `Expanded` prend **toute** sa part (`FlexFit.tight`),
  `Flexible` **au plus** sa part et se rétracte si l'enfant est plus petit. `Spacer` = un
  `Expanded` vide. Pas de widget « split », ça n'existe pas.

### Briques du module 2 (réseau, JSON, null safety)

- **`Map` vs classe.** `jsonDecode` rend une `Map<String, dynamic>` → `ville['name']`, clés
  vérifiées à l'**exécution** (`ville['nam']` compile, rend `null`, crashe plus tard).
  Une `class` → `ville.nom`, champs vérifiés à la **compilation**. Tableau associatif contre
  `struct`. Pour 5 champs relus partout : la classe.
- **Constructeur nommé** `Ville.fromJson(...)` : un deuxième constructeur après un point.
  Le `:` avant le `;` est la **liste d'initialisation du C++** — obligatoire ici parce que
  les champs sont `final`. Il convertit **une** ville, il ne boucle pas.
- **`dynamic`** = type inconnu à la compilation, un `void*` : Dart ne vérifie plus rien.
  D'où l'intérêt de repasser en classe typée le plus tôt possible.
- **Les trois opérateurs null**, à ne pas confondre :
  ```
  a?.b()    appelle b() seulement si a n'est pas null   (≡ if (a != null) a.b())
  a ?? c    si a est null, prends c
  a!        "je garantis que a n'est pas null" (crashe si tu mens)
  ```
- **`http`** : `await http.get(Uri.parse(url))`. `Uri.parse` obligatoire, `http.get` refuse
  une `String`. `reponse.statusCode` (200 = OK) et `reponse.body` (le JSON en `String` brute).
  `import ... as http` = un préfixe de namespace, comme `namespace` en C++.
- **`throttle` vs `debounce`** : throttle = 1 appel max toutes les 300 ms, régulièrement ;
  debounce = 1 appel après 300 ms de **silence**. Pour une recherche c'est le **debounce**.
  Découper « tous les X caractères » ne marche pas : « Nice » fait 4 lettres et l'utilisateur
  s'arrête là.
  ```dart
  Timer? _debounce;
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 300), () { /* requête */ });
  ```
  ⚠️ `_debounce?.cancel()` **aussi dans `dispose()`** : un timer qui se déclenche après la
  mort du widget appelle `setState` sur un `State` détruit → crash.
- **Le `collection for` marche sur n'importe quelle liste**, pas seulement sur des widgets :
  `_suggestions = [for (final j in resultats) Ville.fromJson(j)];`
  Même syntaxe que les 18 boutons de la calculatrice, appliquée à des données.

### Pièges d'outillage rencontrés

- **`flutter: command not found`** dans un terminal déjà ouvert → le `~/.bashrc` a été modifié
  après son lancement : `source ~/.bashrc`.
- **`flutter format` n'existe plus** → `dart format .`.
- **`flutter analyze` sort en code 1 même pour un simple `info`** → `--no-fatal-infos` dans le
  `Makefile`, sinon `make check` échoue sur une suggestion de style.
- **`use_key_in_widget_constructors`** : `info` présent sur tous les projets depuis le module 0.
  Se règle avec `const MonWidget({super.key});`. Boilerplate écarté volontairement — à trancher.
- **Erreur `client.js` / `_JsonMap is not a subtype of List<Object?>`** au lancement web : bug
  de l'outillage `webdev`/DWDS (le client de debug injecté), **pas du code**. `flutter analyze`
  reste clean. Contournements : rafraîchir la page, relancer `flutter run`, ou en dernier
  recours `--no-injected-client` (mais on perd le hot reload).
- **VS Code auto-importe parfois `dart:math`** en tapant `MainAxisSize.min` → `unused_import`
  attrapé par `flutter analyze`.

### À venir

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
cd piscine_mobile
make check          # dart format + flutter analyze sur PROJ
make                # démarre l'AVD, compile, installe, lance
```

Si Flutter n'est pas installé : voir « Machine maison (WSL) » plus haut (tarball, sans root).
Si l'Android SDK n'est pas installé : voir « Android SDK + émulateur » — ne pas oublier le
`usermod -aG kvm` **et** `libnss3`, les deux seules étapes qui demandent `sudo`.

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
