class AppConfigurationException implements Exception {
  final String message;

  AppConfigurationException(this.message);

  @override
  String toString() => 'AppConfigurationException: $message';
}

class MissingEnvironmentVariableException implements Exception {
  final String message;

  MissingEnvironmentVariableException(this.message);

  @override
  String toString() => 'MissingEnvironmentVariableException: $message';
}