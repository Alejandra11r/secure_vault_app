import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

StepDefinitionGeneric step1() {
  return then<FlutterWorld>(
    'la app está abierta',
    (context) async {
      await FlutterDriverUtils.isPresent(
          context.world.driver, find.byType('MaterialApp'));
    },
  );
}

StepDefinitionGeneric step2() {
  return then<FlutterWorld>(
    'ingreso credenciales válidas',
    (context) async {
      final username = find.byValueKey("email_field");
      final password = find.byValueKey("password_field");
      final btn = find.byValueKey("login_button");
      await FlutterDriverUtils.enterText(
          context.world.driver, username, "alejandra@gmail.com");
      await FlutterDriverUtils.enterText(
          context.world.driver, password, "123456789");
      await FlutterDriverUtils.tap(context.world.driver, btn);
    },
  );
}

StepDefinitionGeneric step3() {
  return then<FlutterWorld>(
    'debo ver la caja fuerte',
    (context) async {
      await FlutterDriverUtils.isPresent(
          context.world.driver, find.text("Mi Caja Fuerte"));
    },
  );
}
