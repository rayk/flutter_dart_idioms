/// Implemented by an object that plans to submit itself for assessment.
abstract class Assessable {
  /// Returned via [criterionValue] to assume value passes the assessment.
  static const assumeValuePassing = Symbol('assume_value_pass');

  /// Returned via [criterionValue] to assume value fails the assessment.
  static const assumeValueFailing = Symbol('assume_value_fail');

  /// Returned via [criterionValue] to indicate the value is not known to the
  /// subject.
  static const noValue = Symbol('no_value');

  /// Returns Map of the value associated with the passed in Symbol. The
  /// value of the attribute may come directly from a getter or can be
  /// a derived value. Key here is that the knowledge of how to resolve
  /// value for the given [Symbol] should be encapsulated within subject.
  /// [assumeValuePassing], [assumeValueFailing] can be used to explicitly
  /// force the assessment to pass or fail. [noValue] indicates the subject
  /// has no knowledge how to resolve a value for the passed in attribute.
  Map<Symbol, Object> criterionValue(Symbol attribute);
}

/// Uniformed utilities of handling missing assessment values and values that
/// that can force an assessment to pass or fail.
mixin AssumedCriterionPassFail on QualificationCriterion {
  bool _isAssumedSymbol(Symbol assessmentValue) =>
      assessmentValue == Assessable.assumeValuePassing ||
      assessmentValue == Assessable.assumeValueFailing ||
      assessmentValue == Assessable.noValue;

  /// Returns true when the value being assessed contains either
  /// [Assessable.assumeValuePassing] or [Assessable.assumeValueFailing] or
  /// [Assessable.noValue].
  bool canAssumeResult(assessmentValue) {
    assert(assessmentValue != null,
        'Assessment value was null! Use Assessable.noValue, represent nothing or empty.');
    return assessmentValue is Symbol
        ? _isAssumedSymbol(assessmentValue)
        : false;
  }

  /// Returns pass/true when the [assessmentValue] is [Assessable.assumeValuePassing]
  /// fail/false is returned when [assessmentValue] is [Assessable.assumeValueFailing].
  /// By default [false] is returned for [Assessable.noValue] unless defined in
  /// the optional [onNoValue].
  bool assumedResult(Symbol assessmentValue, {bool onNoValue = false}) =>
      _isAssumedSymbol(assessmentValue)
          ? assessmentValue == Assessable.noValue
              ? onNoValue
              : assessmentValue == Assessable.assumeValuePassing
          : throw ArgumentError();
}

abstract class QualificationCriterion<T extends Assessable> {
  /// Return True if the [subject] passes the assessment for this
  /// criterion. The approach here is to determine if the result can be
  /// assumed see [AssumedCriterionPassFail.canAssumeResult] only when it
  /// can not execute the implementation to determine if the subject
  /// passes or fails.
  bool assess(T subject);

  /// Returns a double value that can be used to measure how much/well etc
  /// did the subject pass the criterion.
  double score(T subject);
}

/// Describes the set of conditions by which a subject can become qualified.
class QualificationCriteria<T> {
  List<QualificationCriterion> criterion;

  QualificationCriteria and(QualificationCriterion criterion) {
    return this;
  }

  QualificationCriteria or(QualificationCriterion criterion) {
    return this;
  }

  QualificationCriteria must(QualificationCriterion criterion) {
    return this;
  }

  QualificationCriteria not(QualificationCriterion criterion) {
    return this;
  }
}

/// Assessor that undertakes the work to determine if a subject meets the
/// criteria to become qualified.
class QualificationAssessor<T> {
  final QualificationCriteria criteria;

  const QualificationAssessor(this.criteria);

  bool call(T subject) {}

  double score() {}
}

/// A & B || C &  D & !B
