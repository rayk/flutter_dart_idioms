/// Contain value objects for the various types of items that can be stored.
/// Ideally these would be immutable and implemented with BuiltValue.
library storage_item;

import 'package:flutter_dart_idioms/select/all_qualify.dart';

import 'criterion/criterion.dart';

/// Base of all items that are stored.
abstract class StorageItem extends Assessable {
  String id;
  double weightKg;
  double spaceMCube;
  double insuredValue;
  Duration timeBeforeDecay;
}

/// Represents an item held in temperature controlled storage.
class ColdStorageItem extends StorageItem {
  double minStoreTemperature;
  double maxStoreTemperature;

  @override
  Map<Symbol, Object> criterionValue(Symbol attribute) {
    var value;
    switch (attribute) {
      case ExtremeLowTemperatureRequirement.requiredMinTemp:
        {
          value = {attribute: maxStoreTemperature};
        }
        break;
      case RapidlyPerishable.timeBeforeDecay:
        {
          value = {attribute: timeBeforeDecay};
        }
        break;
      case RapidlyPerishable.density:
        {
          value = {attribute: weightKg / spaceMCube};
        }
        break;
      default:
        value = {attribute: Assessable.noValue};
        break;
    }
    return value;
  }
}

/// Represents an item held in humidity controlled storage.
class DryStorageItem extends StorageItem {
  double minStoreHumidity;
  double maxStoreHumidity;

  @override
  Map<Symbol, Object> criterionValue(Symbol attribute) {
    var value;
    switch (attribute) {
      default:
        value = {attribute: Assessable.noValue};
        break;
    }
    return value;
  }
}
