import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'architects_event.dart';
part 'architects_state.dart';

class ArchitectsBloc extends Bloc<ArchitectsEvent, ArchitectsState> {
  ArchitectsBloc() : super(ArchitectsInitialState()) {
    on<ArchitectsEvent>((event, emit) async {
      try {
        emit(ArchitectsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table =
            Supabase.instance.client.from('architects');

        if (event is GetAllArchitectsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }
          if (event.params['limit'] != null) {
            await query.limit(event.params['limit']);
          }

          List<Map<String, dynamic>> architects =
              await query.order('name', ascending: true);

          emit(ArchitectsGetSuccessState(architects: architects));
        } else if (event is AddArchitectsEvent) {
          await table.insert(event.architectDetails);

          emit(ArchitectsSuccessState());
          // } else if (event is EditArchitectsEvent) {
          //   await table.update(event.architectDetails).eq('id', event.architectId);

          //   emit(ArchitectsSuccessState());
        } else if (event is DeleteArchitectsEvent) {
          await table.delete().eq('id', event.architectId);
          emit(ArchitectsSuccessState());
        }
        if (event is GetAllArchitectHomeplansEvent) {
          List<Map<String, dynamic>> homeplans =
              await supabaseClient.rpc("get_homeplans_with_counts", params: {
            'p_architect_user_id': event.architectId,
            'p_search': event.params['query'],
            'p_user_id': supabaseClient.auth.currentUser!.id,
          });

          emit(ArchitectHomeplansGetSuccessState(homeplans: homeplans));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(ArchitectsFailureState());
      }
    });
  }
}
