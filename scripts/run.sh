#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

usage() {
  echo "Usage: $0 [start|stop|restart|logs|status|build]"
  echo ""
  echo "  start    Start the server (default)"
  echo "  stop     Stop the server"
  echo "  restart  Restart the server"
  echo "  logs     Follow server logs"
  echo "  status   Show running containers"
  echo "  build    Rebuild the Docker image (after changing Dockerfile)"
}

if [ ! -f .env ]; then
  echo "No .env file found. Creating from .env.example..."
  cp .env.example .env
  echo "Edit .env and set ADMIN_PASSWORD, then re-run this script."
  exit 1
fi

CMD="${1:-start}"

case "$CMD" in
  start)
    docker compose up -d
    echo "Server started. Follow logs with: $0 logs"
    ;;
  build)
    docker compose build --no-cache
    ;;
  stop)
    docker compose down
    ;;
  restart)
    docker compose restart
    ;;
  logs)
    docker compose logs -f
    ;;
  status)
    docker compose ps
    ;;
  *)
    usage
    exit 1
    ;;
esac
