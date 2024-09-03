sealed class HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {}

class HomePageError extends HomePageState {
  final String message;

  HomePageError(this.message);
}
