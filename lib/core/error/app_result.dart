sealed class AppResult<T> {
  const AppResult();
}

final class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.data);

  final T data;
}

final class AppError<T> extends AppResult<T> {
  const AppError(this.message);

  final String message;
}
