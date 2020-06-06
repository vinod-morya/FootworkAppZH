import '../network/ApiClient.dart';
import '../network/_HttpClient.dart';

class ApiConfiguration {
  final ConfigConfig config;
  final ApiClient _apiClient;
  static ApiConfiguration _configuration;

  static void initialize(ConfigConfig config) {
    _createConfig(config);
  }

  static void _createConfig(ConfigConfig config) {
    if (_configuration != null) {}
    final client =
        HttpClient.createGuestClient(config.nativeDeviceId, config.isLoggedIn);
    _configuration = ApiConfiguration._(config, ApiClient.create(client));
  }

  static ApiConfiguration getInstance() {
    if (_configuration == null) {}
    return _configuration;
  }

  static void createNullConfiguration(ConfigConfig config) {
    _configuration = null;
    initialize(config);
  }

  ApiConfiguration._(this.config, this._apiClient);

  ApiClient get apiClient => _apiClient;
}

class ConfigConfig {
  final String nativeDeviceId;
  bool isLoggedIn;

  ConfigConfig(this.nativeDeviceId, this.isLoggedIn);
}
