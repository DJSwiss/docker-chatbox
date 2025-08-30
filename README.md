# ChatBoxAI Docker-System: Multi-Architektur mit Wayland-Unterstützung

## Systembeschreibung

Dieses Docker-System ermöglicht die Ausführung der ChatBoxAI-Anwendung in einer containerisierten Umgebung mit voller Wayland-Unterstützung. Das System unterstützt sowohl ARM64- als auch x86_64-Architekturen über einen einzigen Build-Prozess und kann auf verschiedenen Linux-basierten Systemen ausgeführt werden.

## Komponenten

- **Multi-Architektur-Support**: ARM64 und x86_64 (AMD64)
- **Wayland-Integration**: Vollständige grafische Unterstützung über Wayland-Protokoll
- **Docker Buildx**: Erstellt plattformübergreifende Images
- **Sicherheit**: Container läuft mit eingeschränkten Berechtigungen

## Technische Grundlage

- Ubuntu 22.04 als Basis-Image
- Architekturspezifische ChatBoxAI-Binärdateien
- Wayland-Bibliotheken und Konfigurationen
- Docker BuildKit für Cross-Plattform-Builds

## Voraussetzungen

- Docker (≥ 20.10)
- Docker Buildx Plugin
- Wayland-Display-Server (für grafische Ausgabe)
- ChatBoxAI-Binärdateien (`chatboxai-x86_64` und `chatboxai-arm64`)

## Installation und Setup

### 1. Repository vorbereiten

```bash
# ChatBoxAI-Binärdateien in das Verzeichnis kopieren
cp /path/to/chatboxai-x86_64 .
cp /path/to/chatboxai-arm64 .
```

### 2. Image bauen

```bash
# Automatischer Build mit Skript
./build.sh

# Oder manuell:
docker buildx create --name chatboxai-builder --use
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t chatboxai-multi:latest -f Dockerfile.multi --load .
```

### 3. Container ausführen

#### Mit Skript (empfohlen):
```bash
./run.sh
```

#### Mit Docker-Compose:
```bash
# Erststart
USER_ID=$(id -u) docker-compose up -d

# Updates
docker-compose down && docker-compose up -d
```

#### Manuell:
```bash
docker run -d --name chatboxai \
  -p 3000:3000 \
  -v /run/user/$(id -u)/wayland-0:/tmp/wayland-0 \
  -e WAYLAND_DISPLAY=wayland-0 \
  -e XDG_RUNTIME_DIR=/tmp \
  -e GDK_BACKEND=wayland \
  --security-opt no-new-privileges:true \
  --cap-drop=ALL \
  --cap-add=SETUID \
  --cap-add=SETGID \
  chatboxai-multi:latest
```

## Umgebungsvariablen

| Variable | Beschreibung | Standard |
|----------|-------------|----------|
| `WAYLAND_DISPLAY` | Pfad zum Wayland-Socket | `wayland-0` |
| `XDG_RUNTIME_DIR` | Temporäres Verzeichnis für Laufzeitdateien | `/tmp` |
| `GDK_BACKEND` | Grafiksystem-Backend | `wayland` |
| `QT_QPA_PLATFORM` | Qt Platform Abstraction | `wayland` |
| `PORT` | Externe Port-Nummer | `3000` |

## Dateien

| Datei | Beschreibung |
|-------|-------------|
| `Dockerfile.multi` | Multi-Architektur Dockerfile |
| `docker-compose.yml` | Docker Compose Konfiguration |
| `build.sh` | Build-Skript für Multi-Architektur |
| `run.sh` | Container-Ausführungsskript |

## System-Wartung

### Container-Management
```bash
# Status prüfen
docker ps --filter "name=chatboxai"

# Logs anzeigen
docker logs chatboxai

# Container stoppen
docker stop chatboxai

# Container neu starten
docker restart chatboxai

# Container-Shell öffnen
docker exec -it chatboxai /bin/bash
```

### Image-Updates
```bash
# Neues Image bauen
./build.sh

# Container mit neuem Image neu starten
docker-compose down && docker-compose up -d
```

### Bereinigung
```bash
# Nicht verwendete Images entfernen
docker image prune

# Alle ChatBoxAI-Container und Images entfernen
docker stop chatboxai
docker rm chatboxai
docker rmi chatboxai-multi:latest
```

## Troubleshooting

### Wayland-Probleme
```bash
# Wayland-Socket prüfen
ls -la /run/user/$(id -u)/wayland-0

# Wayland-Umgebung prüfen
echo $WAYLAND_DISPLAY
echo $XDG_RUNTIME_DIR
```

### Container-Probleme
```bash
# Detaillierte Logs
docker logs --follow chatboxai

# Container-Informationen
docker inspect chatboxai

# Health-Check Status
docker ps --filter "name=chatboxai" --format "table {{.Names}}\t{{.Status}}"
```

## Sicherheitshinweise

- Container läuft mit eingeschränkten Berechtigungen (`--cap-drop=ALL`)
- Wayland-Socket wird sicher gemountet
- Keine Root-Ausführung innerhalb des Containers
- Security-Optionen sind aktiviert (`no-new-privileges`)
- Nur notwendige Capabilities werden gewährt

## Performance-Optimierung

- Multi-Stage-Build für kleinere Images
- Wayland-native Ausführung für bessere Performance
- Health-Checks für Container-Überwachung
- Persistent Volume für Daten-Persistierung

## Support

Bei Problemen oder Fragen:

1. Prüfen Sie die Container-Logs: `docker logs chatboxai`
2. Überprüfen Sie die Wayland-Konfiguration
3. Stellen Sie sicher, dass alle Voraussetzungen erfüllt sind
4. Verwenden Sie die bereitgestellten Skripte für konsistente Ergebnisse