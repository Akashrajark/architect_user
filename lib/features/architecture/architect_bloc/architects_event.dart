part of 'architects_bloc.dart';

@immutable
sealed class ArchitectsEvent {}

class GetAllArchitectsEvent extends ArchitectsEvent {
  final Map<String, dynamic> params;

  GetAllArchitectsEvent({required this.params});
}

class AddArchitectsEvent extends ArchitectsEvent {
  final Map<String, dynamic> architectDetails;

  AddArchitectsEvent({required this.architectDetails});
}

// class EditArchitectsEvent extends ArchitectsEvent {
//   final Map<String, dynamic> architectDetails;
//   final int architectId;

//   EditArchitectsEvent({
//     required this.architectDetails,
//     required this.architectId,
//   });
// }

class DeleteArchitectsEvent extends ArchitectsEvent {
  final int architectId;

  DeleteArchitectsEvent({required this.architectId});
}

class GetAllArchitectHomeplansEvent extends ArchitectsEvent {
  final Map<String, dynamic> params;
  final String architectId;

  GetAllArchitectHomeplansEvent({
    required this.params,
    required this.architectId,
  });
}
