part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetAllProfileEvent extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {
  final Map<String, dynamic> profile;
  final int profileId;

  EditProfileEvent({
    required this.profile,
    required this.profileId,
  });
}

class DeleteProfileEvent extends ProfileEvent {
  final int profileId;

  DeleteProfileEvent({required this.profileId});
}
