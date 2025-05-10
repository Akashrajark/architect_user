part of 'personal_homeplans_bloc.dart';

@immutable
sealed class PersonalHomeplansState {}

final class PersonalHomeplansInitialState extends PersonalHomeplansState {}

final class PersonalHomeplansLoadingState extends PersonalHomeplansState {}

final class PersonalHomeplansSuccessState extends PersonalHomeplansState {}

final class PersonalHomeplansGetSuccessState extends PersonalHomeplansState {
  final List<Map<String, dynamic>> personalhomeplans;

  PersonalHomeplansGetSuccessState({required this.personalhomeplans});
}

final class PersonalHomeplansGetByIdSuccessState extends PersonalHomeplansState {
  final Map<String, dynamic> personalhomeplan;

  PersonalHomeplansGetByIdSuccessState({required this.personalhomeplan});
}

final class PersonalHomeplansFailureState extends PersonalHomeplansState {
  final String message;

  PersonalHomeplansFailureState({this.message = apiErrorMessage});
}

final class CategoriesGetSuccessState extends PersonalHomeplansState {
  final List<Map<String, dynamic>> categories;

  CategoriesGetSuccessState({required this.categories});
}
