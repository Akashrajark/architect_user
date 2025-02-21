part of 'homeplans_bloc.dart';

@immutable
sealed class HomeplansState {}

final class HomeplansInitialState extends HomeplansState {}

final class HomeplansLoadingState extends HomeplansState {}

final class HomeplansSuccessState extends HomeplansState {}

final class AddHomeplanSuccessState extends HomeplansState {
  final int homeplanID;

  AddHomeplanSuccessState({required this.homeplanID});
}

final class HomeplansGetSuccessState extends HomeplansState {
  final List<Map<String, dynamic>> homeplans;

  HomeplansGetSuccessState({required this.homeplans});
}

final class HomeplansGetByIdSuccessState extends HomeplansState {
  final Map<String, dynamic> homeplan;

  HomeplansGetByIdSuccessState({required this.homeplan});
}

final class HomeplansFailureState extends HomeplansState {
  final String message;

  HomeplansFailureState({this.message = apiErrorMessage});
}

final class CategoriesGetSuccessState extends HomeplansState {
  final List<Map<String, dynamic>> categories;

  CategoriesGetSuccessState({required this.categories});
}
