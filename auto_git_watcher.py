import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import subprocess

# Ruta del proyecto
PROJECT_PATH = r"C:\Users\Estku\Downloads\flutter_interfaces-main"

class GitAutoPushHandler(FileSystemEventHandler):
    def on_any_event(self, event):
        if event.is_directory:
            return
        try:
            print("🟡 Se ha actualizado cambios, subiendo a GitHub...")

            os.chdir(PROJECT_PATH)
            subprocess.run(["git", "add", "."], check=True)
            subprocess.run([
                "git", "commit", "-m", "Auto actualización de código"
            ], check=False)
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
