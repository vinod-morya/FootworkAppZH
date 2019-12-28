import 'package:footwork_chinese/network/ApiClient.dart';
import 'package:footwork_chinese/network/_HttpClient.dart';

class ApiConfiguration {
  final ConfigConfig config;
  final ApiClient _apiClient;
  static ApiConfiguration _configutation;

  static void initialize(ConfigConfig config) {
    _createConfig(config);
  }

  static void _createConfig(ConfigConfig config) {
    if (_configutation != null) {}
    final client =
        HttpClient.createGuestClient(config.nativeDeviceId, config.isLoggedIn);
    _configutation = ApiConfiguration._(config, ApiClient.create(client));
  }

  static ApiConfiguration getInstance() {
    if (_configutation == null) {}
    return _configutation;
  }

  static void createNullConfiguration(ConfigConfig config) {
    _configutation = null;
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
