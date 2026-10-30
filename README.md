# Secure Vault App

Secure Vault es una aplicación Flutter **offline-first** para guardar notas, imágenes y documentos privados en el dispositivo. El contenido de la caja fuerte se cifra antes de persistirse. El acceso no depende de una cuenta en la nube ni de conexión a internet.

## Qué puedes hacer

- Crear una cuenta local con correo y contraseña, e iniciar sesión en este dispositivo. Los correos se normalizan para evitar cuentas duplicadas con diferencias de mayúsculas o espacios.
- Crear, consultar, editar y eliminar notas; organizarlas mediante categorías.
- Importar una foto desde la cámara o la galería, o seleccionar documentos compatibles.
- Previsualizar imágenes y texto guardados. Al exportar un documento se crea una copia descifrada fuera de la caja fuerte; elimínala cuando termines.
- Mantener los datos al cerrar sesión y volver a entrar con la misma cuenta local.
- Eliminar explícitamente una cuenta local y sus datos actuales de Drift; la interfaz pide escribir `ELIMINAR` para confirmar.

La navegación principal tiene las pestañas Inicio, Notas, Categorías, Archivos y Perfil. La ruta `/info` presenta información del producto y puede abrirse mediante notificaciones o el esquema `securevault://open/info`. Las rutas privadas siguen requiriendo una sesión desbloqueada.

## Seguridad y almacenamiento

- Las cuentas y el sobre cifrado de la clave se conservan con `flutter_secure_storage`.
- Notas, categorías, metadatos y bytes de archivos se almacenan localmente con Drift/SQLite; el contenido se cifra con AES-256-GCM.
- Cada cuenta usa una clave aleatoria de bóveda. La contraseña deriva una clave de envoltura con Argon2id y HKDF-SHA-256; el sobre autenticado permite comprobar la contraseña.
- La app bloquea la sesión al volver del segundo plano. Cerrar sesión limpia las claves de sesión en memoria, pero conserva los datos guardados.
- No hay biometría ni recuperación de contraseña. Si se olvida la contraseña, no se puede recuperar el acceso al contenido cifrado.
- El borrado lógico no garantiza la eliminación física de copias retenidas por SQLite WAL, backups o memoria flash. Las notas heredadas del formato AES-CBC no se migran ni se borran automáticamente.

El perfil criptográfico actual de Argon2id (32 MiB, dos iteraciones) es provisional: debe medirse en dispositivos Android e iOS reales antes de una publicación. La limpieza de buffers en memoria es de mejor esfuerzo y no equivale a borrado físico garantizado.

### Archivos compatibles

Se aceptan imágenes JPEG y PNG, documentos PDF y archivos TXT. El máximo es 50 MiB por archivo y 500 MiB por cuenta. Los tipos y firmas compatibles se validan antes de guardar.

## Conectividad y notificaciones

Firebase Messaging se conserva para permisos, tokens, recepción y navegación desde notificaciones. Es opcional para las funciones principales: sin Firebase o sin internet todavía se puede autenticar localmente y guardar o consultar el contenido de la caja fuerte. Las notificaciones sí requieren los servicios de Firebase y conectividad.

La app no incluye Firebase Analytics, geolocalización, sincronización REST, Method Channels propios ni trabajo en segundo plano para la bóveda.

## Tecnologías y estructura

- **Flutter + Provider:** interfaz y estado de autenticación/bóveda.
- **GetIt:** registro de dependencias.
- **GoRouter:** navegación productiva y protección de rutas según la sesión.
- **Drift/SQLite:** persistencia local relacional con aislamiento por cuenta.
- **flutter_secure_storage + cryptography:** almacenamiento del sobre de clave y primitivas de cifrado.
- **image_picker + file_picker:** cámara, galería y selector de documentos del sistema.
- **Firebase Messaging:** notificaciones push opcionales.

El código de producción está organizado por módulos de autenticación y bóveda, con capas de presentación, dominio y datos. Los ejercicios del assessment se mantienen fuera del flujo de producto:

- `lib/labs/assessment/rest_lab_client.dart`: cliente REST de práctica, no requerido para abrir la caja fuerte.
- `lib/core/workers/data_worker.dart`: ejercicio de isolates para CPU/JSON; no se deben enviar claves ni texto descifrado.
- AutoRoute es una alternativa para comparar con GoRouter en un ejercicio separado; la aplicación usa GoRouter.
- OWASP MASVS/MASTG, ASO y comparación de routers requieren evidencias y revisión específicas. Su presencia como temas del assessment no significa certificación, publicación ni integración de Analytics.

## Requisitos y comandos

Se recomienda Flutter 3.35.6 (Dart 3.9.x) y Java 17 para los builds Android.

```sh
flutter pub get
flutter analyze
flutter test
```

Para ejecutar el flavor Android de desarrollo interno:

```sh
flutter run --flavor developmentInternal \
  --dart-define=APP_ENV=development \
  --dart-define=APP_DISTRIBUTION=internal
```

Android define dos dimensiones de flavor: ambiente (`development`, `staging`, `production`) y distribución (`internal`, `store`). El workflow de GitHub Actions analiza y prueba el proyecto y construye APKs de verificación para sus seis combinaciones. Los flavors comparten por ahora el mismo `applicationId`; no deben instalarse lado a lado ni publicarse con esa configuración.

iOS mantiene el scheme `Runner`; no hay una matriz de schemes equivalente a los flavors Android. Antes de distribuir cualquier plataforma deben completarse firma, configuración de Firebase por aplicación, revisión de privacidad/políticas de tienda y pruebas en dispositivos reales.

`--dart-define` configura valores de cliente y no es un almacén de secretos. No incluyas claves privadas, contraseñas o tokens de CI en el binario ni en el repositorio.

## CI y manejo de secretos

El workflow ejecuta análisis, pruebas y builds de verificación; no publica releases. Si un token de Sonar que estuvo anteriormente en documentación era real, revócalo y rótalo, y revisa el historial Git: borrarlo del archivo no invalida una exposición previa. Si Sonar se usa en CI, guarda `SONAR_TOKEN` únicamente como secreto del proveedor.
