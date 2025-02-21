part of 'architects_bloc.dart';

@immutable
sealed class ArchitectsState {}

final class ArchitectsInitialState extends ArchitectsState {}

final class ArchitectsLoadingState extends ArchitectsState {}

final class ArchitectsSuccessState extends ArchitectsState {}

final class ArchitectsGetSuccessState extends ArchitectsState {
  final List<Map<String, dynamic>> architects;

  ArchitectsGetSuccessState({required this.architects});
}

final class ArchitectsFailureState extends ArchitectsState {
  final String message;

  ArchitectsFailureState({this.message = apiErrorMessage});
}

final class ArchitectHomeplansGetSuccessState extends ArchitectsState {
  final List<Map<String, dynamic>> homeplans;

  ArchitectHomeplansGetSuccessState({required this.homeplans});
}
