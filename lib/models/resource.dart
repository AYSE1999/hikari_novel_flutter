sealed class Resource<T> {
  final T? data;
  final dynamic error;

  const Resource({this.data, this.error});
}

class Success<T> extends Resource<T> {
  const Success(T data) : super(data: data);
}

class Error extends Resource<void> {
  const Error([dynamic error]) : super(error: error);
}
