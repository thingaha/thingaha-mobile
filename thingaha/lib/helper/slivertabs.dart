import 'package:flutter/material.dart';
import 'package:thingaha/util/style_constants.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        decoration: BoxDecoration(
          color: kAppBarLightColor,
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.grey[200]),
          ),
        ),
        padding: EdgeInsets.only(left: 16.0),
        child: _tabBar);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
