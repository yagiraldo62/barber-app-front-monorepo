class DurationAndPriceModel {
  late int duration;
  late num price;

  DurationAndPriceModel({this.duration = 0, this.price = 0});

  DurationAndPriceModel add({int? d, num? p}) {
    duration += (d ?? 0);
    price += (p ?? 0);

    return this;
  }
}
