import 'package:bargainb/config/routes/app_navigator.dart';
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
    data = [
      _ChartData('Bakery', 25),
      _ChartData('International', 38),
      _ChartData('Pharmacies', 34),
      _ChartData('Others', 52)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
              SizedBox(
                height: 85.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => AppNavigator.push(context: context, screen: TotalSavedScreen()),
                        child: InsightOverview(type: "Total Saved", value: '€234', info: "Increase of 24%", infoColor: Color(0xFF18C336),)),
                    20.pw,
                    VerticalDivider(),
                    20.pw,
                   InsightOverview(type: "Biggest Expense", value: '€234', info: "AH Luxury meat BBQ package", infoColor: Color(0xFFFFB81F),)
                  ],
                ),
              ),             //total saved, biggest expenses
              Divider(),
              Container(
                height: 320.h,
                child: Stack(
                  children: [
                    PageView(
                      scrollDirection: Axis.horizontal,
                      controller: _pageViewController,
                      onPageChanged: (page){
                        setState(() {
                          page = 2;
                        });
                      },
                      physics: BouncingScrollPhysics(),
                      allowImplicitScrolling: true,
                      children: [
                        Container(
                          // padding: EdgeInsets.only(left: 40),
                          child: SfCircularChart(
                              tooltipBehavior: _tooltip,
                              annotations: [
                                CircularChartAnnotation(
                                  widget: InsightOverview(type: "Total Spent", value: "€543", info: "Increase of 24%", infoColor: Colors.green,)
                                )
                              ],
                              series: [
                                DoughnutSeries<_ChartData, String>(
                                    dataSource: data,
                                    dataLabelSettings: DataLabelSettings(isVisible: true,
                                      labelPosition: ChartDataLabelPosition.outside,
                                      overflowMode: OverflowMode.trim,
                                      useSeriesColor: true,
                                      connectorLineSettings: ConnectorLineSettings(
                                        type: ConnectorType.curve,
                                      )
                                    ),
                                    innerRadius: "70",
                                    xValueMapper: (_ChartData data, _) => data.x,
                                    yValueMapper: (_ChartData data, _) => data.y,
                                  dataLabelMapper: (_ChartData data, _) => data.x,
                                )
                              ]),
                        ),
                        Container(
                          // padding: EdgeInsets.only(left: 40),
                          child: SfCircularChart(
                              tooltipBehavior: _tooltip,
                              annotations: [
                                CircularChartAnnotation(
                                  widget: InsightOverview(type: "Total Spent", value: "€543", info: "Increase of 24%", infoColor: Colors.green,)
                                )
                              ],
                              series: [
                                DoughnutSeries<_ChartData, String>(
                                    dataSource: data,
                                    dataLabelSettings: DataLabelSettings(isVisible: true,
                                      labelPosition: ChartDataLabelPosition.outside,
                                      overflowMode: OverflowMode.trim,
                                      useSeriesColor: true,
                                      connectorLineSettings: ConnectorLineSettings(
                                        type: ConnectorType.curve,
                                      )
                                    ),
                                    innerRadius: "70",
                                    xValueMapper: (_ChartData data, _) => data.x,
                                    yValueMapper: (_ChartData data, _) => data.y,
                                  dataLabelMapper: (_ChartData data, _) => data.x,
                                )
                              ]),
                        ),
                      ],
                    ),
                    if(_pageViewController.page! < 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: (){
                            var pageNumber = _pageViewController.page!.toInt();
                            // _pageViewController.nextPage(duration: duration, curve: curve)
                            _pageViewController.animateToPage(pageNumber + 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          }, icon: Icon(Icons.arrow_forward_ios, color: mainPurple, size: 20,)),
                    ),
                    if(_pageViewController.page! > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: (){
                            var pageNumber = _pageViewController.page!.toInt();
                            // _pageViewController.nextPage(duration: duration, curve: curve)
                            _pageViewController.animateToPage(pageNumber - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          }, icon: Icon(Icons.arrow_back_ios_new_outlined, color: mainPurple, size: 20,)),
                    ),
                  ],
                ),
              ),
              Divider(),
              Text("Top Insights", style: TextStylesInter.textViewSemiBold14,),
              20.ph,
              Container(
                height: 110,
                // padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TopInsight(insightType: "Chatlist", image: Image.asset(chatlist, width: 32,height: 32,), insightValue: "Home", insightMetadata: "94 products"),
                    VerticalDivider(endIndent: 10,),
                    TopInsight(insightType: "Store", image: Image.asset(jumbo, width: 32,height: 32,), insightValue: "Jumbo", insightMetadata: "94 products"),
                    VerticalDivider(endIndent: 10,),
                    TopInsight(insightType: "Products", image: Image.asset(chatlist,width: 32,height: 32,), insightValue: "Eat Natural Cranberry, Macadamia ...", insightMetadata: "94 products"),
                    VerticalDivider(endIndent: 10,),
                    TopInsight(insightType: "Person", image: Image.asset(personAva,width: 32,height: 32,), insightValue: "Home", insightMetadata: "94 products"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
