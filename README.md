# Secure Vault

Aplicación Flutter offline-first para guardar notas, imágenes y documentos cifrados en el dispositivo.

## Funciones

- Registro e inicio de sesión local con correo y contraseña; no hay recuperación ni biometría.
- Crear, editar, organizar y eliminar notas y categorías.
- Importar fotos desde cámara o galería, y archivos JPEG, PNG, PDF o TXT. Límite: 50 MiB por archivo y 500 MiB por cuenta.
- Consultar el contenido después de cerrar sesión y volver a entrar con la misma cuenta.
- Eliminar explícitamente una cuenta y sus datos actuales; se confirma escribiendo `ELIMINAR`.
- Navegación por Inicio, Notas, Categorías, Archivos y Perfil. `/info` es la pantalla informativa usada por enlaces y notificaciones.

## Seguridad

Drift/SQLite guarda los datos de la bóveda cifrados con AES-256-GCM. Cada cuenta tiene una clave aleatoria, protegida mediante una clave derivada con Argon2id y HKDF-SHA-256. `flutter_secure_storage` conserva los datos locales de cuenta y el sobre cifrado.

La app bloquea la sesión al pasar a segundo plano; cerrar sesión conserva los datos. Si se pierde la contraseña, no se puede recuperar el contenido. Las notas heredadas AES-CBC no se migran ni se eliminan automáticamente. El borrado lógico no garantiza eliminar copias en WAL, respaldos o memoria flash. Los parámetros actuales de Argon2id requieren mediciones en dispositivos reales.

## Desarrollo

Requisitos: Flutter 3.35.6 y Java 17 para Android.

```sh
flutter pub get
flutter analyze
flutter test
flutter run --flavor developmentInternal \
  --dart-define=APP_ENV=development \
  --dart-define=APP_DISTRIBUTION=internal
```

GitHub Actions ejecuta análisis, pruebas y builds Android debug para seis combinaciones de ambiente (`development`, `staging`, `production`) y distribución (`internal`, `store`). Comparten el mismo `applicationId`; no están listos para instalarse juntos ni distribuirse. iOS aún no tiene flavors equivalentes. Los comandos `--dart-define` no son un almacén de secretos.

Los laboratorios de REST e isolates están en `lib/labs` y `lib/core/workers`; no son necesarios para usar la bóveda. GoRouter se usa en producción. No se incorporan Analytics, geolocalización ni sincronización REST.
