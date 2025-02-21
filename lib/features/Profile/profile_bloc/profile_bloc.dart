import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileEvent>((event, emit) async {
      try {
        emit(ProfileLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table = supabaseClient.from('customer');

        if (event is GetAllProfileEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table
              .select('*')
              .eq('user_id', supabaseClient.auth.currentUser!.id);

          Map<String, dynamic> profile = await query.single();

          emit(ProfileGetSuccessState(profile: profile));
        }
        //  else if (event is AddProfileEvent) {
        //   await table.insert(event.interestDetails);

        //   emit(ProfileSuccessState());
        // }
        else if (event is EditProfileEvent) {
          if (event.profile['photo_file'] != null) {
            event.profile['photo'] = await uploadFile(
              'user/photo',
              event.profile['photo_file'],
              event.profile['photo_name'],
            );
            event.profile.remove('photo_file');
            event.profile.remove('photo_name');
          }

          await table.update(event.profile).eq('id', event.profileId);

          emit(ProfileSuccessState());
        } else if (event is DeleteProfileEvent) {
          await table.delete().eq('id', event.profileId);
          emit(ProfileSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(ProfileFailureState());
      }
    });
  }
}
