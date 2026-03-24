.PHONY: start stop rebuild

# Port für den lokalen Webserver
PORT = 8000

# PID-Datei zum Speichern der Prozess-ID des Webservers
PID_FILE = .webserver.pid

start:
	@if [ -f $(PID_FILE) ]; then \
		echo "Webserver läuft bereits (PID: $$(cat $(PID_FILE))). Bitte zuerst 'make stop' ausführen."; \
	else \
		echo "Starte lokalen Webserver auf Port $(PORT)..."; \
		python3 -m http.server $(PORT) > /dev/null 2>&1 & echo $$! > $(PID_FILE); \
		echo "Webserver gestartet unter http://localhost:$(PORT)"; \
	fi

stop:
	@if [ -f $(PID_FILE) ]; then \
		echo "Stoppe Webserver (PID: $$(cat $(PID_FILE)))..."; \
		kill -9 $$(cat $(PID_FILE)) 2>/dev/null || true; \
		rm $(PID_FILE); \
		echo "Webserver gestoppt."; \
	else \
		echo "Webserver läuft scheinbar nicht (keine pid-Datei $(PID_FILE) gefunden)."; \
	fi

rebuild:
	@echo "Kompiliere SASS zu CSS..."
	@if command -v sass >/dev/null 2>&1; then \
		sass assets/sass/main.scss assets/css/main.css; \
		echo "Rebuild erfolgreich."; \
	else \
		echo "Fehler: 'sass' Kommando wurde nicht gefunden. Bitte installiere SASS (z.B. mit 'npm install -g sass' oder 'brew install sass')."; \
		exit 1; \
	fi
