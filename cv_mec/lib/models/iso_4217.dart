class ISO4217 {
  /// Map of ISO 4217 alphabetic currency codes to numeric codes
  static const Map<String, int> alphabeticToNumeric = {
    // Major Currencies
    'USD': 840,  // United States Dollar
    'EUR': 978,  // Euro
    'GBP': 826,  // British Pound Sterling
    'JPY': 392,  // Japanese Yen
    'CHF': 756,  // Swiss Franc
    'CAD': 124,  // Canadian Dollar
    'AUD': 36,   // Australian Dollar
    'NZD': 554,  // New Zealand Dollar
    'SEK': 752,  // Swedish Krona
    'NOK': 578,  // Norwegian Krone
    'DKK': 208,  // Danish Krone
    
    // Asian Currencies
    'CNY': 156,  // Chinese Yuan Renminbi
    'HKD': 344,  // Hong Kong Dollar
    'SGD': 702,  // Singapore Dollar
    'KRW': 410,  // South Korean Won
    'INR': 356,  // Indian Rupee
    'THB': 764,  // Thai Baht
    'MYR': 458,  // Malaysian Ringgit
    'IDR': 360,  // Indonesian Rupiah
    'PHP': 608,  // Philippine Peso
    'VND': 704,  // Vietnamese Dong
    'TWD': 901,  // New Taiwan Dollar
    
    // European Currencies
    'PLN': 985,  // Polish Zloty
    'CZK': 203,  // Czech Koruna
    'HUF': 348,  // Hungarian Forint
    'RON': 946,  // Romanian Leu
    'BGN': 975,  // Bulgarian Lev
    'HRK': 191,  // Croatian Kuna
    'RSD': 941,  // Serbian Dinar
    'RUB': 643,  // Russian Ruble
    'UAH': 980,  // Ukrainian Hryvnia
    'TRY': 949,  // Turkish Lira
    
    // Middle Eastern & African Currencies
    'AED': 784,  // UAE Dirham
    'SAR': 682,  // Saudi Riyal
    'QAR': 634,  // Qatari Riyal
    'KWD': 414,  // Kuwaiti Dinar
    'BHD': 48,   // Bahraini Dinar
    'OMR': 512,  // Omani Rial
    'JOD': 400,  // Jordanian Dinar
    'LBP': 422,  // Lebanese Pound
    'EGP': 818,  // Egyptian Pound
    'ZAR': 710,  // South African Rand
    'NGN': 566,  // Nigerian Naira
    'KES': 404,  // Kenyan Shilling
    'GHS': 936,  // Ghanaian Cedi
    'MAD': 504,  // Moroccan Dirham
    'TND': 788,  // Tunisian Dinar
    'DZD': 12,   // Algerian Dinar
    
    // Latin American Currencies
    'MXN': 484,  // Mexican Peso
    'BRL': 986,  // Brazilian Real
    'ARS': 32,   // Argentine Peso
    'CLP': 152,  // Chilean Peso
    'COP': 170,  // Colombian Peso
    'PEN': 604,  // Peruvian Sol
    'UYU': 858,  // Uruguayan Peso
    'BOB': 68,   // Bolivian Boliviano
    'PYG': 600,  // Paraguayan Guarani
    'VES': 928,  // Venezuelan Bolívar
    
    // Other Notable Currencies
    'ILS': 376,  // Israeli New Shekel
    'PKR': 586,  // Pakistani Rupee
    'BDT': 50,   // Bangladeshi Taka
    'LKR': 144,  // Sri Lankan Rupee
    'NPR': 524,  // Nepalese Rupee
    'AFN': 971,  // Afghan Afghani
    'IRR': 364,  // Iranian Rial
    'IQD': 368,  // Iraqi Dinar

    // Precious Metals
    'XAU': 959,  // Gold
    'XAG': 961,  // Silver
    'XPT': 962,  // Platinum
    'XPD': 964,  // Palladium
    
    // Special Drawing Rights
    'XDR': 960,  // IMF Special Drawing Rights
    
    // Test currencies
    'XTS': 963,  // Code for testing purposes
    'XXX': 999,  // No currency
  };

  /// Map of ISO 4217 numeric codes to alphabetic codes (reverse lookup)
  static const Map<int, String> numericToAlphabetic = {
    840: 'USD', 978: 'EUR', 826: 'GBP', 392: 'JPY', 756: 'CHF',
    124: 'CAD', 36: 'AUD', 554: 'NZD', 752: 'SEK', 578: 'NOK',
    208: 'DKK', 156: 'CNY', 344: 'HKD', 702: 'SGD', 410: 'KRW',
    356: 'INR', 764: 'THB', 458: 'MYR', 360: 'IDR', 608: 'PHP',
    704: 'VND', 901: 'TWD', 985: 'PLN', 203: 'CZK', 348: 'HUF',
    946: 'RON', 975: 'BGN', 191: 'HRK', 941: 'RSD', 643: 'RUB',
    980: 'UAH', 949: 'TRY', 784: 'AED', 682: 'SAR', 634: 'QAR',
    414: 'KWD', 48: 'BHD', 512: 'OMR', 400: 'JOD', 422: 'LBP',
    818: 'EGP', 710: 'ZAR', 566: 'NGN', 404: 'KES', 936: 'GHS',
    504: 'MAD', 788: 'TND', 12: 'DZD', 484: 'MXN', 986: 'BRL',
    32: 'ARS', 152: 'CLP', 170: 'COP', 604: 'PEN', 858: 'UYU',
    68: 'BOB', 600: 'PYG', 928: 'VES', 376: 'ILS', 586: 'PKR',
    50: 'BDT', 144: 'LKR', 524: 'NPR', 971: 'AFN', 364: 'IRR',
    368: 'IQD', 959: 'XAU', 961: 'XAG', 962: 'XPT', 964: 'XPD',
    960: 'XDR', 963: 'XTS', 999: 'XXX',
  };

  /// Get numeric code from alphabetic code
  static int? getNumericCode(String alphabeticCode) {
    return alphabeticToNumeric[alphabeticCode.toUpperCase()];
  }

  /// Get alphabetic code from numeric code
  static String? getAlphabeticCode(int numericCode) {
    return numericToAlphabetic[numericCode];
  }

  /// Check if a currency code is valid
  static bool isValidAlphabeticCode(String code) {
    return alphabeticToNumeric.containsKey(code.toUpperCase());
  }

  /// Check if a numeric code is valid
  static bool isValidNumericCode(int code) {
    return numericToAlphabetic.containsKey(code);
  }

  /// Get all supported alphabetic codes
  static List<String> getAllAlphabeticCodes() {
    return alphabeticToNumeric.keys.toList()..sort();
  }

  /// Get all supported numeric codes
  static List<int> getAllNumericCodes() {
    return numericToAlphabetic.keys.toList()..sort();
  }
}