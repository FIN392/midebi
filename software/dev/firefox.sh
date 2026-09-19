#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Firefox ESR en español (es-ES)

# Cierra
sudo pkill -TERM firefox || true
sleep 3s
sudo pkill -KILL firefox || true
# Desinstala
sudo apt purge "firefox*" -y || true
sudo apt autoremove --purge -y
# Elimina configuración
sudo rm --force --recursive /usr/lib/firefox*
sudo rm --force --recursive /usr/share/firefox*
sudo rm --force --recursive /etc/firefox*
sudo rm --force --recursive /usr/share/applications/firefox*.desktop
rm --force --recursive ~/.mozilla
rm --force --recursive ~/.cache/mozilla
sudo rm --force --recursive ~/.mozilla
sudo rm --force --recursive ~/.cache/mozilla

# Instalar
sudo apt install firefox-esr firefox-esr-l10n-es-es -y

# Configurar
# 1. Configurar la llamada a firefox.cfg
sudo mkdir -p /usr/lib/firefox-esr/defaults/pref
sudo tee "/usr/lib/firefox-esr/defaults/pref/autoconfig.js" > /dev/null << 'EOF'
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF

# 2. Crear archivo firefox.cfg (Endurecimiento de Privacidad y Telemetría)
sudo tee "/usr/lib/firefox-esr/firefox.cfg" > /dev/null << 'EOF'
// Evitar telemetria, data reporting, normandy, activity-stream.feeds y cosas similares

defaultPref("browser.startup.homepage", "https://start.duckduckgo.com/");
defaultPref("browser.startup.page", 1);

defaultPref("breakpad.reportURL", "");

defaultPref("app.normandy.enabled", false);
defaultPref("app.normandy.first_run", false);
defaultPref("app.shield.optoutstudies.enabled", false);

defaultPref("beacon.enabled", false);

defaultPref("browser.aboutwelcome.enabled", false);

defaultPref("browser.ml.chat.enabled", false);
defaultPref("browser.ml.chatprovider.enabled", false);
defaultPref("browser.ml.enable", false);
defaultPref("browser.ml.suggestions.enabled", false);

defaultPref("browser.newtabpage.activity-stream.default.sites", "");
defaultPref("browser.newtabpage.activity-stream.discoverystream.config", "[]");
defaultPref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
defaultPref("browser.newtabpage.activity-stream.feeds.snippets", false);
defaultPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false);
defaultPref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines", "DuckDuckGo");
defaultPref("browser.newtabpage.activity-stream.showSearch", true);
defaultPref("browser.newtabpage.activity-stream.showSponsored", false);
defaultPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
defaultPref("browser.newtabpage.activity-stream.showWeather", false);
defaultPref("browser.newtabpage.activity-stream.telemetry", false);

defaultPref("browser.pocket.enabled", false);
defaultPref("browser.rights.3.shown", true);
defaultPref("browser.search.serpEventTelemetryCategorization.enabled", false);
defaultPref("browser.tabs.crashReporting.sendReport", false);
defaultPref("browser.translations.neverTranslateLanguages", "en,en-US,en-GB");

defaultPref("browser.urlbar.eventTelemetry.enabled", false);
defaultPref("browser.urlbar.merino.enabled", false);
defaultPref("browser.urlbar.quicksuggest.enabled", false);
defaultPref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
defaultPref("browser.urlbar.suggest.quicksuggest.sponsored", false);
defaultPref("browser.urlbar.suggest.trending", false);
defaultPref("browser.urlbar.suggest.weather", false);
defaultPref("browser.urlbar.suggest.yelp", false);

defaultPref("datareporting.healthreport.service.enabled", false);
defaultPref("datareporting.healthreport.uploadEnabled", false);
defaultPref("datareporting.policy.dataSubmissionEnabled", false);

defaultPref("experiments.enabled", false);
defaultPref("experiments.manifest.uri", "");
defaultPref("experiments.supported", false);

defaultPref("layers.acceleration.force-enabled", true);

defaultPref("network.captive-portal-service.enabled", false);
defaultPref("network.connectivity-service.enabled", false);
defaultPref("network.dns.disablePrefetch", true);
defaultPref("network.predictor.enabled", false);
defaultPref("network.prefetch-next", false);

defaultPref("pdfjs.altText.enabled", false);

defaultPref("signon.rememberSignons", false);

defaultPref("telemetry.origin_telemetry_base_in_inclusive_builder", false);

defaultPref("toolkit.coverage.endpoint.base", "");
defaultPref("toolkit.coverage.opt-out", true);
defaultPref("toolkit.telemetry.archive.enabled", false);
defaultPref("toolkit.telemetry.coverage.opt-out", true);
defaultPref("toolkit.telemetry.enabled", false);
defaultPref("toolkit.telemetry.unified", false);
EOF

# 3. Crear archivo policies.json (Políticas a nivel de Enterprise)
sudo mkdir -p /usr/lib/firefox-esr/distribution
sudo tee "/usr/lib/firefox-esr/distribution/policies.json" > /dev/null << 'EOF'
{
  "policies": {
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    },
    "SearchEngines": {
      "Default": "DuckDuckGo",
      "Remove": [
        "Google",
        "Bing"
      ]
    }
  }
}
EOF
