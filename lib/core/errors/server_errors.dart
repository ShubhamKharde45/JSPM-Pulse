import 'package:meta/meta.dart';

@immutable
abstract class ServerResult<T> {
  const ServerResult();
}

class ServerSuccess<T> extends ServerResult<T> {
  final T data; // always non-null
  const ServerSuccess(this.data);
}

class ServerFailure<T> extends ServerResult<T> {
  final String message;
  final int? statusCode;

  const ServerFailure({
    required this.message,
    this.statusCode,
  });
}
