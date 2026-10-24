/// Currencies offered in setup. All use two minor digits, matching how money
/// is stored; three-digit currencies (KWD, BHD, OMR) need a storage change first.
abstract final class SupportedCurrencies {
  static const String aed = 'AED';
  static const String sar = 'SAR';
  static const String qar = 'QAR';
  static const String usd = 'USD';
  static const String gbp = 'GBP';
  static const String eur = 'EUR';
  static const String cad = 'CAD';
  static const String aud = 'AUD';
  static const String inr = 'INR';
  static const String bdt = 'BDT';

  static const String fallback = aed;

  static const List<String> codes = [aed, sar, qar, usd, gbp, eur, cad, aud, inr, bdt];
}
