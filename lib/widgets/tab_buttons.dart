import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/header/header_cubit.dart';

class TabButtons extends StatefulWidget {
  const TabButtons({super.key, required this.tabController});

  final TabController tabController;

  @override
  State<TabButtons> createState() => _TabButtonsState();
}

class _TabButtonsState extends State<TabButtons> {
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.tabController.index;
    widget.tabController.addListener(_setSelectedIndex);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_setSelectedIndex);
    super.dispose();
  }

  void _setSelectedIndex() =>
      setState(() => selectedIndex = widget.tabController.index);

  late int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HeaderCubit, HeaderState>(
      builder: (context, state) {
        final nextDaysCount = context
                .read<ForecastCubit>()
                .state
                .forecast
                .dailyForecast
                ?.days
                .length ??
            0;
        return Container(
          decoration: BoxDecoration(
            color: state.collapsed
                ? colorScheme.primaryContainer
                : Colors.transparent,
            boxShadow: [
              if (state.collapsed)
                BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                    color: colorScheme.shadow.withOpacity(.5)),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              _tabButton(
                  AppLocalizations.of(context)!.todayButton,
                  colorScheme,
                  textTheme,
                  state.collapsed,
                  0,
                  selectedIndex,
                  () => widget.tabController.index = 0),
              const SizedBox(
                width: 8,
              ),
              _tabButton(
                  AppLocalizations.of(context)!.nextDaysButton(nextDaysCount),
                  colorScheme,
                  textTheme,
                  state.collapsed,
                  1,
                  selectedIndex,
                  () => widget.tabController.index = 1),
            ],
          ),
        );
      },
    );
  }
}

Widget _tabButton(String text, ColorScheme colorScheme, TextTheme textTheme,
    bool collapsed, int index, int selectedIndex, void Function() onSelected) {
  bool selected = index == selectedIndex;
  return Expanded(
    child: GestureDetector(
      onTap: onSelected,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? colorScheme.primary
              : collapsed
                  ? colorScheme.surface
                  : colorScheme.secondaryContainer,
        ),
        child: Center(
          child: Text(
            text,
            style: textTheme.titleMedium!.copyWith(
              color: selected
                  ? colorScheme.onPrimary
                  : collapsed
                      ? colorScheme.onSurface
                      : colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    ),
  );
}
