part of assessable_criteron;

/// Simply criterion based on one attribute from the [subject].
///
/// Accepts any object that implements [Assessable], where the
/// assessable attribute contains no value then subject fails
/// the this criterion.
///
/// Can be built from code template.
class ExtremeLowTemperatureRequirement<StorageItem>
    extends QualificationCriterion with AssumedCriterionPassFail {
  /// The Symbol that any object what wishes to be assessed should depend upon
  /// and return a value for.
  /// - Symbol is deliberately used to to survive minification and represent the
  /// Uniqueness of the value assess by this this criterion.
  /// - Searching for Usage of this symbol in the IDE provides a list ofß
  /// all classes submitting themselves to this criterion.
  static const Symbol requiredMinTemp = Symbol('ext_low_temp');
  final double thresholdTemp;

  /// Criterion constructed with criteria values that could vary at runtime.
  ExtremeLowTemperatureRequirement({@required this.thresholdTemp});

  /// Returns true when [subject] requires extreme low temperature storage.
  @override
  bool assess(Assessable subject) =>
      canAssumeResult(subject.criterionValue(requiredMinTemp)[requiredMinTemp])
          ? assumedResult(
              subject.criterionValue(requiredMinTemp)[requiredMinTemp],
              onNoValue: false)
          : thresholdTemp >=
              subject.criterionValue(requiredMinTemp)[requiredMinTemp];

  /// Return a calculated value that is the difference between [thresholdTemp]
  /// and the required temperature. Subject which don't pass or are assumed to pass
  /// this criterion receive a score of zero.
  @override
  double score(Assessable subject) => !assess(subject) ||
          canAssumeResult(
              subject.criterionValue(requiredMinTemp)[requiredMinTemp])
      ? 0.00
      : thresholdTemp -
          subject.criterionValue(requiredMinTemp)[requiredMinTemp];
}
