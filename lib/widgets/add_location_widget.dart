import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/blocs/weather_location/weather_location_bloc.dart';

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
    return Form(
      key: _form,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Add location',
                hintText: 'Rome, Italy...',
              ),
              textInputAction: TextInputAction.search,
              validator: _locationNameValidator,
              onFieldSubmitted: (_) => _submitLocation(),
              onSaved: (value) => _searchLocation(value!),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton.filled(
            onPressed: _submitLocation,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  String? _locationNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (!_nameRegex.hasMatch(value)) {
      return 'Name is not valid';
    }
    return null;
  }

  void _submitLocation() {
    final valid = _form.currentState!.validate();
    if (!valid) return;

    _form.currentState!.save();
    _form.currentState!.reset();
  }

  void _searchLocation(String name) {
    context
        .read<WeatherLocationBloc>()
        .add(AddWeatherLocationEvent(name: name));
  }
}
