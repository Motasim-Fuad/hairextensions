import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/features/quotes/data/mappers/quote_api_mapper.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';

void main() {
  test('quote and invoice ids never collide', () {
    expect(QuoteApiMapper.quoteId(12), 'q12');
    expect(QuoteApiMapper.invoiceId(12), 'i12');
  });

  group('lines sent to the API', () {
    test('hair priced by whole packs sends pack size, pack price and markup', () {
      const line = QuoteLine(
        id: 'l1',
        category: LineCategory.hair,
        title: 'Tape-in',
        variant: '#1B',
        amountMinor: 30000,
        costMinor: 20000,
        grams: 100,
        packs: 2,
        leftoverGrams: 0,
        markupPercent: 50,
      );

      final json = QuoteApiMapper.lineToApi(line);

      expect(json['kind'], 'hair');
      expect(json['description'], 'Tape-in · #1B');
      expect(json['grams_required'], 100);
      expect(json['grams_per_pack'], '50.00');
      expect(json['pack_price'], '100.00');
      expect(json['markup_percent'], '50.00');
      expect(json['whole_packs'], isTrue);
    });

    test('an hourly service is labour and a flat service is a service', () {
      const hourly = QuoteLine(
        id: 'l2',
        category: LineCategory.service,
        title: 'Install',
        amountMinor: 30000,
        unitPriceMinor: 15000,
        hours: 2,
      );
      const flat = QuoteLine(id: 'l3', category: LineCategory.service, title: 'Consult', amountMinor: 5000);

      expect(QuoteApiMapper.lineToApi(hourly), containsPair('kind', 'labour'));
      expect(QuoteApiMapper.lineToApi(hourly), containsPair('hourly_rate', '150.00'));
      expect(QuoteApiMapper.lineToApi(flat), containsPair('kind', 'service'));
      expect(QuoteApiMapper.lineToApi(flat), containsPair('unit_price', '50.00'));
    });

    test('shipping passes through at cost as a fee', () {
      const shipping = QuoteLine(id: 'l4', category: LineCategory.shipping, title: 'Shipping', amountMinor: 2500);

      final json = QuoteApiMapper.lineToApi(shipping);

      expect(json['kind'], 'fee');
      expect(json['unit_price'], '25.00');
      expect(json['unit_cost'], '25.00');
    });
  });

  group('lines read from the API', () {
    test('a fee at cost is shipping, any other fee is an add-on', () {
      final shipping = QuoteApiMapper.lineFromApi({
        'id': 1,
        'kind': 'fee',
        'description': 'Shipping',
        'quantity': '1',
        'unit_price': '25.00',
        'unit_cost': '25.00',
        'price': '25.00',
        'cost': '25.00',
        'taxable': false,
      });
      final addOn = QuoteApiMapper.lineFromApi({
        'id': 2,
        'kind': 'fee',
        'description': 'Toner',
        'quantity': '1',
        'unit_price': '40.00',
        'unit_cost': '10.00',
        'price': '40.00',
        'cost': '10.00',
        'taxable': true,
      });

      expect(shipping.category, LineCategory.shipping);
      expect(addOn.category, LineCategory.addOn);
      expect(addOn.profitMinor, 3000);
    });

    test('a hair description splits back into title and colour', () {
      final line = QuoteApiMapper.lineFromApi({
        'id': 3,
        'kind': 'hair',
        'description': 'Tape-in · #1B',
        'grams_required': '100.00',
        'packs_needed': 2,
        'leftover_grams': '0.00',
        'whole_packs': true,
        'markup_percent': '50.00',
        'price': '300.00',
        'cost': '200.00',
        'taxable': true,
      });

      expect(line.title, 'Tape-in');
      expect(line.variant, '#1B');
      expect(line.grams, 100);
      expect(line.packs, 2);
      expect(line.amountMinor, 30000);
      expect(line.costMinor, 20000);
    });
  });

  group('list summaries', () {
    test('a quote summary reproduces the total and the profit', () {
      final quote = QuoteApiMapper.quoteFromSummary({
        'id': 12,
        'number': 'Q0012',
        'status': 'draft',
        'client_name': 'Sara',
        'currency': 'AED',
        'total': '1050.00',
        'profit': '400.00',
        'created_at': '2026-10-24T10:00:00Z',
      });

      expect(quote.id, 'q12');
      expect(quote.status, QuoteStatus.quote);
      expect(quote.totals.totalMinor, 105000);
      expect(quote.totals.profitMinor, 40000);
    });

    test('an invoice summary leaves the amount still due as the balance', () {
      final invoice = QuoteApiMapper.invoiceFromSummary({
        'id': 7,
        'number': 'INV0007',
        'status': 'deposit_paid',
        'client_name': 'Sara',
        'currency': 'AED',
        'total': '1000.00',
        'amount_due': '700.00',
        'created_at': '2026-10-24T10:00:00Z',
      });

      expect(invoice.id, 'i7');
      expect(invoice.status, QuoteStatus.invoice);
      expect(invoice.totals.balanceMinor, 70000);
    });

    test('a paid invoice maps to the paid status', () {
      final invoice = QuoteApiMapper.invoiceFromSummary({
        'id': 8,
        'number': 'INV0008',
        'status': 'paid',
        'client_name': 'Sara',
        'currency': 'AED',
        'total': '500.00',
        'amount_due': '0.00',
        'created_at': '2026-10-24T10:00:00Z',
      });

      expect(invoice.status, QuoteStatus.paid);
    });
  });
}
