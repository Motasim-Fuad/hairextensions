import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/features/quotes/data/mappers/quote_api_mapper.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';

void main() {
  final draft = Quote(
    id: 'local',
    number: '',
    status: QuoteStatus.quote,
    clientName: 'QA',
    createdAt: DateTime(2026),
    validUntil: DateTime(2026, 2),
    currencyCode: 'USD',
    vatRatePercent: 5,
    depositMinor: 0,
  );
  test(
    'server preview totals are used without recalculating empty local lines',
    () {
      final priced = QuoteApiMapper.previewFromApi({
        'currency': 'USD',
        'tax_rate_percent': '5.00',
        'totals': {
          'subtotal': '25.00',
          'taxable_amount': '25.00',
          'tax_amount': '1.25',
          'total': '26.25',
          'deposit_amount': '7.88',
          'balance_due': '18.37',
          'total_cost': '5.00',
          'profit': '20.00',
          'margin_percent': '80.00',
          'labour_hours': '2.00',
          'profit_per_hour': '10.00',
        },
      }, draft);
      expect(priced.totals.totalMinor, 2625);
      expect(priced.totals.depositMinor, 788);
      expect(priced.totals.balanceMinor, 1837);
      expect(priced.totals.profitPerHourMinor, 1000);
      expect(priced.copyWith(clientName: 'Changed').totals.totalMinor, 2625);
      expect(priced.copyWith(lines: []).serverTotals, isNull);
    },
  );
  test(
    'invoice keeps source quote id and paid balance for cost sheet routing',
    () {
      final invoice = QuoteApiMapper.invoiceFromApi({
        'id': 4,
        'quote_id': 6,
        'number': 'INV0001',
        'status': 'paid',
        'client_name': 'QA',
        'created_at': '2026-10-29T00:00:00Z',
        'due_date': '2026-11-01',
        'currency': 'USD',
        'tax_rate_percent': '0',
        'deposit_amount': '7.50',
        'amount_paid': '25.00',
        'lines': [
          {
            'id': 1,
            'kind': 'service',
            'description': 'Service',
            'price': '25.00',
            'cost': '5.00',
            'taxable': true,
          },
        ],
      });
      expect(invoice.sourceQuoteId, '6');
      expect(invoice.id, 'i4');
      expect(invoice.totals.balanceMinor, 0);
      expect(invoice.serverStatus, 'paid');
    },
  );
}
