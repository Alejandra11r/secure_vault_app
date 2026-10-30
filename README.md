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
| CI/CD, tiendas, granjas de dispositivos y MobSF | Parcial | CI analiza, prueba y compila combinaciones Android; faltan integración en dispositivo, MobSF y publicación aprobada. |
| Arquitectura modular y paquetes publicables | Parcial | Hay módulos por feature/capa; aún no hay paquetes internos extraídos/publicados. |
| GoRouter/AutoRoute | Cumple parcialmente | GoRouter está integrado; faltan guardas de sesión y pruebas de enlaces externos. |
| UI responsive/adaptativa | Parcial | Login desplazable y contenido acotado; faltan layouts adaptativos y pruebas de tamaños/accesibilidad. |
| Persistencia local segura | Parcial | Usa secure storage; revisar diseño criptográfico, gestión de claves y modelo de datos antes de producción. |
| REST y trabajo paralelo | Parcial | Existe un isolate de demostración; no hay cliente REST. Isolates deben reservarse para trabajo CPU-bound medido. |
| Permisos y políticas de tiendas | Parcial | Se solicita permiso de notificaciones; faltan checklist de privacidad y revisión de políticas para publicación. |
| Hardware y APIs nativas | No implementado | No hay un caso de producto definido para cámara/ubicación/canales nativos. |
| Universal/App Links y push | Parcial | FCM recibe mensajes; falta configuración verificada de dominios y cobertura completa de arranque en frío. |
| Analítica | No implementado | Definir necesidad, consentimiento y eventos antes de añadir SDK o recopilar datos. |
| Flavors multidimensionales | Parcial | Android tiene dimensiones ambiente/distribución y CI construye las combinaciones; falta paridad iOS, proyectos Firebase y firma de tienda. |

## Seguridad y CI

El workflow de GitHub Actions ejecuta análisis, tests y builds de verificación sin publicar releases ni conceder permisos de escritura al job de CI. La publicación debe ser un workflow protegido separado, con aprobación, firma almacenada en secretos de CI y permisos mínimos. Integrar MobSF/device farm requiere definir servicio, credenciales y política de retención de artefactos.

Un token de Sonar apareció previamente en la documentación del proyecto y se eliminó. Si era real, revocarlo/rotarlo y limpiar también el historial Git; eliminarlo del archivo no invalida exposiciones anteriores. Configurar `SONAR_TOKEN` únicamente como secreto del proveedor si se reactiva el análisis.

## Decisiones para producción

- No añadir permisos de hardware hasta que una función de producto los necesite; solicitar permisos en contexto y documentar su propósito.
- Extraer paquetes cuando exista una API reutilizable y estable; no fragmentar la app solo para aumentar el número de módulos.
- Añadir analítica, base de datos local o servicios REST tras acordar requisitos de privacidad, volumen y ciclo de vida de datos.
