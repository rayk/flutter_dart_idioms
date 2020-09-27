part of assessable_criteron;

class RapidlyPerishable extends QualificationCriterion
    with AssumedCriterionPassFail {
  static const Symbol timeBeforeDecay = Symbol('time_before_decay');
  static const Symbol density = Symbol('density');
  final Duration ambientTempTimeThreshold;
  final double referenceDensity;

  RapidlyPerishable(
      {this.ambientTempTimeThreshold = const Duration(minutes: 60),
      this.referenceDensity = 1.00});

  @override
  bool assess(Assessable subject) =>
      canAssumeResult(subject.criterionValue(timeBeforeDecay)[timeBeforeDecay])
          ? assumedResult(
              subject.criterionValue(timeBeforeDecay)[timeBeforeDecay],
              onNoValue: false)
          : ambientTempTimeThreshold >=
              subject.criterionValue(timeBeforeDecay)[timeBeforeDecay];

  @override
  double score(Assessable subject) => !assess(subject) ||
          canAssumeResult(
              subject.criterionValue(timeBeforeDecay)[timeBeforeDecay])
      ? referenceDensity
      : referenceDensity / subject.criterionValue(density)[density];
}
