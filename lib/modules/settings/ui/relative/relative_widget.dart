import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/settings/relative_list_response.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/settings/bloc/relative_list_bloc.dart';
import 'package:netware/modules/settings/ui/relative/relative_detail_route.dart';

import 'add_relative_route.dart';

class RelativeWidget extends StatefulWidget {
  const RelativeWidget({
    Key key,
    this.scaffoldKey,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final GlobalKey scaffoldKey;
  final EdgeInsets margin;

  @override
  _RelativeWidgetState createState() => _RelativeWidgetState();
}

class _RelativeWidgetState extends State<RelativeWidget> {
  // UI
  final _cardHeight = 300.0;

  // Data
  var _relativeList = <Relative>[];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RelativeBloc>(context)..add(GetRelativeList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RelativeBloc, RelativeState>(
      listener: _blocListener,
      child: BlocBuilder<RelativeBloc, RelativeState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, RelativeState state) {
    if (state is GetRelativeListSuccess) {
      _relativeList = state.relativeList;
    } else if (state is RelativeListNotFound) {
      _relativeList = [];
    } else if (state is ShowSnackBar) {
      showSnackBar(key: widget.scaffoldKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, RelativeState state) {
    return LoadingContainer(
      loading: state is RelativeLoading,
      height: _cardHeight,
      child: CustomCard(
          margin: widget.margin,
          child: true
              ? Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(0.0),
                      padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0, left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /// Холбоотой хүмүүс
                          lbl(globals.text.relative(), style: lblStyle.Medium, fontWeight: FontWeight.w500),

                          /// Add account button
                          ButtonIcon(
                            onPressed: () {
                              Navigator.push(context, FadeRouteBuilder(route: AddRelativeRoute()));
                            },
                            icon: Icon(Icons.add, color: AppColors.iconBlue),
                            padding: EdgeInsets.only(left: 20.0),
                          ),
                        ],
                      ),
                    ),
                    for (var el in _relativeList) _listItem(el, showTopBorder: true),
                  ],
                )
              : Container(height: _cardHeight)),
    );
  }

  Widget _listItem(Relative relative, {bool showTopBorder = false}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, FadeRouteBuilder(route: RelativeDetailRoute(relative: relative)));
      },
      child: Container(
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.only(top: 15.0, right: 10.0, bottom: 15.0, left: 10.0),
        decoration: showTopBorder ? BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: AppColors.bgGrey))) : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MoveIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Account number
                  lbl(Func.toStr(relative.firstName), fontSize: 16.0, color: AppColors.lblDark),

                  /// Account name
                  lbl(Func.toStr(relative.relName), style: lblStyle.Caption, color: AppColors.lblGrey),
                ],
              ),
            ),

            /// Text

            /// Icon
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
//                child: Icon(Icons.arrow_forward_ios, color: AppColors.iconMirage),
                child: Image.asset(
                  AssetName.forward_arrow,
                  color: AppColors.iconMirage,
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
