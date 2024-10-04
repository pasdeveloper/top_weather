import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/locations/locations_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/l10n/localizations_export.dart';

class AddLocationWidget extends StatefulWidget {
  const AddLocationWidget({super.key});

  @override
  State<AddLocationWidget> createState() => _AddLocationWidgetState();
}

class _AddLocationWidgetState extends State<AddLocationWidget> {
  final _nameRegex = RegExp('[a-zA-Z, ]+');
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final searchLoading =
        context.watch<LocationsCubit>().state.status == LocationsStatus.loading;
    final colorScheme = Theme.of(context).colorScheme;
    return Form(
      key: _form,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 1,
                          color: colorScheme.onSurface.withOpacity(.5),
                        ),
                      ),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: searchLoading
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            width: 48,
                            height: 48,
                            child: const CircularProgressIndicator.adaptive(),
                          )
                        : IconButton(
                            onPressed: _submitLocation,
                            icon: const Icon(Icons.add_location_alt),
                          ),
                  ),
                  hintText: AppLocalizations.of(context)!.addLocationHint,
                  hintStyle:
                      TextStyle(color: colorScheme.onSurface.withOpacity(.5))),
              textInputAction: TextInputAction.search,
              validator: _locationNameValidator,
              onFieldSubmitted: (_) => _submitLocation(),
              onSaved: (value) => _searchLocation(value!),
            ),
          ),
        ],
      ),
    );
  }

  String? _locationNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.addLocationErrorEmptyName;
    }
    if (!_nameRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.addLocationErrorInvalid;
    }
    return null;
  }

  void _submitLocation() {
    final valid = _form.currentState!.validate();
    if (!valid) return;

    _form.currentState!.save();
    _form.currentState!.reset();
  }

  void _searchLocation(String locationName) {
    context
        .read<LocationsCubit>()
        .searchAndAddLocation(locationName)
        .then((newLocation) {
      if (newLocation != null && mounted) {
        context
            .read<SelectedLocationBloc>()
            .add(UpdateSelectedLocationEvent(toSelect: newLocation));
        Navigator.pop(context);
      }
    });
  }
}
