import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/main.dart';
import 'package:bargainb/models/insight.dart';
import 'package:bargainb/providers/insights_provider.dart';
import 'package:bargainb/services/insights_service.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/media_query_values.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/screens/total_saved_screen.dart';
import 'package:bargainb/view/widgets/duration_button.dart';
import 'package:bargainb/view/widgets/insight_overview.dart';
import 'package:bargainb/view/widgets/top_insight.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/top_insight.dart';

class InsightsScreen extends StatefulWidget {
  InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String selectedDuration = "Week";

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late Future<Insight> getInsightsFuture;
  late Future<TopInsight> getTopInsightFuture;

  var _pageViewController = PageController();

  var _firstDay = DateTime.now();
  var _lastDay = DateTime.now();
  var dateTime = DateTime.now();

  int pageNumber = 0;

  String getDateRange() {
    var currentMonth = DateFormat(DateFormat.ABBR_MONTH).format(dateTime);
    var lowerLimit = _firstDay.day;
    var higherLimit = _lastDay.day;
    if (selectedDuration == "Week") {
      return "$currentMonth $lowerLimit - $currentMonth $higherLimit";
    } else if (selectedDuration == "Month") {
      return "$currentMonth $lowerLimit - $currentMonth $higherLimit";
    } else if (selectedDuration == "Year") {
      return "Jan. $lowerLimit, ${dateTime.year} - Dec. $higherLimit, ${dateTime.year}";
    }
    return "Nan - Nan";
  }

  void changeTimeRange({DateTimeRange? customDate}){
    if(customDate != null){
      _firstDay = customDate.start;
      _lastDay = customDate.end;
      return;
    }
    if (selectedDuration == "Week") {
      _firstDay = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      _lastDay = dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    } else if (selectedDuration == "Month") {
      _firstDay = DateTime(dateTime.year, dateTime.month, 1);
      _lastDay = DateTime(dateTime.year, dateTime.month + 1, 0);
    } else if (selectedDuration == "Year") {
      _firstDay = DateTime(dateTime.year, 1, 1);
      _lastDay = DateTime(dateTime.year, 12, 31);
    }
  }

  @override
  void initState() {
    changeTimeRange();
    getInsightsFuture = Provider.of<InsightsProvider>(context, listen: false).getBasicInsights(
        FirebaseAuth.instance.currentUser!.uid, _firstDay, _lastDay, selectedDuration);
    getTopInsightFuture = Provider.of<InsightsProvider>(context, listen: false).getTopInsights();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var insightsProvider = context.watch<InsightsProvider>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: (){
          changeDurationType(insightsProvider, "Week");
          return Future.value();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DurationButton(
                          duration: "Week",
                          selectedDuration: selectedDuration,
                          onPressed: () {
                            changeDurationType(insightsProvider, "Week");
                          }),
                      15.pw,
                      DurationButton(
                          duration: "Month",
                          selectedDuration: selectedDuration,
                          onPressed: () {
                            changeDurationType(insightsProvider, "Month");
                          }),
                      15.pw,
                      DurationButton(
                          duration: "Year",
                          selectedDuration: selectedDuration,
                          onPressed: () {
                            changeDurationType(insightsProvider, "Year");
                          }),
                    ],
                  ),
                  10.ph, //first 3 buttons
                  Text(
                    "October Overview",
                    style: TextStylesInter.textViewSemiBold18,
                  ),
                  8.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getDateRange(),
                        style: TextStylesInter.textViewRegular12.copyWith(color: Color(0xFF7C7C7C)),
                      ),
                      5.pw,
                      IconButton(
                          onPressed: () => showDateRangePicker(
                              context: context,
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDateRange: DateTimeRange(start: dateTime, end: dateTime),
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now())
                              .then((value) {
                                setState(() {
                                  print("Calendar datetime: $value");
                               changeTimeRange(customDate: value);
                               updateInsightFuture(insightsProvider, selectedDuration);
                                });
                                return ;
                              }),
                          icon: Icon(
                            Icons.calendar_month_rounded,
                            color: mainPurple,
                          ))
                    ],
                  ),
                  16.ph,
                  FutureBuilder(
                      future: getInsightsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return OverviewRowShimmer(height: 105,);
                        if (snapshot.hasError)
                          return Center(
                            child: Text("Something went wrong please try again"),
                          );
                        var insights = snapshot.data;
                        return OverviewRow(
                          insight: insights!,
                        );
                      }),
                  10.ph,
                  FutureBuilder(
                      future: getInsightsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return OverviewRowShimmer(height: 320,);
                        if (snapshot.hasError)
                          return Center(
                            child: Text("Something went wrong please try again"),
                          );
                        var insights = snapshot.data;
                        data = insights!.categorySum!.entries.map((e) => _ChartData(e.key, (e.value['totalSpent']).toDouble())).toList();
                        return Container(
                          height: 320.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x263463ED),
                                blurRadius: 28,
                                offset: Offset(0, 10),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              PageView(
                                scrollDirection: Axis.horizontal,
                                controller: _pageViewController,
                                onPageChanged: onPageChanged,
                                physics: BouncingScrollPhysics(),
                                allowImplicitScrolling: true,
                                children: [
                                  CircleChart(tooltip: _tooltip, insight: insights, chartData: data),
                                  LineChart(tooltip: _tooltip, insight: insights, chartData: data),
                                ],
                              ),
                              if (pageNumber < 1)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () {
                                        // _pageViewController.nextPage(duration: duration, curve: curve)
                                        _pageViewController.animateToPage(pageNumber + 1,
                                            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: mainPurple,
                                        size: 20,
                                      )),
                                ),
                              if (pageNumber > 0)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                      onPressed: () {
                                        _pageViewController.animateToPage(pageNumber - 1,
                                            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_outlined,
                                        color: mainPurple,
                                        size: 20,
                                      )),
                                ),
                            ],
                          ),
                        );
                      }),
                  15.ph,
                  Text(
                    "Top Insights",
                    style: TextStylesInter.textViewSemiBold14,
                  ),
                  FutureBuilder<TopInsight>(
                    future: getTopInsightFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return OverviewRowShimmer(height: 150,);
                      if (snapshot.hasError)
                        return Center(
                          child: Text("Something went wrong please try again"),
                        );
                      var topInsights = snapshot.data;
                      return TopInsightsRow(topInsight: topInsights!,);
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeDurationType(InsightsProvider insightsProvider, String mode) {
    setState(() {
      selectedDuration = mode;
      changeTimeRange();
      updateInsightFuture(insightsProvider, mode);
    });
  }

  void updateInsightFuture(InsightsProvider insightsProvider, String mode) {
     getInsightsFuture = insightsProvider.getBasicInsights(
        FirebaseAuth.instance.currentUser!.uid, _firstDay, _lastDay, mode.toLowerCase());
  }

  void onPageChanged(page) {
            setState(() {
              pageNumber = page;
            });
          }
}

class OverviewRowShimmer extends StatelessWidget {
  final double height;
  const OverviewRowShimmer({
    super.key, required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 2),
      colorOpacity: 0.7,
      child: Container(
        height: height.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: purple10,
        ),
      ),
    );
  }
}


class TopInsightsRow extends StatelessWidget {
  final TopInsight topInsight;
  const TopInsightsRow({
    super.key, required this.topInsight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          TopInsightWidget(
              insightType: "Chatlist",
              image: Image.asset(
                chatlist,
                width: 32,
                height: 32,
              ),
              insightValue: "${topInsight.chatList!.listName}",
              insightMetadata: "${topInsight.chatList!.size}"),
          10.pw,
          TopInsightWidget(
              insightType: "Store",
              image: Image.asset(
                jumbo,
                width: 32,
                height: 32,
              ),
              insightValue: "${topInsight.mostStore!.storeName}",
              insightMetadata: "${topInsight.mostStore!.productNums}"),
          10.pw,
          TopInsightWidget(
              insightType: "Products",
              image: Image.asset(
                chatlist,
                width: 32,
                height: 32,
              ),
              insightValue: "${topInsight.mostProduct!.productName}",
              insightMetadata: "${topInsight.mostProduct!.nums}"),
          10.pw,
          TopInsightWidget(
              insightType: "Person",
              image: Image.asset(
                personAva,
                width: 32,
                height: 32,
              ),
              insightValue: "${topInsight.mostUser!.userName}",
              insightMetadata: "${topInsight.mostUser!.nums}"),
        ],
      ),
    );
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required TooltipBehavior tooltip,
    required this.insight,
    required this.chartData,
  }) : _tooltip = tooltip;

  final TooltipBehavior _tooltip;
  final Insight insight;
  final List<_ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: _tooltip, series: [
        LineSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
        )
      ]),
    );
  }
}

class CircleChart extends StatelessWidget {
  const CircleChart({
    super.key,
    required TooltipBehavior tooltip,
    required this.insight,
    required this.chartData,
  }) : _tooltip = tooltip;

  final TooltipBehavior _tooltip;
  final Insight insight;
  final List<_ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCircularChart(tooltipBehavior: _tooltip, annotations: [
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Total Spent",
                style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xFFC2D0FA)),
              ),
              5.ph,
              Text(
                "€${insight.totalSpent!.toStringAsFixed(2)}",
                style: TextStylesInter.textViewSemiBold20,
              ),
              5.ph,
              Text(
                "increase of ${insight.totalSavedIncrease}%",
                style: TextStylesInter.textViewSemiBold12.copyWith(color: Color(0xFF18C336)),
              )
            ],
          ),
        )
      ], series: [
        DoughnutSeries<_ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true,
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.line,
              ),
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                // print("$data, $point, $series, $pointIndex, $seriesIndex");
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainPurple)),
                        child: SvgPicture.asset(
                          'assets/icon/category_icons/${getCategoryIcon(data.x.toLowerCase())}.svg',
                          width: 20,
                          height: 20,
                        )),
                    6.ph,
                    Text(
                      data.x,
                      style: TextStylesInter.textViewRegular12,
                    ),
                  ],
                );
              }),
          innerRadius: "65",
          radius: "90",
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          dataLabelMapper: (_ChartData data, _) => data.x,
        )
      ]),
    );
  }

}

class OverviewRow extends StatelessWidget {
  final Insight insight;
  const OverviewRow({
    super.key,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => AppNavigator.push(context: context, screen: TotalSavedScreen()),
              child: InsightOverview(
                type: "Total Saved",
                value: '€${insight.totalSaved!.toStringAsFixed(2)}',
                info: "Increase of ${insight.totalSavedIncrease}%",
                infoColor: Color(0xFF18C336),
              )),
          10.pw,
          InsightOverview(
            type: "Biggest Expense",
            value: '€${insight.mostExpensiveProduct?.price}',
            info: insight.mostExpensiveProduct?.productName ?? 'N/A',
            infoColor: Color(0xFFFFB81F),
          )
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

String getCategoryIcon(String category) {
  Map categoryMap = {
    'drink': 'drinks',
    'fruit': 'vegetable&fruit',
    'meat': 'meat&seafood',
  };
  // return categoryMap[category];
  return 'drinks';
}

