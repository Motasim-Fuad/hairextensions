import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity_type.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_line_factory.dart';

/// Sample quotes matching the design, dated relative to today so "Today",
/// "Yesterday" and the monthly stats always look alive. Client and product
/// names are sample data, not UI copy.
abstract final class DemoQuotes {
  static const String currency = 'AED';
  static const double vatRate = 5;
  static const int nextQuoteNumber = 13;
  static const int nextInvoiceNumber = 7;
  static const int _validityDays = 14;
  static const double _markup = 60;
  static const String _note = 'Deposit secures your appointment and is non-refundable. Balance due on the day.';
  static const String _paymentLink = 'https://pay.glamstrands.ae/deposit';
  static const Duration _shareDelay = Duration(minutes: 7);
  static const Duration _createdAtTime = Duration(hours: 10, minutes: 24);

  static List<Quote> build(DateTime now) {
    final today = DateTime(now.year, now.month, now.day).add(_createdAtTime);
    return [
      _quote(
        id: 'quote-12',
        number: 'Q-0012',
        status: QuoteStatus.quote,
        client: 'Sara Al Mansoori',
        phone: '+971 55 987 6543',
        createdAt: today,
        depositMinor: 60000,
        lines: [
          _hair('12-1', 'Luxe Tape-In 22”', '#60 Platinum', 170, 35000, 100),
          _service('12-2', 'Full head tape-in install', 18000, 3.5),
          _item('12-3', LineCategory.material, 'Tape tabs refill', 2, 4000, 2000),
          _item('12-4', LineCategory.addOn, 'Toning & blend', 1, 15000, 0),
          _shipping('12-5', 2500),
        ],
      ),
      _quote(
        id: 'invoice-6',
        number: 'INV-0006',
        status: QuoteStatus.invoice,
        client: 'Layla Haddad',
        phone: '+971 50 442 1180',
        createdAt: today.subtract(const Duration(days: 1)),
        depositMinor: 100000,
        lines: [
          _hair('6-1', 'Genius Weft 24”', '#1B Natural Black', 240, 52000, 120),
          _service('6-2', 'Full head weft install', 18000, 5),
          _item('6-3', LineCategory.material, 'Aftercare kit', 1, 12000, 6000),
          _item('6-4', LineCategory.addOn, 'Toning & blend', 1, 15000, 0),
        ],
      ),
      _quote(
        id: 'invoice-5',
        number: 'INV-0005',
        status: QuoteStatus.paid,
        client: 'Noor Rahman',
        phone: '+971 52 310 7745',
        createdAt: today.subtract(const Duration(days: 6)),
        depositMinor: 40000,
        lines: [
          _hair('5-1', 'Nano Ring 18”', '#613 Blonde', 100, 30000, 100),
          _service('5-2', 'Move-up', 16000, 1.5),
          _item('5-3', LineCategory.material, 'Micro rings (100)', 1, 5000, 2500),
          _shipping('5-4', 2500),
        ],
      ),
      _quote(
        id: 'quote-11',
        number: 'Q-0011',
        status: QuoteStatus.quote,
        client: 'Mariam Saeed',
        phone: '+971 56 908 2231',
        createdAt: today.subtract(const Duration(days: 9)),
        depositMinor: 80000,
        lines: [
          _hair('11-1', 'Silk Keratin Bonds 20”', '#8 Chestnut', 150, 42000, 100),
          _service('11-2', 'Keratin bond install', 18000, 4),
          _item('11-3', LineCategory.material, 'Keratin glue sticks', 2, 3000, 1500),
        ],
      ),
      _quote(
        id: 'invoice-4',
        number: 'INV-0004',
        status: QuoteStatus.paid,
        client: 'Hessa Al Ali',
        phone: '+971 55 120 4478',
        createdAt: today.subtract(const Duration(days: 17)),
        depositMinor: 120000,
        lines: [
          _hair('4-1', 'Clip-In Set 20”', '#4 Mocha', 320, 69000, 160),
          _service('4-2', 'Full head tape-in install', 18000, 3),
          _item('4-3', LineCategory.addOn, 'Toning & blend', 1, 15000, 0),
          _shipping('4-4', 3500),
        ],
      ),
      _quote(
        id: 'quote-10',
        number: 'Q-0010',
        status: QuoteStatus.quote,
        client: 'Aisha Rahimi',
        phone: '+971 50 776 9012',
        createdAt: today.subtract(const Duration(days: 21)),
        depositMinor: 50000,
        lines: [
          _hair('10-1', 'Balayage Tape-In 22”', '#4/27 Balayage', 120, 38000, 100),
          _service('10-2', 'Half head', 18000, 2),
          _item('10-3', LineCategory.material, 'Tape tabs refill', 1, 4000, 2000),
        ],
      ),
      _quote(
        id: 'invoice-3',
        number: 'INV-0003',
        status: QuoteStatus.paid,
        client: 'Reem Khalil',
        phone: '+971 54 667 3320',
        createdAt: today.subtract(const Duration(days: 33)),
        depositMinor: 70000,
        lines: [
          _hair('3-1', 'Micro I-Tip 22”', '#10 Honey', 160, 34000, 100),
          _service('3-2', 'Full head tape-in install', 18000, 3.5),
          _item('3-3', LineCategory.material, 'Micro rings (100)', 2, 5000, 2500),
        ],
      ),
      _quote(
        id: 'quote-9',
        number: 'Q-0009',
        status: QuoteStatus.quote,
        client: 'Dana Yousef',
        phone: '+971 58 210 6654',
        createdAt: today.subtract(const Duration(days: 40)),
        depositMinor: 40000,
        lines: [
          _hair('9-1', 'Luxe Tape-In 18”', '#18 Ash Blonde', 90, 29000, 100),
          _service('9-2', 'Move-up', 16000, 1.5),
        ],
      ),
    ];
  }

  static Quote _quote({
    required String id,
    required String number,
    required QuoteStatus status,
    required String client,
    required String phone,
    required DateTime createdAt,
    required int depositMinor,
    required List<QuoteLine> lines,
  }) {
    return Quote(
      id: id,
      number: number,
      status: status,
      clientName: client,
      clientPhone: phone,
      appointment: createdAt.add(const Duration(days: 3)),
      createdAt: createdAt,
      validUntil: createdAt.add(const Duration(days: _validityDays)),
      currencyCode: currency,
      vatRatePercent: vatRate,
      depositMinor: depositMinor,
      lines: lines,
      note: _note,
      paymentLink: _paymentLink,
      activity: [
        QuoteActivity(type: QuoteActivityType.created, at: createdAt),
        QuoteActivity(type: QuoteActivityType.shared, at: createdAt.add(_shareDelay)),
        if (status.isInvoice)
          QuoteActivity(type: QuoteActivityType.convertedToInvoice, at: createdAt.add(const Duration(hours: 2))),
        if (status == QuoteStatus.paid)
          QuoteActivity(type: QuoteActivityType.markedPaid, at: createdAt.add(const Duration(days: 2))),
      ],
    );
  }

  static QuoteLine _hair(String id, String name, String colour, int grams, int packPriceMinor, int perPack) {
    final product = Product(
      id: 'seed-$id',
      name: name,
      type: HairType.tapeIn,
      lengthInches: 0,
      colour: colour,
      soldBy: SoldBy.grams,
      packPriceMinor: packPriceMinor,
      unitsPerPack: perPack,
      pricingMode: PricingMode.markup,
      markupPercent: _markup,
      retailPerUnitMinor: 0,
      isTaxable: true,
      updatedAt: DateTime(0),
    );
    return QuoteLineFactory.hair(
      id: id,
      product: product,
      grams: grams,
      wholePack: true,
      pricingMode: PricingMode.markup,
      markupPercent: _markup,
      retailPriceMinor: 0,
      isTaxable: true,
    );
  }

  static QuoteLine _service(String id, String title, int rateMinor, double hours) {
    return QuoteLineFactory.service(id: id, title: title, rateMinor: rateMinor, hours: hours, isTaxable: true);
  }

  static QuoteLine _item(String id, LineCategory category, String title, int quantity, int priceMinor, int costMinor) {
    return QuoteLineFactory.item(
      id: id,
      category: category,
      title: title,
      quantity: quantity,
      unitPriceMinor: priceMinor,
      unitCostMinor: costMinor,
      isTaxable: true,
    );
  }

  static QuoteLine _shipping(String id, int amountMinor) {
    return QuoteLineFactory.shipping(id: id, title: '', amountMinor: amountMinor, isTaxable: false);
  }
}
