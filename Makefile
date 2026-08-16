# Piscine Mobile - Flutter
#
# Le projet ciblé se change sans editer ce fichier :
#     make PROJ=mobileModule00/calculator_app
#
# L'outillage vit dans $HOME, hors du systeme (cf. CONTEXT.md).

PROJ ?= mobileModule02/medium_weather_app
AVD  ?= piscine

export JAVA_HOME    := $(HOME)/jdk
export ANDROID_HOME := $(HOME)/Android/Sdk
export PATH         := $(JAVA_HOME)/bin:$(ANDROID_HOME)/platform-tools:$(ANDROID_HOME)/emulator:$(ANDROID_HOME)/cmdline-tools/latest/bin:$(HOME)/flutter/bin:$(PATH)

.PHONY: all run emu web check fmt analyze clean devices help

# flutter run demarre l'emulateur lui-meme s'il n'en trouve aucun.
all: run

# L'AVD s'appelle "piscine" tant qu'il est eteint, puis "emulator-5554"
# une fois demarre : on resout l'id reel plutot que de le coder en dur.
run: emu
	cd $(PROJ) && flutter run -d $$(adb devices | awk '/emulator-/{print $$1; exit}')

# Emulateur seul, en arriere-plan (utile pour le garder entre deux runs).
emu:
	@adb devices | grep -q emulator- \
		&& echo "emulateur deja lance" \
		|| (emulator -avd $(AVD) -gpu swiftshader_indirect -no-boot-anim >/dev/null 2>&1 & \
		    echo "demarrage de $(AVD)..."; adb wait-for-device; \
		    while [ "$$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" != "1" ]; do sleep 2; done; \
		    echo "pret")

# Repli navigateur, sans emulateur ni SDK Android.
web:
	cd $(PROJ) && flutter run -d web-server --web-port 8080

check: fmt analyze

fmt:
	cd $(PROJ) && dart format .

# --no-fatal-infos : echoue sur les erreurs et warnings, pas sur les
# suggestions de style (qui restent affichees).
analyze:
	cd $(PROJ) && flutter analyze --no-fatal-infos

clean:
	cd $(PROJ) && flutter clean

devices:
	flutter devices

help:
	@echo "make            compile et lance $(PROJ) sur l'emulateur"
	@echo "make emu        demarre seulement l'emulateur $(AVD)"
	@echo "make web        lance dans le navigateur (port 8080)"
	@echo "make check      dart format + flutter analyze"
	@echo "make clean      flutter clean"
	@echo "make devices    liste les appareils vus par Flutter"
	@echo ""
	@echo "PROJ=<chemin>   cible un autre projet (defaut: $(PROJ))"
