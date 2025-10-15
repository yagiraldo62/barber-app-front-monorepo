import 'package:core/data/models/location_service_model.dart';
import 'package:core/data/models/shared/duration_and_price_model.dart';

DurationAndPriceModel getDurationAndPriceFromServiceList(
  List<LocationServiceModel>? services,
) {
  DurationAndPriceModel durationAndPrice = (services ?? []).fold(
    DurationAndPriceModel(),
    (durationAndPrice, service) =>
        durationAndPrice.add(d: service.duration, p: service.price),
  );

  return durationAndPrice;
}
