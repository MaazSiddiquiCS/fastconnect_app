class AppConstants {
  static const String appName = "FASTConnect";

  // Switch between mock backend and real backend easily
  static const String baseUrl = "https://mock.fastconnect.app/api"; 
  // Later: replace with your Spring Boot: "http://your-ip:8080/api"

  static const Duration networkTimeout = Duration(seconds: 15);
}
