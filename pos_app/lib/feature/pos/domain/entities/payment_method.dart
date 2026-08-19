enum PaymentMethod {
  cash('현금'),
  card('카드');

  const PaymentMethod(this.label);

  final String label;
}
