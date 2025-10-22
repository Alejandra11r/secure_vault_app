Feature: Login
  Como usuaria quiero iniciar sesión
  Para acceder a mi caja fuerte

Scenario: Inicio de sesión exitoso
  Given la app está abierta
  When ingreso credenciales válidas
  Then debo ver la caja fuerte
