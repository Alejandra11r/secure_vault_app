# Secure Vault App

Aplicación Flutter de demostración para autenticación y almacenamiento de notas cifradas.

## Desarrollo

Requiere Flutter 3.35.6 o compatible con el SDK indicado en `pubspec.yaml`.

```sh
flutter pub get
flutter analyze
flutter test
```

## Ambientes y flavors Android

Android separa dos dimensiones independientes: ambiente (`development`, `staging`, `production`) y distribución (`internal`, `store`). Las seis combinaciones actuales se validan en GitHub Actions y reciben valores `APP_ENV` y `APP_DISTRIBUTION` en Dart.

```sh
flutter run --flavor developmentInternal \
  --dart-define=APP_ENV=development \
  --dart-define=APP_DISTRIBUTION=internal

flutter build appbundle --release --flavor productionStore \
  --dart-define=APP_ENV=production \
  --dart-define=APP_DISTRIBUTION=store
```

Por ahora todas las combinaciones conservan el mismo `applicationId` para coincidir con el único registro Firebase que existe en el repositorio. Antes de instalar ambientes lado a lado o distribuirlos, registrar cada aplicación Android con Firebase, guardar su configuración por source set/ambiente, y entonces asignar identificadores únicos. No se debe distribuir un flavor hasta configurar firma de producción y verificar Firebase, privacidad y políticas de tienda.

iOS todavía usa el scheme `Runner` y no tiene schemes/configuraciones equivalentes. Para paridad multiplataforma hay que añadir schemes compartidos y configuraciones Xcode por las combinaciones que realmente se vayan a distribuir; generar y asociar los `GoogleService-Info.plist` correctos antes de hacerlo.

`--dart-define` configura valores cliente; no es un almacén de secretos. No incluir claves privadas, contraseñas ni tokens de CI en el binario.

## Estado de revisión de objetivos

| Objetivo | Estado | Pendiente principal |
| --- | --- | --- |
| CI/CD, dispositivos y MobSF | Parcial | CI Android conserva workflows; faltan ejecución en dispositivos, MobSF y publicación aprobada. |
| Arquitectura modular | Parcial | La app se organiza por módulos/capas; no se extraen paquetes internos sin APIs estables. |
| GoRouter / AutoRoute | GoRouter en producción | Guards y deep links están integrados; AutoRoute queda como comparación aislada del assessment. |
| UI responsive | Parcial | Bóveda usa layout adaptable teléfono/tablet; falta validar accesibilidad y tamaños en dispositivos. |
| Persistencia y seguridad | Implementado en app | SQLite/Drift con payload cifrado y archivos privados; faltan pruebas de MASTG y revisión externa. |
| REST, async e isolates | Laboratorios separados | Cliente REST y worker no son dependencias de apertura/uso offline de la bóveda. |
| Permisos y APIs nativas | Implementado para medios | Cámara y selectores; no se usa ubicación, Method Channel ni background work. |
| Push y deep links | Integrado y opcional | Firebase Messaging se inicializa en segundo plano de arranque; verificar en dispositivos y configurar dominios universal links antes de distribuir. |
| MASVS/MASTG y ASO | Guía de assessment | Consultar `docs/assessment/README.md`; faltan evidencias de pruebas manuales y revisión actual de tiendas. |
| Flavors y publicación | Parcial | Android conserva combinaciones; faltan paridad iOS, firma y configuraciones Firebase verificadas por distribución. |

## Seguridad y CI

El workflow de GitHub Actions ejecuta análisis, tests y builds de verificación sin publicar releases ni conceder permisos de escritura al job de CI. La publicación debe ser un workflow protegido separado, con aprobación, firma almacenada en secretos de CI y permisos mínimos. Integrar MobSF/device farm requiere definir servicio, credenciales y política de retención de artefactos.

Un token de Sonar apareció previamente en la documentación del proyecto y se eliminó. Si era real, revocarlo/rotarlo y limpiar también el historial Git; eliminarlo del archivo no invalida exposiciones anteriores. Configurar `SONAR_TOKEN` únicamente como secreto del proveedor si se reactiva el análisis.

## Decisiones para producción

- No añadir permisos de hardware hasta que una función de producto los necesite; solicitar permisos en contexto y documentar su propósito.
- Extraer paquetes cuando exista una API reutilizable y estable; no fragmentar la app solo para aumentar el número de módulos.
- La aplicación principal funciona offline; Firebase Messaging y los laboratorios REST no son requisito para acceder a los datos.
- No incorporar Firebase Analytics, geolocalización, Method Channels ni tareas de background.
- Las notas anteriores al esquema Drift no se migran ni se borran automáticamente.
