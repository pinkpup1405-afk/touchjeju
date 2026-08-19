enum OrderType {
  dineIn('매장', '머그잔에 제공'),
  takeout('포장', '일회용컵(매장이용불가)');

  const OrderType(this.label, this.description);

  final String label;
  final String description;
}
