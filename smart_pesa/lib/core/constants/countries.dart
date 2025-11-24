class Country {
  final String code;
  final String name;
  final String currency;
  final String currencySymbol;
  final String flag;

  const Country({
    required this.code,
    required this.name,
    required this.currency,
    required this.currencySymbol,
    required this.flag,
  });
}

const List<Country> countries = [
  // --- User Defaults ---
  Country(code: 'RW', name: 'Rwanda', currency: 'RWF', currencySymbol: 'Rwf', flag: '🇷🇼'),
  Country(code: 'US', name: 'United States', currency: 'USD', currencySymbol: '\$', flag: '🇺🇸'),
  Country(code: 'KE', name: 'Kenya', currency: 'KES', currencySymbol: 'KSh', flag: '🇰🇪'),
  Country(code: 'UG', name: 'Uganda', currency: 'UGX', currencySymbol: 'USh', flag: '🇺🇬'),
  Country(code: 'TZ', name: 'Tanzania', currency: 'TZS', currencySymbol: 'TSh', flag: '🇹🇿'),
  Country(code: 'GB', name: 'United Kingdom', currency: 'GBP', currencySymbol: '£', flag: '🇬🇧'),
  Country(code: 'EU', name: 'European Union', currency: 'EUR', currencySymbol: '€', flag: '🇪🇺'),
  Country(code: 'CN', name: 'China', currency: 'CNY', currencySymbol: '¥', flag: '🇨🇳'),
  Country(code: 'IN', name: 'India', currency: 'INR', currencySymbol: '₹', flag: '🇮🇳'),
  Country(code: 'JP', name: 'Japan', currency: 'JPY', currencySymbol: '¥', flag: '🇯🇵'),

  // --- North America ---
  Country(code: 'CA', name: 'Canada', currency: 'CAD', currencySymbol: '\$', flag: '🇨🇦'),
  Country(code: 'MX', name: 'Mexico', currency: 'MXN', currencySymbol: '\$', flag: '🇲🇽'),

  // --- South America ---
  Country(code: 'BR', name: 'Brazil', currency: 'BRL', currencySymbol: 'R\$', flag: '🇧🇷'),
  Country(code: 'AR', name: 'Argentina', currency: 'ARS', currencySymbol: '\$', flag: '🇦🇷'),
  Country(code: 'CL', name: 'Chile', currency: 'CLP', currencySymbol: '\$', flag: '🇨🇱'),
  Country(code: 'CO', name: 'Colombia', currency: 'COP', currencySymbol: '\$', flag: '🇨🇴'),
  Country(code: 'PE', name: 'Peru', currency: 'PEN', currencySymbol: 'S/', flag: '🇵🇪'),
  Country(code: 'UY', name: 'Uruguay', currency: 'UYU', currencySymbol: '\$U', flag: '🇺🇾'),
  Country(code: 'PY', name: 'Paraguay', currency: 'PYG', currencySymbol: '₲', flag: '🇵🇾'),
  Country(code: 'BO', name: 'Bolivia', currency: 'BOB', currencySymbol: 'Bs.', flag: '🇧🇴'),

  // --- Europe (Non-Euro & Major Euro) ---
  Country(code: 'CH', name: 'Switzerland', currency: 'CHF', currencySymbol: 'CHF', flag: '🇨🇭'),
  Country(code: 'SE', name: 'Sweden', currency: 'SEK', currencySymbol: 'kr', flag: '🇸🇪'),
  Country(code: 'NO', name: 'Norway', currency: 'NOK', currencySymbol: 'kr', flag: '🇳🇴'),
  Country(code: 'DK', name: 'Denmark', currency: 'DKK', currencySymbol: 'kr', flag: '🇩🇰'),
  Country(code: 'IS', name: 'Iceland', currency: 'ISK', currencySymbol: 'kr', flag: '🇮🇸'),
  Country(code: 'RU', name: 'Russia', currency: 'RUB', currencySymbol: '₽', flag: '🇷🇺'),
  Country(code: 'TR', name: 'Turkey', currency: 'TRY', currencySymbol: '₺', flag: '🇹🇷'),
  Country(code: 'UA', name: 'Ukraine', currency: 'UAH', currencySymbol: '₴', flag: '🇺🇦'),
  Country(code: 'PL', name: 'Poland', currency: 'PLN', currencySymbol: 'zł', flag: '🇵🇱'),
  Country(code: 'CZ', name: 'Czech Republic', currency: 'CZK', currencySymbol: 'Kč', flag: '🇨🇿'),
  Country(code: 'HU', name: 'Hungary', currency: 'HUF', currencySymbol: 'Ft', flag: '🇭🇺'),
  Country(code: 'RO', name: 'Romania', currency: 'RON', currencySymbol: 'lei', flag: '🇷🇴'),
  Country(code: 'BG', name: 'Bulgaria', currency: 'BGN', currencySymbol: 'лв', flag: '🇧🇬'),
  // Major Eurozone Countries (useful if searching by country name instead of just 'EU')
  Country(code: 'DE', name: 'Germany', currency: 'EUR', currencySymbol: '€', flag: '🇩🇪'),
  Country(code: 'FR', name: 'France', currency: 'EUR', currencySymbol: '€', flag: '🇫🇷'),
  Country(code: 'IT', name: 'Italy', currency: 'EUR', currencySymbol: '€', flag: '🇮🇹'),
  Country(code: 'ES', name: 'Spain', currency: 'EUR', currencySymbol: '€', flag: '🇪🇸'),
  Country(code: 'NL', name: 'Netherlands', currency: 'EUR', currencySymbol: '€', flag: '🇳🇱'),
  Country(code: 'BE', name: 'Belgium', currency: 'EUR', currencySymbol: '€', flag: '🇧🇪'),

  // --- Asia / Pacific ---
  Country(code: 'AU', name: 'Australia', currency: 'AUD', currencySymbol: '\$', flag: '🇦🇺'),
  Country(code: 'NZ', name: 'New Zealand', currency: 'NZD', currencySymbol: '\$', flag: '🇳🇿'),
  Country(code: 'KR', name: 'South Korea', currency: 'KRW', currencySymbol: '₩', flag: '🇰🇷'),
  Country(code: 'SG', name: 'Singapore', currency: 'SGD', currencySymbol: '\$', flag: '🇸🇬'),
  Country(code: 'HK', name: 'Hong Kong', currency: 'HKD', currencySymbol: '\$', flag: '🇭🇰'),
  Country(code: 'TW', name: 'Taiwan', currency: 'TWD', currencySymbol: 'NT\$', flag: '🇹🇼'),
  Country(code: 'ID', name: 'Indonesia', currency: 'IDR', currencySymbol: 'Rp', flag: '🇮🇩'),
  Country(code: 'TH', name: 'Thailand', currency: 'THB', currencySymbol: '฿', flag: '🇹🇭'),
  Country(code: 'VN', name: 'Vietnam', currency: 'VND', currencySymbol: '₫', flag: '🇻🇳'),
  Country(code: 'MY', name: 'Malaysia', currency: 'MYR', currencySymbol: 'RM', flag: '🇲🇾'),
  Country(code: 'PH', name: 'Philippines', currency: 'PHP', currencySymbol: '₱', flag: '🇵🇭'),
  Country(code: 'PK', name: 'Pakistan', currency: 'PKR', currencySymbol: '₨', flag: '🇵🇰'),
  Country(code: 'BD', name: 'Bangladesh', currency: 'BDT', currencySymbol: '৳', flag: '🇧🇩'),
  Country(code: 'LK', name: 'Sri Lanka', currency: 'LKR', currencySymbol: 'Rs', flag: '🇱🇰'),
  Country(code: 'NP', name: 'Nepal', currency: 'NPR', currencySymbol: 'Rs', flag: '🇳🇵'),
  Country(code: 'KZ', name: 'Kazakhstan', currency: 'KZT', currencySymbol: '₸', flag: '🇰🇿'),

  // --- Middle East ---
  Country(code: 'AE', name: 'United Arab Emirates', currency: 'AED', currencySymbol: 'د.إ', flag: '🇦🇪'),
  Country(code: 'SA', name: 'Saudi Arabia', currency: 'SAR', currencySymbol: '﷼', flag: '🇸🇦'),
  Country(code: 'IL', name: 'Israel', currency: 'ILS', currencySymbol: '₪', flag: '🇮🇱'),
  Country(code: 'QA', name: 'Qatar', currency: 'QAR', currencySymbol: '﷼', flag: '🇶🇦'),
  Country(code: 'KW', name: 'Kuwait', currency: 'KWD', currencySymbol: 'د.ك', flag: '🇰🇼'),
  Country(code: 'OM', name: 'Oman', currency: 'OMR', currencySymbol: '﷼', flag: '🇴🇲'),
  Country(code: 'BH', name: 'Bahrain', currency: 'BHD', currencySymbol: '.د.ب', flag: '🇧🇭'),
  Country(code: 'JO', name: 'Jordan', currency: 'JOD', currencySymbol: 'د.ا', flag: '🇯🇴'),
  Country(code: 'LB', name: 'Lebanon', currency: 'LBP', currencySymbol: 'ل.ل', flag: '🇱🇧'),

  // --- Africa ---
  Country(code: 'ZA', name: 'South Africa', currency: 'ZAR', currencySymbol: 'R', flag: '🇿🇦'),
  Country(code: 'NG', name: 'Nigeria', currency: 'NGN', currencySymbol: '₦', flag: '🇳🇬'),
  Country(code: 'GH', name: 'Ghana', currency: 'GHS', currencySymbol: '₵', flag: '🇬🇭'),
  Country(code: 'EG', name: 'Egypt', currency: 'EGP', currencySymbol: 'E£', flag: '🇪🇬'),
  Country(code: 'MA', name: 'Morocco', currency: 'MAD', currencySymbol: 'د.م.', flag: '🇲🇦'),
  Country(code: 'DZ', name: 'Algeria', currency: 'DZD', currencySymbol: 'د.ج', flag: '🇩🇿'),
  Country(code: 'TN', name: 'Tunisia', currency: 'TND', currencySymbol: 'د.ت', flag: '🇹🇳'),
  Country(code: 'ET', name: 'Ethiopia', currency: 'ETB', currencySymbol: 'Br', flag: '🇪🇹'),
  Country(code: 'AO', name: 'Angola', currency: 'AOA', currencySymbol: 'Kz', flag: '🇦🇴'),
  Country(code: 'ZM', name: 'Zambia', currency: 'ZMW', currencySymbol: 'ZK', flag: '🇿🇲'),
  Country(code: 'ZW', name: 'Zimbabwe', currency: 'ZWL', currencySymbol: '\$', flag: '🇿🇼'),
  Country(code: 'MU', name: 'Mauritius', currency: 'MUR', currencySymbol: '₨', flag: '🇲🇺'),
  Country(code: 'SC', name: 'Seychelles', currency: 'SCR', currencySymbol: '₨', flag: '🇸🇨'),
  Country(code: 'CD', name: 'DR Congo', currency: 'CDF', currencySymbol: 'FC', flag: '🇨🇩'),

  // --- Central America & Caribbean ---
  Country(code: 'CR', name: 'Costa Rica', currency: 'CRC', currencySymbol: '₡', flag: '🇨🇷'),
  Country(code: 'GT', name: 'Guatemala', currency: 'GTQ', currencySymbol: 'Q', flag: '🇬🇹'),
  Country(code: 'HN', name: 'Honduras', currency: 'HNL', currencySymbol: 'L', flag: '🇭🇳'),
  Country(code: 'JM', name: 'Jamaica', currency: 'JMD', currencySymbol: 'J\$', flag: '🇯🇲'),
  Country(code: 'DO', name: 'Dominican Republic', currency: 'DOP', currencySymbol: 'RD\$', flag: '🇩🇴'),
  Country(code: 'PA', name: 'Panama', currency: 'PAB', currencySymbol: 'B/.', flag: '🇵🇦'),
];

/// Helper method to retrieve a country by its code.
Country getCountryByCode(String code) {
  return countries.firstWhere(
    (country) => country.code == code,
    orElse: () => countries.first, // Returns Rwanda by default
  );
}