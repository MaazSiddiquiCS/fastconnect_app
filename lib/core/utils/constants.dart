class AppConstants {
  static const String appName = "FASTConnect";

  // Switch between mock backend and real backend easily
  static const String baseUrl = "https://mock.fastconnect.app/api"; 
  // Later: replace with your Spring Boot: "http://your-ip:8080/api"

  static const Duration networkTimeout = Duration(seconds: 15);
  static const String pexelsApiKey = 'j1jkGvFnBdTAc2O7tt2yhG3DhHInC1jpf5qFZGzrC5qXTdtIARduVHpQ';
  static const String pexelsBaseUrl = 'https://api.pexels.com';
}
