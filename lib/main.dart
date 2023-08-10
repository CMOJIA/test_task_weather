import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task_weather_service/app/bloc_observer.dart';
import 'package:test_task_weather_service/app/view/app.dart';
import 'package:test_task_weather_service/repositories/authentication_repository/authentication_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp();

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  GetIt.instance.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  initializeDateFormatting('ru_RU', null).then(
    (_) => runApp(App(authenticationRepository: authenticationRepository)),
  );
}
