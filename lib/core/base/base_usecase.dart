abstract class BaseUseCase<T, Params> {
  const BaseUseCase();
  T call(Params params);
}
