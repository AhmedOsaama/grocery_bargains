import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/main.dart';
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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsScreen extends StatefulWidget {
   InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String selectedDuration = "Week";

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  var _pageViewController = PageController();

  int pageNumber = 0;


  String getDurationRange(){
    var dateTime = DateTime.now();
    var currentMonth = DateFormat(DateFormat.ABBR_MONTH).format(dateTime);
    if(selectedDuration == "Week"){
      var lowerLimit = dateTime.subtract(Duration(days: dateTime.weekday - 1)).day;
      var higherLimit = dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday)).day;
      return "$currentMonth $lowerLimit - $currentMonth $higherLimit";
    }else if (selectedDuration == "Month"){
      var lowerLimit = DateTime(dateTime.year, dateTime.month, 1).day;
      var higherLimit = DateTime(dateTime.year, dateTime.month + 1, 0).day;
      return "$currentMonth $lowerLimit - $currentMonth $higherLimit";
    }else if(selectedDuration == "Year"){
      var lowerLimit = DateTime(dateTime.year, 1, 1).day;
      var higherLimit = DateTime(dateTime.year, 12, 31).day;
      return "Jan. $lowerLimit, ${dateTime.year} - Dec. $higherLimit, ${dateTime.year}";
    }
    return "Nan - Nan";
  }
  
  @override
  void initState() {

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    data = [
      _ChartData("Drinks", 83.33),
      // _ChartData("Meat&Seafood", 70.00),
      _ChartData("Dairy", 60.00),
      _ChartData("Bakery", 40.50),
      _ChartData("Snacks", 20.00),
      _ChartData("sauces", 30.00),
      // _ChartData("Personal Care", 40.00),
      // _ChartData("Pet Supplies", 25.00),
      // _ChartData("Baby Products", 10.00),
      _ChartData("pet", 55.00),
    ];
    return Scaffold(
      body: SafeArea(
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
                DurationButton(duration: "Week", selectedDuration: selectedDuration, onPressed: (){
                  setState(() {
                    selectedDuration = "Week";
                  });
                }),
                    15.pw,
                    DurationButton(duration: "Month", selectedDuration: selectedDuration, onPressed: (){
                  setState(() {
                    selectedDuration = "Month";
                  });
                }),
                    15.pw,
                    DurationButton(duration: "Year", selectedDuration: selectedDuration, onPressed: (){
                  setState(() {
                    selectedDuration = "Year";
                  });
                }),
                  ],
                ),
                10.ph,  //first 3 buttons
                Text("October Overview", style: TextStylesInter.textViewSemiBold18,),
                8.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getDurationRange(), style: TextStylesInter.textViewRegular12.copyWith(color: Color(0xFF7C7C7C)),),
                    5.pw,
                    Icon(Icons.calendar_month_outlined, size: 24,)
                  ],
                ),          //duration, calendar
                16.ph,
                OverviewRow(),
                10.ph,
                Container(
                  height: 320.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow:  [
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
                        onPageChanged: (page){
                          setState(() {
                            pageNumber = page;
                          });
                        },
                        physics: BouncingScrollPhysics(),
                        allowImplicitScrolling: true,
                        children: [
                          CircleChart(tooltip: _tooltip, data: data),
                          LineChart(tooltip: _tooltip, data: data),
                        ],
                      ),
                      if(pageNumber < 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: (){
                              // _pageViewController.nextPage(duration: duration, curve: curve)
                              _pageViewController.animateToPage(pageNumber + 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                            }, icon: Icon(Icons.arrow_forward_ios, color: mainPurple, size: 20,)),
                      ),
                      if(pageNumber > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            onPressed: (){
                              _pageViewController.animateToPage(pageNumber - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                            }, icon: Icon(Icons.arrow_back_ios_new_outlined, color: mainPurple, size: 20,)),
                      ),
                    ],
                  ),
                ),
                15.ph,
                Text("Top Insights", style: TextStylesInter.textViewSemiBold14,),
                TopInsightsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopInsightsRow extends StatelessWidget {
  const TopInsightsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          TopInsight(insightType: "Chatlist", image: Image.asset(chatlist, width: 32,height: 32,), insightValue: "Home", insightMetadata: "94 products"),
          10.pw,
          TopInsight(insightType: "Store", image: Image.asset(jumbo, width: 32,height: 32,), insightValue: "Jumbo", insightMetadata: "94 products"),
          10.pw,
          TopInsight(insightType: "Products", image: Image.asset(chatlist,width: 32,height: 32,), insightValue: "Eat Natural Cranberry, Macadamia ...", insightMetadata: "94 products"),
          10.pw,
          TopInsight(insightType: "Person", image: Image.asset(personAva,width: 32,height: 32,), insightValue: "Home", insightMetadata: "94 products"),
        ],
      ),
    );
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required TooltipBehavior tooltip,
    required this.data,
  }) : _tooltip = tooltip;

  final TooltipBehavior _tooltip;
  final List<_ChartData> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
          tooltipBehavior: _tooltip,
          series: [
            LineSeries<_ChartData, String>(
                dataSource: data,
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
    required this.data,
  }) : _tooltip = tooltip;

  final TooltipBehavior _tooltip;
  final List<_ChartData> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCircularChart(
          tooltipBehavior: _tooltip,
          annotations: [
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Total Spent", style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xFFC2D0FA)),),
                  5.ph,
                  Text("€543", style: TextStylesInter.textViewSemiBold20,),
                  5.ph,
                  Text("increase of 24%", style: TextStylesInter.textViewSemiBold12.copyWith(color: Color(0xFF18C336)),)
                ],
              ),
            )
          ],
          series: [
            DoughnutSeries<_ChartData, String>(
                dataSource: data,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  overflowMode: OverflowMode.trim,
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
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: mainPurple)
                            ),
                            child: SvgPicture.asset('assets/icon/category_icons/${data.x.toLowerCase()}.svg', width: 20, height: 20,)),
                        6.ph,
                        Text(data.x, style: TextStylesInter.textViewRegular12,),
                      ],
                    );
                  }
                ),
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
  const OverviewRow({
    super.key,
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
              child: InsightOverview(type: "Total Saved", value: '€234', info: "Increase of 24%", infoColor: Color(0xFF18C336),)),
          10.pw,
         InsightOverview(type: "Biggest Expense", value: '€234', info: "AH Luxury meat BBQ package", infoColor: Color(0xFFFFB81F),)
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
