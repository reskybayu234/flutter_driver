class ApiConfig {
  static const String baseUrl = 'http://192.168.10.214.nip.io';
  
  static String get apiUrlCore => '$baseUrl/api/v2/distribution/core';
  static String get apiUrlMaster => '$baseUrl/api/v2/distribution/master-data';
  
  // do-stockpile
  static String get doStockpileEndpoint => '$apiUrlCore/do-stockpile';
  static String get doStockpileMobileEndpoint => '$apiUrlCore/do-stockpile-mobile/:driverId';
  
  // shipping
  static String get shippingDocumentEndpoint => '$apiUrlCore/shipping-document';
  static String get shippingDocumentMobileEndpoint => '$apiUrlCore/shipping-documents-mobile';
  
  // drivers
  static String get driversEndpoint => '$apiUrlMaster/drivers/user';
  static String get driverEndpoint => '$apiUrlMaster/drivers/:driverId';

  // rent-order
  static String get rentOrderEndpoint => '$apiUrlMaster/rent-orders/driver/:driverId';
  
  // auth
  static String get authEndpoint => '$baseUrl/api/v2/common/users';
}