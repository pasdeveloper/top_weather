import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/locations/locations_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/l10n/localizations_export.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/widgets/add_location_widget.dart';

class Locations extends StatelessWidget {
  const Locations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationsCubit, LocationsState>(
      listener: (context, state) {
        if (state.status == LocationsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              content: Text(
                state.error,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<LocationsCubit>().errorDeliveredToUser();
                    },
                    child: Text(
                        AppLocalizations.of(context)!.locationsErrorConfirm))
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.locations),
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: AddLocationWidget(),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: state.locations.isEmpty
                    ? _emptyList(context)
                    : _locationsList(context, state.locations),
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
        AppLocalizations.of(context)!.emptyLocations,
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.5)),
      ),
    );

Widget _locationsList(BuildContext context, List<Location> locations) =>
    ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        final isSelected =
            context.read<SelectedLocationBloc>().state.selectedLocation?.id ==
                location.id;
        final colorScheme = Theme.of(context).colorScheme;
        return Dismissible(
          key: ValueKey(location.id),
          onDismissed: (_) {
            if (isSelected) {
              context
                  .read<SelectedLocationBloc>()
                  .add(ClearSelectedLocationEvent());
            }
            context.read<LocationsCubit>().removeLocation(location);
          },
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: colorScheme.error,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: colorScheme.onError,
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: colorScheme.error,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: colorScheme.onError,
            ),
          ),
          confirmDismiss: (_) => showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: Text(AppLocalizations.of(context)!.deleteLocationQuestion),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                        AppLocalizations.of(context)!.deleteLocationCancel)),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                        AppLocalizations.of(context)!.deleteLocationConfirm)),
              ],
            ),
          ),
          child: ListTile(
            onTap: () {
              context
                  .read<SelectedLocationBloc>()
                  .add(UpdateSelectedLocationEvent(toSelect: location));
              Navigator.pop(context);
            },
            leading: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                  )
                : null,
            title: Text(location.name),
            subtitle: Text('${location.latitude}, ${location.longitude}'),
          ),
        );
      },
    );
