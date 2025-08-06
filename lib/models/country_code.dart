class CountryCode {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const CountryCode({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

class CountryCodesData {
  static const List<CountryCode> countryCodes = [
    CountryCode(name: 'Albania', code: 'AL', dialCode: '+355', flag: '🇦🇱'),
    CountryCode(name: 'Andorra', code: 'AD', dialCode: '+376', flag: '🇦🇩'),
    CountryCode(name: 'Argentina', code: 'AR', dialCode: '+54', flag: '🇦🇷'),
    CountryCode(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
    CountryCode(name: 'Austria', code: 'AT', dialCode: '+43', flag: '🇦🇹'),
    CountryCode(name: 'Bahrain', code: 'BH', dialCode: '+973', flag: '🇧🇭'),
    CountryCode(name: 'Belarus', code: 'BY', dialCode: '+375', flag: '🇧🇾'),
    CountryCode(name: 'Belgium', code: 'BE', dialCode: '+32', flag: '🇧🇪'),
    CountryCode(name: 'Bosnia and Herzegovina', code: 'BA', dialCode: '+387', flag: '🇧🇦'),
    CountryCode(name: 'Brazil', code: 'BR', dialCode: '+55', flag: '🇧🇷'),
    CountryCode(name: 'Bulgaria', code: 'BG', dialCode: '+359', flag: '🇧🇬'),
    CountryCode(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
    CountryCode(name: 'Chile', code: 'CL', dialCode: '+56', flag: '🇨🇱'),
    CountryCode(name: 'China', code: 'CN', dialCode: '+86', flag: '🇨🇳'),
    CountryCode(name: 'Colombia', code: 'CO', dialCode: '+57', flag: '🇨🇴'),
    CountryCode(name: 'Croatia', code: 'HR', dialCode: '+385', flag: '🇭🇷'),
    CountryCode(name: 'Cyprus', code: 'CY', dialCode: '+357', flag: '🇨🇾'),
    CountryCode(name: 'Czech Republic', code: 'CZ', dialCode: '+420', flag: '🇨🇿'),
    CountryCode(name: 'Denmark', code: 'DK', dialCode: '+45', flag: '🇩🇰'),
    CountryCode(name: 'Ecuador', code: 'EC', dialCode: '+593', flag: '🇪🇨'),
    CountryCode(name: 'Egypt', code: 'EG', dialCode: '+20', flag: '🇪🇬'),
    CountryCode(name: 'Estonia', code: 'EE', dialCode: '+372', flag: '🇪🇪'),
    CountryCode(name: 'Finland', code: 'FI', dialCode: '+358', flag: '🇫🇮'),
    CountryCode(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
    CountryCode(name: 'Georgia', code: 'GE', dialCode: '+995', flag: '🇬🇪'),
    CountryCode(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
    CountryCode(name: 'Greece', code: 'GR', dialCode: '+30', flag: '🇬🇷'),
    CountryCode(name: 'Hong Kong', code: 'HK', dialCode: '+852', flag: '🇭🇰'),
    CountryCode(name: 'Hungary', code: 'HU', dialCode: '+36', flag: '🇭🇺'),
    CountryCode(name: 'Iceland', code: 'IS', dialCode: '+354', flag: '🇮🇸'),
    CountryCode(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
    CountryCode(name: 'Indonesia', code: 'ID', dialCode: '+62', flag: '🇮🇩'),
    CountryCode(name: 'Ireland', code: 'IE', dialCode: '+353', flag: '🇮🇪'),
    CountryCode(name: 'Israel', code: 'IL', dialCode: '+972', flag: '🇮🇱'),
    CountryCode(name: 'Italy', code: 'IT', dialCode: '+39', flag: '🇮🇹'),
    CountryCode(name: 'Japan', code: 'JP', dialCode: '+81', flag: '🇯🇵'),
    CountryCode(name: 'Jordan', code: 'JO', dialCode: '+962', flag: '🇯🇴'),
    CountryCode(name: 'Kenya', code: 'KE', dialCode: '+254', flag: '🇰🇪'),
    CountryCode(name: 'Kuwait', code: 'KW', dialCode: '+965', flag: '🇰🇼'),
    CountryCode(name: 'Latvia', code: 'LV', dialCode: '+371', flag: '🇱🇻'),
    CountryCode(name: 'Lebanon', code: 'LB', dialCode: '+961', flag: '🇱🇧'),
    CountryCode(name: 'Liechtenstein', code: 'LI', dialCode: '+423', flag: '🇱🇮'),
    CountryCode(name: 'Lithuania', code: 'LT', dialCode: '+370', flag: '🇱🇹'),
    CountryCode(name: 'Luxembourg', code: 'LU', dialCode: '+352', flag: '🇱🇺'),
    CountryCode(name: 'Malaysia', code: 'MY', dialCode: '+60', flag: '🇲🇾'),
    CountryCode(name: 'Malta', code: 'MT', dialCode: '+356', flag: '🇲🇹'),
    CountryCode(name: 'Mexico', code: 'MX', dialCode: '+52', flag: '🇲🇽'),
    CountryCode(name: 'Moldova', code: 'MD', dialCode: '+373', flag: '🇲🇩'),
    CountryCode(name: 'Monaco', code: 'MC', dialCode: '+377', flag: '🇲🇨'),
    CountryCode(name: 'Montenegro', code: 'ME', dialCode: '+382', flag: '🇲🇪'),
    CountryCode(name: 'Morocco', code: 'MA', dialCode: '+212', flag: '🇲🇦'),
    CountryCode(name: 'Netherlands', code: 'NL', dialCode: '+31', flag: '🇳🇱'),
    CountryCode(name: 'New Zealand', code: 'NZ', dialCode: '+64', flag: '🇳🇿'),
    CountryCode(name: 'Nigeria', code: 'NG', dialCode: '+234', flag: '🇳🇬'),
    CountryCode(name: 'North Macedonia', code: 'MK', dialCode: '+389', flag: '🇲🇰'),
    CountryCode(name: 'Norway', code: 'NO', dialCode: '+47', flag: '🇳🇴'),
    CountryCode(name: 'Oman', code: 'OM', dialCode: '+968', flag: '🇴🇲'),
    CountryCode(name: 'Peru', code: 'PE', dialCode: '+51', flag: '🇵🇪'),
    CountryCode(name: 'Philippines', code: 'PH', dialCode: '+63', flag: '🇵🇭'),
    CountryCode(name: 'Poland', code: 'PL', dialCode: '+48', flag: '🇵🇱'),
    CountryCode(name: 'Portugal', code: 'PT', dialCode: '+351', flag: '🇵🇹'),
    CountryCode(name: 'Qatar', code: 'QA', dialCode: '+974', flag: '🇶🇦'),
    CountryCode(name: 'Romania', code: 'RO', dialCode: '+40', flag: '🇷🇴'),
    CountryCode(name: 'Russia', code: 'RU', dialCode: '+7', flag: '🇷🇺'),
    CountryCode(name: 'San Marino', code: 'SM', dialCode: '+378', flag: '🇸🇲'),
    CountryCode(name: 'Saudi Arabia', code: 'SA', dialCode: '+966', flag: '🇸🇦'),
    CountryCode(name: 'Serbia', code: 'RS', dialCode: '+381', flag: '🇷🇸'),
    CountryCode(name: 'Singapore', code: 'SG', dialCode: '+65', flag: '🇸🇬'),
    CountryCode(name: 'Slovakia', code: 'SK', dialCode: '+421', flag: '🇸🇰'),
    CountryCode(name: 'Slovenia', code: 'SI', dialCode: '+386', flag: '🇸🇮'),
    CountryCode(name: 'South Africa', code: 'ZA', dialCode: '+27', flag: '🇿🇦'),
    CountryCode(name: 'South Korea', code: 'KR', dialCode: '+82', flag: '🇰🇷'),
    CountryCode(name: 'Spain', code: 'ES', dialCode: '+34', flag: '🇪🇸'),
    CountryCode(name: 'Sweden', code: 'SE', dialCode: '+46', flag: '🇸🇪'),
    CountryCode(name: 'Switzerland', code: 'CH', dialCode: '+41', flag: '🇨🇭'),
    CountryCode(name: 'Syria', code: 'SY', dialCode: '+963', flag: '🇸🇾'),
    CountryCode(name: 'Taiwan', code: 'TW', dialCode: '+886', flag: '🇹🇼'),
    CountryCode(name: 'Thailand', code: 'TH', dialCode: '+66', flag: '🇹🇭'),
    CountryCode(name: 'Turkey', code: 'TR', dialCode: '+90', flag: '🇹🇷'),
    CountryCode(name: 'Ukraine', code: 'UA', dialCode: '+380', flag: '🇺🇦'),
    CountryCode(name: 'United Arab Emirates', code: 'AE', dialCode: '+971', flag: '🇦🇪'),
    CountryCode(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
    CountryCode(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸'),
    CountryCode(name: 'Uruguay', code: 'UY', dialCode: '+598', flag: '🇺🇾'),
    CountryCode(name: 'Vatican City', code: 'VA', dialCode: '+379', flag: '🇻🇦'),
    CountryCode(name: 'Venezuela', code: 'VE', dialCode: '+58', flag: '🇻🇪'),
    CountryCode(name: 'Vietnam', code: 'VN', dialCode: '+84', flag: '🇻🇳'),
  ];

  static CountryCode getDefaultCountry() {
    return countryCodes.first; // Default to US
  }

  static CountryCode? findByDialCode(String dialCode) {
    try {
      return countryCodes.firstWhere((country) => country.dialCode == dialCode);
    } catch (e) {
      return null;
    }
  }

  static List<CountryCode> searchCountries(String query) {
    if (query.isEmpty) return countryCodes;
    
    final lowerQuery = query.toLowerCase();
    return countryCodes.where((country) {
      return country.name.toLowerCase().contains(lowerQuery) ||
             country.dialCode.contains(query) ||
             country.code.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}