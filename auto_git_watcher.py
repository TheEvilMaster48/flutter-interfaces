import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import subprocess

# Ruta del proyecto
PROJECT_PATH = r"C:\Users\Estku\Downloads\flutter_interfaces-main"

# Archivos o carpetas que no deben activar el evento
IGNORAR = [
    ".git", "__pycache__", "auto_git_watcher.py",
    "pubspec.lock", ".dart_tool", "build"
]

class GitAutoPushHandler(FileSystemEventHandler):
    ultima_subida = 0

    def on_any_event(self, event):
        # Evita directorios o archivos ignorados
        if any(skip in event.src_path for skip in IGNORAR):
            return

        # Evita ejecuciones múltiples seguidas (cooldown de 10s)
        if time.time() - self.ultima_subida < 10:
            return

        try:
            print("\n🟡 Se ha actualizado cambios, subiendo a GitHub...")
            self.ultima_subida = time.time()

            os.chdir(PROJECT_PATH)

            # Detectar si realmente hay cambios
            status = subprocess.run(["git", "status", "--porcelain"],
                                    capture_output=True, text=True)
            if not status.stdout.strip():
                print("ℹ️ No hay cambios nuevos para subir.\n")
                return

            # Subir cambios reales
            subprocess.run(["git", "add", "."], check=True)
            subprocess.run(["git", "commit", "-m", "Auto actualización de código"], check=False)
            subprocess.run(["git", "push", "origin", "main"], check=True)

            print("✅ Subido correctamente a GitHub sin ningún problema.\n")

        except subprocess.CalledProcessError:
            print("🔴 No se ha podido subir el proyecto a GitHub, revise e inténtelo de nuevo.\n")


if __name__ == "__main__":
    event_handler = GitAutoPushHandler()
    observer = Observer()
    observer.schedule(event_handler, PROJECT_PATH, recursive=True)
    observer.start()

    print("👀 Monitorizando cambios en tu proyecto Flutter... (presiona CTRL+C para detener)\n")

    try:
        while True:
            time.sleep(2)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
