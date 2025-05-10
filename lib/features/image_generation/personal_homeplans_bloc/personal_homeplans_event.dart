part of 'personal_homeplans_bloc.dart';

@immutable
sealed class PersonalHomeplansEvent {}

class GetAllPersonalHomeplansEvent extends PersonalHomeplansEvent {
  final Map<String, dynamic> params;

  GetAllPersonalHomeplansEvent({required this.params});
}

class AddPersonalHomeplanEvent extends PersonalHomeplansEvent {
  final Map personalhomeplanDetails;

  AddPersonalHomeplanEvent({required this.personalhomeplanDetails});
}

class EditPersonalHomeplanEvent extends PersonalHomeplansEvent {
  final Map<String, dynamic> personalhomeplanDetails;
  final int personalhomeplanId;

  EditPersonalHomeplanEvent({
    required this.personalhomeplanDetails,
    required this.personalhomeplanId,
  });
}

class DeletePersonalHomeplanEvent extends PersonalHomeplansEvent {
  final int personalhomeplanId;

  DeletePersonalHomeplanEvent({required this.personalhomeplanId});
}
