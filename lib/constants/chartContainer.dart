import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';


class ChartContainer extends StatefulWidget {
  const ChartContainer({
    Key? key,
    required this.chartColor,
    this.penddingAmount,
    required this.title,
    required this.value,
    required this.discount,
    required this.chartValue,
    required this.discountTitle,
    required this.onTap,
  }) : super(key: key);

  final Color chartColor;
  final String title;
  final String value;
  final String discountTitle;
  final String discount;
  final String? penddingAmount;
  final String chartValue;
  final VoidCallback onTap;
  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: height * 0.15,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 3,
                spreadRadius: 2,
                offset: const Offset(2, 2),
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title.semiBoldReadex(
                    fontColor: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  (height * 0.005).addHSpace(),
                  widget.value.semiBoldReadex(
                    fontColor: Colors.black,
                    fontSize: 18,
                  ),

                  Row(
                    children: [
                      widget.discountTitle.semiBoldReadex(
                        fontColor: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                      widget.discount.semiBoldReadex(
                        fontColor: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 65,
                width: 65,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(sections: [
                        PieChartSectionData(
                          title: "",
                          radius: 10,
                          value: 5,
                          color: Colors.grey,
                        ),
                        PieChartSectionData(
                          title: "",
                          radius: 12,
                          value: 18,
                          color: widget.chartColor,
                        ),
                      ]),
                    ),
                    Center(
                      child: widget.chartValue.semiBoldReadex(
                        fontColor: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: width * 0.014),
        ),
      ),
    );
  }
}
