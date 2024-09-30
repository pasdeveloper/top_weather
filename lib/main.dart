import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/locations/locations_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/bloc/theme/theme_cubit.dart';
import 'package:top_weather/screens/homepage.dart';
import 'package:top_weather/theme/app_themes.dart';
import 'package:top_weather/weather_sources/visual-crossing-weather/repository/visual_crossing_weather_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ForecastCubit(
          VisualCrossingWeatherRepository(),
        ),
      ),
      BlocProvider(
        create: (context) => LocationsCubit(
          VisualCrossingWeatherRepository(),
        ),
      ),
      BlocProvider(
        create: (context) =>
            SelectedLocationBloc()..add(TriggerListenerEvent()),
      ),
      BlocProvider(
        create: (context) => ThemeCubit(),
      ),
    ],
    child: BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Homepage(),
          theme: lighTheme,
          darkTheme: darkTheme,
          themeMode: state.themeMode,
        );
      },
    ),
  ));
}
