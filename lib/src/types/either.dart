/// 함수형 프로그래밍의 Either 타입
///
/// 성공(Right) 또는 실패(Left) 값을 표현하는 ADT(Algebraic Data Type)
///
/// ```dart
/// Either<String, int> divide(int a, int b) {
///   if (b == 0) return Left('Division by zero');
///   return Right(a ~/ b);
/// }
///
/// final result = divide(10, 2)
///   .map((value) => value * 2)
///   .fold(
///     (error) => 'Error: $error',
///     (value) => 'Result: $value',
///   );
/// ```
sealed class Either<L, R> {
  const Either();

  /// Left 값인지 확인
  bool get isLeft;

  /// Right 값인지 확인
  bool get isRight;

  /// Right 값에 함수를 적용 (Left는 그대로 전달)
  ///
  /// ```dart
  /// Right(5).map((x) => x * 2); // Right(10)
  /// Left('error').map((x) => x * 2); // Left('error')
  /// ```
  Either<L, R2> map<R2>(R2 Function(R) fn);

  /// Right 값에 Either를 반환하는 함수를 적용 (flatMap/bind)
  ///
  /// ```dart
  /// Right(5).flatMap((x) => Right(x * 2)); // Right(10)
  /// Right(5).flatMap((x) => Left('error')); // Left('error')
  /// ```
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) fn);

  /// Left와 Right를 각각 처리하여 하나의 값으로 변환
  ///
  /// ```dart
  /// Right(5).fold((l) => 'Error: $l', (r) => 'Value: $r'); // 'Value: 5'
  /// Left('oops').fold((l) => 'Error: $l', (r) => 'Value: $r'); // 'Error: oops'
  /// ```
  T fold<T>(T Function(L) onLeft, T Function(R) onRight);

  /// Right 값을 가져오거나, Left일 경우 기본값 반환
  R getOrElse(R Function() defaultValue);

  /// Right 값을 가져오거나, null 반환
  R? getOrNull();
}

/// Either의 Left (실패/에러) 값
final class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  Either<L, R2> map<R2>(R2 Function(R) fn) => Left(value);

  @override
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) fn) => Left(value);

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onLeft(value);

  @override
  R getOrElse(R Function() defaultValue) => defaultValue();

  @override
  R? getOrNull() => null;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Left<L, R> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// Either의 Right (성공) 값
final class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  Either<L, R2> map<R2>(R2 Function(R) fn) => Right(fn(value));

  @override
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) fn) => fn(value);

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onRight(value);

  @override
  R getOrElse(R Function() defaultValue) => value;

  @override
  R? getOrNull() => value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Right<L, R> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
