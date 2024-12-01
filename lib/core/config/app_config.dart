import 'package:cloudinary_url_gen/cloudinary.dart';
import '../constants/constants.dart';
import '../exceptions/exceptions.dart';
import '../storage/secure_storage_service.dart';

class AppConfig {
  static final SecureStorageService secureStorage = SecureStorageService();
  static late final Cloudinary cloudinary;

  static Future<void> initialize() async {
    try {
      await _initializeCloudinary();
    } catch (e) {
      throw AppConfigurationException(
          'Failed to initialize app configuration: $e');
    }
  }

  static Future<void> _initializeCloudinary() async {
    final apiKey = await secureStorage.getCloudinaryApiKey();
    final apiSecret = await secureStorage.getCloudinaryApiSecret();

    if (apiKey == null || apiSecret == null) {
      // First time app initialization - set default values
      await secureStorage.saveCloudinaryCredentials(
        apiKey: 'your_default_api_key',
        apiSecret: 'your_default_api_secret',
      );
    }

    cloudinary = Cloudinary.fromCloudName(
      apiKey: apiKey ?? 'your_default_api_key',
      cloudName: cloudinaryCloudName,
    );
  }
}


