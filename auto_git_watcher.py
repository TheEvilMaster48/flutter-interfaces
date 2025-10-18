import os
import subprocess
from datetime import datetime

# Ruta del proyecto
PROJECT_PATH = r"C:\Users\Estku\Downloads\flutter_interfaces-main"

def subir_a_github():
    try:
        print("\n🟡 Se ha actualizado cambios, subiendo a GitHub...")

        os.chdir(PROJECT_PATH)

        # Detectar si hay cambios reales
        status = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True)
        if not status.stdout.strip():
            print("ℹ️ No hay cambios nuevos para subir.\n")
            print("✅ Informe: Ejecución completada. No se detectaron cambios.")
            return

        # Agregar, commit y push
        subprocess.run(["git", "add", "."], check=True)
        fecha = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        subprocess.run(["git", "commit", "-m", f"Auto actualización de código ({fecha})"], check=False)
        subprocess.run(["git", "push", "origin", "main"], check=True)

        print("✅ Subido correctamente a GitHub sin ningún problema.\n")
        print("📄 Informe: La ejecución del informe se completó correctamente y se subió a GitHub.")

    except subprocess.CalledProcessError:
        print("🔴 No se ha podido subir el proyecto a GitHub, revise e inténtelo de nuevo.\n")
        print("📄 Informe: La ejecución del informe falló por un error de Git o conexión.")

if __name__ == "__main__":
    subir_a_github()
