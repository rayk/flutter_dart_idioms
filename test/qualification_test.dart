import 'package:flutter_dart_idioms/select/all_qualify.dart';
@Tags(['unit'])
import 'package:flutter_test/flutter_test.dart';

import '../example/criterion/criterion.dart';
import '../example/storage_item.dart';

var subjectA = ColdStorageItem();

void main() {
  ColdStorageItem subjectA, subjectB, subjectC;
  QualificationCriterion xLowTempRequired;

  setUp(() {
    subjectA = ColdStorageItem()..maxStoreTemperature = -5.00;
    subjectB = ColdStorageItem()..maxStoreTemperature = -35.50;
    subjectC = ColdStorageItem();
    xLowTempRequired = ExtremeLowTemperatureRequirement(thresholdTemp: -35.00);
  });

  tearDown(() async {});

  group('Assess subject against a criterion:', () {
    test('Should pass or fail based upon an attribute with the object.', () {
      expect(xLowTempRequired.assess(subjectA), false);
      expect(xLowTempRequired.assess(subjectB), true);
    });

    test('Should error when subject returns a null.', () {
      expect(() => xLowTempRequired.assess(subjectC), throwsAssertionError,
          reason: 'Error when subject has a null value for a known attribute.');
    });

    test('Should return NoValue when attribute is unknown to the subject.', () {
      var unknownAttribute = Symbol('unknown_to_subject');
      expect(subjectA.criterionValue(unknownAttribute),
          {unknownAttribute: Assessable.noValue});
    });
  });

  group('Scoring how well the criterion was met.', () {
    test('Should return a score for a subject that did not pass.', () {
      expect(xLowTempRequired.score(subjectA), 0);
    });

    test('Should return a score for a subject that did pass.', () {
      expect(xLowTempRequired.score(subjectB), 0.5);
    });
  });
}
