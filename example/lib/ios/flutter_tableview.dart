library flutter_tableview;

import 'package:flutter/material.dart';

typedef int RowCountAtSection(int section);
typedef Widget ListViewFatherWidgetBuilder(
    BuildContext context, Widget canScrollWidget);
typedef Widget SectionHeaderBuilder(BuildContext context, int section);
typedef Widget CellBuilder(BuildContext context, int section, int row);
typedef double CellHeight(BuildContext context, int section, int row);
typedef double SectionHeaderHeight(BuildContext context, int section);

const String ErorrFlagBegin =
    '\n\n\n====================FlutterTableView  Error========================\n\n\n\n';

const String ErorrFlagEnd =
    '\n\n\n\n\n==================================================================\n\n\n\n.';

class FlutterTableView extends StatefulWidget {
  FlutterTableView({
    @required this.sectionCount,
    @required this.rowCountAtSection,
    @required this.sectionHeaderBuilder,
    @required this.cellBuilder,
    @required this.sectionHeaderHeight,
    @required this.cellHeight,
    this.listViewFatherWidgetBuilder,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding = const EdgeInsets.all(0.0),
    this.cacheExtent = 50.0,
    this.backgroundColor = Colors.transparent,
  })  : assert(
          (sectionCount != null && sectionCount > 0),
          '$ErorrFlagBegin sectionCount must > 0 and could not be null. $ErorrFlagEnd',
        ),
        assert(
          (rowCountAtSection != null),
          '$ErorrFlagBegin function rowCountAtSection could not be null. $ErorrFlagEnd',
        ),
        assert(
          (sectionHeaderBuilder != null),
          '$ErorrFlagBegin function sectionHeaderBuilder could not be null. $ErorrFlagEnd',
        ),
        assert(
          (cellBuilder != null),
          '$ErorrFlagBegin function cellBuilder could not be null. $ErorrFlagEnd',
        ),
        assert(
          (sectionHeaderHeight != null),
          '$ErorrFlagBegin function sectionHeaderHeight could not be null. $ErorrFlagEnd',
        ),
        assert(
          (cellHeight != null),
          '$ErorrFlagBegin function cellHeight could not be null. $ErorrFlagEnd',
        );

  @override
  _FlutterTableViewState createState() {
    return _FlutterTableViewState();
  }

  /// How many section.
  final int sectionCount;

  /// How many item in each section.
  final RowCountAtSection rowCountAtSection;

  /// You can through sectionHeaderBuilder create section header widget.
  /// Each section has at most one headWidget.
  /// In a special section, if you don't need section header widget, you can return null.
  final SectionHeaderBuilder sectionHeaderBuilder;

  /// You can through cellBuilder create items.
  final CellBuilder cellBuilder;

  /// return each item widget height.
  final CellHeight cellHeight;

  /// return each section header widget height.
  final SectionHeaderHeight sectionHeaderHeight;

  /// You can wrap a widget for listView
  final ListViewFatherWidgetBuilder listViewFatherWidgetBuilder;

  /// see ScrollView controller
  final ScrollController controller;

  /// see ScrollView physics
  final ScrollPhysics physics;

  /// see ScrollView shrinkWrap
  final bool shrinkWrap;

  final EdgeInsetsGeometry padding;

  /// see ScrollView cacheExtent
  final double cacheExtent;

  final Color backgroundColor;
}

class _FlutterTableViewState extends State<FlutterTableView> {
  ////////////////////////////////////////////////////////////////////
  //                          variables
  ////////////////////////////////////////////////////////////////////
  SectionHeaderModel currentHeaderModel;
  int totalItemCount = 0;
  List<SectionHeaderModel> sectionHeaderList = List();
  List<int> sectionTotalWidgetCountList = List();
  ScrollController scrollController;
  ListView listView;
  bool insideSetStateFlag = false;

  ////////////////////////////////////////////////////////////////////
  //                         init function
  ////////////////////////////////////////////////////////////////////
  void _initBaseData() {
    this.totalItemCount = 0;
    this.sectionHeaderList.clear();
    this.sectionTotalWidgetCountList.clear();

    double offsetY = 0;
    for (int section = 0; section < widget.sectionCount; section++) {
      int rowCount = widget.rowCountAtSection(section);
      Widget sectionHeader = widget.sectionHeaderBuilder(context, section);
      double sectionHeight;
      if (sectionHeader != null) {
        sectionHeight = this.widget.sectionHeaderHeight(context, section);
      } else {
        sectionHeight = 0;
      }

      double sectionHeaderY = offsetY;

      offsetY += sectionHeight;

      int sectionWidgetCount = sectionHeader == null ? rowCount : rowCount + 1;
      sectionTotalWidgetCountList.add(sectionWidgetCount);
      this.totalItemCount += sectionWidgetCount;

      for (int row = 0; row < rowCount; row++) {
        offsetY += this.widget.cellHeight(context, section, row);
      }

      SectionHeaderModel model = SectionHeaderModel(
        y: sectionHeaderY,
        sectionMaxY: offsetY,
        height: sectionHeight,
        section: section,
        headerWidget: sectionHeader,
      );
      sectionHeaderList.add(model);
    }
  }

  void _initScrollController() {
    this.scrollController = this.widget.controller;
    if (this.scrollController == null) {
      this.scrollController = ScrollController();
    }

    this.scrollController.addListener(() {
      double offsetY = this.scrollController.offset;

      if (offsetY <= 0.0) {
        this._updateCurrentSectionHeaderModel(null, 0);
      } else {
        int section = 0;
        for (int i = 0; i < this.sectionHeaderList.length; i++) {
          SectionHeaderModel model = this.sectionHeaderList[i];
          if (offsetY >= model.y && offsetY <= model.sectionMaxY) {
            section = i;
            break;
          }
        }

        SectionHeaderModel model = this.sectionHeaderList[section];
        double delta = model.sectionMaxY - this.scrollController.offset;
        double topOffset;
        if (delta >= model.height) {
          topOffset = 0.0;
        } else {
          topOffset = delta - model.height;
        }
        this._updateCurrentSectionHeaderModel(model, topOffset);
      }
    });
  }

  ////////////////////////////////////////////////////////////////////
  //                       create listView
  ////////////////////////////////////////////////////////////////////
  void _createListView() {
    if(this.insideSetStateFlag == false) {
      this._initBaseData();
    }

    this.insideSetStateFlag = false;

    this.listView = ListView.builder(
      controller: this.scrollController,
      physics: this.widget.physics ?? AlwaysScrollableScrollPhysics(),
      shrinkWrap: this.widget.shrinkWrap,
      cacheExtent: this.widget.cacheExtent,
      itemBuilder: (BuildContext context, int index) {
        Widget itemWidget;
        RowSectionModel model = this._getRowSectionModel(index);
        double height;
        if (model.row == 0 && model.haveHeaderWidget) {
          itemWidget = this.sectionHeaderList[model.section].headerWidget;
          height = this.widget.sectionHeaderHeight(context, model.section);
        } else {
          int row = model.haveHeaderWidget == false ? model.row : model.row - 1;
          itemWidget = this.widget.cellBuilder(context, model.section, row);
          height = this.widget.cellHeight(context, model.section, row);
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height,
            maxHeight: height,
          ),
          child: itemWidget,
        );
      },
      itemCount: this.totalItemCount,
    );
  }

  ////////////////////////////////////////////////////////////////////
  //                      tool function
  ////////////////////////////////////////////////////////////////////
  RowSectionModel _getRowSectionModel(int index) {
    int passCount = 0;
    for (int section = 0;
        section < this.sectionTotalWidgetCountList.length;
        section++) {
      int currentSectionWidgetCount = this.sectionTotalWidgetCountList[section];
      if (index >= passCount && index < passCount + currentSectionWidgetCount) {
        int row = index - passCount;
        bool haveSectionHeaderWidget =
            this.sectionHeaderList[section].headerWidget != null;
        RowSectionModel model = RowSectionModel(
          section: section,
          row: row,
          haveHeaderWidget: haveSectionHeaderWidget,
        );

        return model;
      }

      passCount += currentSectionWidgetCount;
    }
    return null;
  }

  void _updateCurrentSectionHeaderModel(
      SectionHeaderModel model, double topOffset) {
    bool needSetState = false;
    if (model == null) {
      if (this.currentHeaderModel != null) {
        this.currentHeaderModel = null;
        needSetState = true;
      }
    } else if (this.currentHeaderModel == null) {
      this.currentHeaderModel = model;
      this.currentHeaderModel.topOffset = topOffset;
      needSetState = true;
    } else {
      if (model != this.currentHeaderModel) {
        this.currentHeaderModel = model;

        needSetState = true;
      } else if (model.topOffset != topOffset) {
        needSetState = true;
      }

      this.currentHeaderModel.topOffset = topOffset;
    }

    if (needSetState == true) {
      this.insideSetStateFlag = true;
      setState(() {});
    }
  }

  ////////////////////////////////////////////////////////////////////
  //                          life cycle
  ////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (this.widget.controller == null) {
      this.scrollController.dispose();
    }
  }

  @override
  void initState() {
    this._initScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._createListView();
    Widget listViewFatherWidget;
    if (this.widget.listViewFatherWidgetBuilder != null) {
      listViewFatherWidget =
          this.widget.listViewFatherWidgetBuilder(context, this.listView);
    }

    Widget listViewWidget = listViewFatherWidget ?? this.listView;

    if (this.currentHeaderModel != null &&
        this.currentHeaderModel.headerWidget != null) {
      return Container(
        padding: this.widget.padding,
        color: widget.backgroundColor,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: listViewWidget,
            ),
            Positioned(
              top: this.currentHeaderModel.topOffset,
              left: 0.0,
              right: 0.0,
              height: this.currentHeaderModel.height,
              child: Container(
                color: Colors.white,
                child: this.currentHeaderModel.headerWidget,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: this.widget.padding,
      color: this.widget.backgroundColor,
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: listViewWidget,
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////
//                          model class
////////////////////////////////////////////////////////////////////

class RowSectionModel {
  RowSectionModel({
    @required this.section,
    @required this.row,
    @required this.haveHeaderWidget,
  });

  final int section;
  final int row;
  final bool haveHeaderWidget;
}

class SectionHeaderModel {
  SectionHeaderModel({
    this.y,
    this.sectionMaxY,
    this.height,
    this.section,
    this.headerWidget,
  });

  final double y;
  final double sectionMaxY;
  final double height;
  final int section;
  final Widget headerWidget;

  double topOffset;
}
