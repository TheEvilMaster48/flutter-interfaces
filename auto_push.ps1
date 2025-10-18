# 🧠 Auto Push GitHub - Flutter Interfaces
# Ejecuta este script cada vez que quieras subir cambios automáticamente

$projectPath = "C:\Users\Estku\Downloads\flutter_interfaces-main"
cd $projectPath

# 🧹 Agregar todos los cambios
git add .

# 📦 Crear un commit con fecha y hora
$fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Auto push - cambios realizados el $fecha"

# 🚀 Subir al repositorio remoto
git push origin main

Write-Host "`n✅ Proyecto subido correctamente a GitHub ($fecha)" -ForegroundColor Green
