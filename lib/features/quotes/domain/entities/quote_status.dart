enum QuoteStatus {
  quote,
  invoice,
  paid;

  bool get isInvoice => this != QuoteStatus.quote;
}
