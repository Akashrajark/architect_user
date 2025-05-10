import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'personal_homeplans_event.dart';
part 'personal_homeplans_state.dart';

class PersonalHomeplansBloc extends Bloc<PersonalHomeplansEvent, PersonalHomeplansState> {
  PersonalHomeplansBloc() : super(PersonalHomeplansInitialState()) {
    on<PersonalHomeplansEvent>((event, emit) async {
      try {
        emit(PersonalHomeplansLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table = supabaseClient.from('personal_homeplan');
        SupabaseQueryBuilder floorTable = supabaseClient.from('personal_floor_plan');

        if (event is GetAllPersonalHomeplansEvent) {
          List<Map<String, dynamic>> personalhomeplans =
              await table.select('*,personal_floor_plan(*)').eq('user_id', supabaseClient.auth.currentUser!.id);

          emit(PersonalHomeplansGetSuccessState(personalhomeplans: personalhomeplans));
        } else if (event is AddPersonalHomeplanEvent) {
          Map homeplanDetails = event.personalhomeplanDetails;
          List floors = homeplanDetails['floors'];
          homeplanDetails['user_id'] = supabaseClient.auth.currentUser!.id;
          homeplanDetails.remove('floors');
          if (homeplanDetails['image_file'] != null) {
            homeplanDetails['image'] = await uploadFileUint8List(
              'customer_photo',
              homeplanDetails['image_file'],
            );
            homeplanDetails.remove('image_file');
          }
          Map<String, dynamic> insertedHomeplan =
              await supabaseClient.from('personal_homeplan').insert(homeplanDetails).select('id').single();

          for (var floor in floors) {
            if (floor['image_file'] != null) {
              floor['image'] = await uploadFileUint8List(
                'customer_photo',
                floor['image_file'],
              );
              floor.remove('image_file');
            }
            floor['personal_homeplan_id'] = insertedHomeplan['id'];
            await floorTable.insert(floor);
          }
          emit(PersonalHomeplansSuccessState());
        } else if (event is DeletePersonalHomeplanEvent) {
          await table.delete().eq('id', event.personalhomeplanId);

          emit(PersonalHomeplansSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(PersonalHomeplansFailureState());
      }
    });
  }
}
