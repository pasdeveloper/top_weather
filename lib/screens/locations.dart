import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/blocs/weather_location/weather_location_bloc.dart';
import 'package:top_weather/widgets/add_location_widget.dart';

class Locations extends StatelessWidget {
  const Locations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherLocationBloc, WeatherLocationState>(
      listener: (context, state) {
        if (state.status == WeatherLocationStatus.error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              content: Text(state.error),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'))
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Locations'),
            bottom: state.status == WeatherLocationStatus.loading
                ? const PreferredSize(
                    preferredSize: Size(double.infinity, 4),
                    child: LinearProgressIndicator())
                : null,
          ),
          body: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.all(12), child: AddLocationWidget()),
              Expanded(
                child: state.locations.isEmpty
                    ? _emptyList(context)
                    : ListView.builder(
                        itemCount: state.locations.length,
                        padding: const EdgeInsets.all(12),
                        itemBuilder: (context, index) {
                          final location = state.locations[index];
                          return ListTile(
                            onTap: () {},
                            title: Text(location.name),
                            subtitle: Text(
                                '${location.latitude}, ${location.longitude}'),
                            trailing: IconButton(
                                onPressed: () => context
                                    .read<WeatherLocationBloc>()
                                    .add(RemoveWeatherLocationEvent(
                                        id: location.id)),
                                icon: const Icon(Icons.delete)),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _emptyList(BuildContext context) => Center(
      child: Text(
        'No location yet, add a new one',
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.5)),
      ),
    );
