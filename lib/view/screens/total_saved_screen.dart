import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TotalSavedScreen extends StatelessWidget {
  TotalSavedScreen({Key? key}) : super(key: key);

  final _boxDecoration = const BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color(0x263463ED),
        blurRadius: 28,
        offset: Offset(0, 10),
        spreadRadius: 0,
      )
    ],
  );

  TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData("Week 1", 5),
      ChartData("Week 2", 18),
      ChartData("Week 3", 50),
      ChartData("Week 4", 35),
    ];

    final List<BarChartData> barChartData = [
      // BarChartData(83.2, "Produce"),
      BarChartData("Produce", 83.33),
      BarChartData("Meat", 70.00),
      BarChartData("Dairy", 60.00),
      BarChartData("Bakery", 55.50),
      BarChartData("Snacks", 20.00),
      BarChartData("Household", 30.00),
      BarChartData("Personal Care", 40.00),
      BarChartData("Pet Supplies", 25.00),
      BarChartData("Baby Products", 10.00),
      BarChartData("Other", 5.00),
    ].reversed.toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
        "Total Saved",
        style: TextStylesInter.textViewSemiBold17,
      ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [

              16.ph,
              OverviewRow(),
              TotalSavedChart(boxDecoration: _boxDecoration, tooltip: _tooltip, chartData: chartData),
              16.ph,
              TopProducts(boxDecoration: _boxDecoration),
              16.ph,
              Container(
                decoration: _boxDecoration.copyWith(borderRadius: BorderRadius.circular(16)),
                child: SfCartesianChart(
                  tooltipBehavior: _tooltip,
                  primaryXAxis: CategoryAxis(),
                    series: <ChartSeries<BarChartData, String>>[
                      BarSeries<BarChartData, String>(
                          dataSource: barChartData,
                          xValueMapper: (BarChartData data, _) => data.x,
                          yValueMapper: (BarChartData data, _) => data.y
                      )
                    ]
                ),
              ),
              10.ph
            ],
          ),
        ),
      ),
    );
  }
}

class OverviewRow extends StatelessWidget {
  const OverviewRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "October Overview",
          style: TextStylesInter.textViewSemiBold20,
        ),
        Spacer(),
        Text(
          "Oct 1 - Oct. 31",
          style: TextStylesInter.textViewRegular12.copyWith(color: Color(0xFF7C7C7C)),
        ),
        5.pw,
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.calendar_month_rounded,
              color: mainPurple,
            ))
      ],
    );
  }
}

class TotalSavedChart extends StatelessWidget {
  const TotalSavedChart({
    super.key,
    required BoxDecoration boxDecoration,
    required TooltipBehavior tooltip,
    required this.chartData,
  }) : _boxDecoration = boxDecoration, _tooltip = tooltip;

  final BoxDecoration _boxDecoration;
  final TooltipBehavior _tooltip;
  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: _boxDecoration.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Total Spend",
                style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xFF99B1F6)),
              ),
              30.pw,
              Text(
                "Increase of 24%",
                style: TextStylesInter.textViewMedium12.copyWith(color: Color(0xFF18C336)),
              ),
              Spacer(),
              Text(
                '€234',
                style: TextStylesInter.textViewSemiBold20,
              )
            ],
          ),
          10.ph,
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(title: AxisTitle(text: "Total Euros", textStyle: TextStylesInter.textViewRegular10.copyWith(color: Color(0xFF7C7C7C)),)),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  // name: "Total Euros",
                  yAxisName: "Total Euro",
                  xAxisName: "Total Euros",
                  // isTrackVisible: true,
                  isVisible: true,
                  color: mainPurple,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
              ])
        ],
      ),
    );
  }
}

class ChartData {
  const ChartData(
    this.x,
    this.y,
  );
  final String x;
  final double y;
}

class BarChartData {
  const BarChartData(
    this.x,
    this.y,
  );
  final String x;
  final double y;
}

class TopProducts extends StatelessWidget {
  const TopProducts({
    super.key,
    required BoxDecoration boxDecoration,
  }) : _boxDecoration = boxDecoration;

  final BoxDecoration _boxDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: _boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Products Spent On",
            style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xFF99B1F6)),
          ),
          30.ph,
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 2,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (ctx, i) => Divider(),
            itemBuilder: (ctx, i) => Container(
              width: 167.w,
              child: Row(
                children: [
                  Image.asset(avocado),
                  34.pw,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Avocado",
                        style: TextStylesInter.textViewSemiBold15,
                      ),
                      5.ph,
                      Text(
                        "Chocolate bar 5-pack",
                        style: TextStyles.textViewRegular11,
                      ),
                      10.ph,
                      Row(
                        children: [
                          SizeContainer(itemSize: "1/2 KG"),
                          5.pw,
                          Text(
                            "€1.55",
                            style: TextStylesInter.textViewMedium10.copyWith(decoration: TextDecoration.lineThrough),
                          ),
                          5.pw,
                          Text(
                            "€0.30 less",
                            style: TextStylesInter.textViewMedium10.copyWith(color: Color(0xFF18C336)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Text(
                    "€1.25",
                    style: TextStylesInter.textViewSemiBold14,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
