import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../values/strings.dart';

part 'homeplans_event.dart';
part 'homeplans_state.dart';

class HomeplansBloc extends Bloc<HomeplansEvent, HomeplansState> {
  HomeplansBloc() : super(HomeplansInitialState()) {
    on<HomeplansEvent>((event, emit) async {
      try {
        emit(HomeplansLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table = supabaseClient.from('home_plans');

        if (event is GetAllHomeplansEvent) {
          List<Map<String, dynamic>> homeplans =
              await supabaseClient.rpc("get_homeplans_with_counts", params: {
            'p_search': event.params['query'],
            'p_user_id': supabaseClient.auth.currentUser!.id,
          });

          emit(HomeplansGetSuccessState(homeplans: homeplans));
        } else if (event is GetAllHomeplanByIdEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table
              .select(
                  '*,floors:floor_plans(*),category:categories(*),architect:architects(*)')
              .eq('id', event.homeplanID);

          Map<String, dynamic> homeplan =
              await query.order('name', ascending: true).single();

          emit(HomeplansGetByIdSuccessState(homeplan: homeplan));
        } else if (event is GetAllCategoriesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              supabaseClient.from('categories').select('*');

          List<Map<String, dynamic>> categories =
              await query.order('name', ascending: true);

          emit(CategoriesGetSuccessState(categories: categories));
        } else if (event is GetHomeplanByFilterEvent) {
          List<Map<String, dynamic>> homeplans =
              await supabaseClient.rpc('get_homeplans_by_filters', params: {
            'p_category_id': event.params['category_id'],
            'p_total_bathrooms': event.params['bathrooms'],
            'p_total_bedrooms': event.params['bedrooms'],
            'p_user_id': supabaseClient.auth.currentUser!.id,
          });

          emit(HomeplansGetSuccessState(homeplans: homeplans));
        } else if (event is GetOwenedHomeplanEvent) {
          List<Map<String, dynamic>> homeplans =
              await supabaseClient.rpc('get_owned_home_plans', params: {
            'p_user_id': supabaseClient.auth.currentUser!.id,
          });

          emit(HomeplansGetSuccessState(homeplans: homeplans));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(HomeplansFailureState());
      }
    });
  }
}
