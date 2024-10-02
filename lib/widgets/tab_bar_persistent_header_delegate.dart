import 'package:flutter/material.dart';
import 'package:top_weather/widgets/tab_buttons.dart';

class TabBarPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  TabBarPersistentHeaderDelegate({
    required this.tabController,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TabButtons(tabController: tabController, collapsePercentage: 0);
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
