enum AppEnvironment { development, staging, production }

enum AppDistribution { internal, store }

abstract final class AppBuildConfig {
  static const String _environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
  static const String _distribution = String.fromEnvironment(
    'APP_DISTRIBUTION',
    defaultValue: 'internal',
  );

  static AppEnvironment get environment => AppEnvironment.values.firstWhere(
        (value) => value.name == _environment,
        orElse: () => AppEnvironment.development,
      );

  static AppDistribution get distribution => AppDistribution.values.firstWhere(
        (value) => value.name == _distribution,
        orElse: () => AppDistribution.internal,
      );

  static bool get isProduction => environment == AppEnvironment.production;
}
