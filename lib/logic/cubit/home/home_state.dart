class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSharing;
  final bool isSaved;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.isSharing = false,
    this.isSaved = false,
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSharing,
    bool? isSaved,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSharing: isSharing ?? this.isSharing,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  List<Object?> get props => [isLoading, errorMessage, isSharing, isSaved];
}
