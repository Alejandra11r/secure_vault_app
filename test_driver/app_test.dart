import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'steps/login_steps.dart';
import 'package:glob/glob.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    
    ..features = [Glob(r"test_driver/features/login.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json'),
    ]
    ..stepDefinitions = [
      step1(),
      step2(),
      step3(),
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
