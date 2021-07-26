import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';

Widget tabBar({
  @required BuildContext context,
  List<Tab> tabItems,
  TabController tabController,
  Color backgroundColor,
  EdgeInsets margin,
  EdgeInsets padding,
  Color labelColor,
  Color unselectedLabelColor,
}) {
  return Container(
    color: backgroundColor ?? Colors.transparent,
    margin: margin ?? EdgeInsets.all(0.0),
    padding: padding ?? EdgeInsets.all(0.0),
    child: Stack(
      children: [
        // Bottom border
        Positioned.fill(
          child: Container(
//            margin: margin ?? EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
//              border: Border(
//                bottom: BorderSide(color: AppColors.doveGrey, width: 0.8),
//              ),
            ),
          ),
        ),

        // Tabs
        TabBar(
          labelPadding: EdgeInsets.all(0.0),
          labelColor: labelColor ?? AppColors.lblDark,
          //Selected
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelColor: unselectedLabelColor ?? AppColors.lblGrey,
          tabs: tabItems,
          controller: tabController,
          indicatorColor: AppColors.tabSelected,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ],
    ),
  );
}
