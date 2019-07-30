import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhole/bloc/api/queries_over_time.dart';
import 'package:flutterhole/bloc/base/bloc.dart';
import 'package:flutterhole/model/api/queries_over_time.dart';
import 'package:flutterhole/widget/home/chart/my_line_chart.dart';
import 'package:flutterhole/widget/layout/error_message.dart';

class QueriesOverTimeChartBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QueriesOverTimeBloc queriesOverTimeBloc =
        BlocProvider.of<QueriesOverTimeBloc>(context);
    return BlocBuilder(
      bloc: queriesOverTimeBloc,
      builder: (context, state) {
        if (state is BlocStateSuccess<QueriesOverTime>) {
          final queriesOverTime = state.data;

          List<FlSpot> domainSpots = [];
          List<FlSpot> adSpots = [];
          double maxY = 0;

          int index = 0;
          queriesOverTime.domainsOverTime.forEach((String str, int hits) {
            if (hits.toDouble() > maxY) maxY = hits.toDouble();

            domainSpots.add(FlSpot(
                index.toDouble() *
                    (2400 / queriesOverTime.domainsOverTime.length),
                hits.toDouble()));
            index++;
          });

          index = 0;
          queriesOverTime.adsOverTime.forEach((String str, int hits) {
            if (hits.toDouble() > maxY) maxY = hits.toDouble();

            adSpots.add(FlSpot(
                index.toDouble() * (2400 / queriesOverTime.adsOverTime.length),
                hits.toDouble()));
            index++;
          });

          return MyLineChart(
//            greenSpots: domainSpots,
            greenSpots: domainSpots..removeLast(),
//            redSpots: adSpots,
            redSpots: adSpots..removeLast(),
            maxY: maxY,
          );
        }
        if (state is BlocStateError<QueriesOverTime>) {
          return ErrorMessage(errorMessage: state.e.message);
        }
        return Center(
            child: Column(children: <Widget>[
          CircularProgressIndicator(),
          Text(state.toString()),
          Text(state.runtimeType.toString()),
        ]));
      },
    );
  }
}