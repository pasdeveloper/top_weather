import 'package:flutter/material.dart';

class TabButtons extends StatefulWidget {
  const TabButtons(
      {super.key,
      required this.tabController,
      required this.collapsePercentage});

  final TabController tabController;
  final double collapsePercentage;

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
    return Container(
      decoration: BoxDecoration(
        color: ColorTween(
                begin: Colors.transparent, end: colorScheme.primaryContainer)
            .transform(widget.collapsePercentage),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(widget.collapsePercentage),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
          children: ['Today', 'Next Days']
              .indexed
              .map((element) => _tabButton(
                    element.$2,
                    colorScheme,
                    textTheme,
                    widget.collapsePercentage,
                    selectedIndex == element.$1,
                    () {
                      widget.tabController.index = element.$1;
                    },
                  ))
              .toList()),
    );
  }
}

Widget _tabButton(String text, ColorScheme colorScheme, TextTheme textTheme,
        double collapsePercentage, bool selected, void Function() onSelected) =>
    Expanded(
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: selected
                  ? colorScheme.primary
                  : ColorTween(
                          begin: colorScheme.secondaryContainer,
                          end: colorScheme.surface)
                      .transform(collapsePercentage),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Text(
              text,
              style: textTheme.titleMedium!.copyWith(
                color: selected
                    ? colorScheme.onPrimary
                    : ColorTween(
                            begin: colorScheme.onSecondaryContainer,
                            end: colorScheme.onSurface)
                        .transform(collapsePercentage),
              ),
            ),
          ),
        ),
      ),
    );
