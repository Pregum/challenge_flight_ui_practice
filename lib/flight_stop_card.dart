import 'package:flutter/material.dart';

import 'flight_stop.dart';

class FlightStopCard extends StatefulWidget {
  final FlightStop flightStop;
  final bool isLeft;
  static const double height = 80.0;
  static const double width = 140.0;

  const FlightStopCard(
      {Key key, @required this.flightStop, @required this.isLeft})
      : super(key: key);

  @override
  FlightStopCardState createState() => FlightStopCardState();
}

class FlightStopCardState extends State<FlightStopCard>
    with TickerProviderStateMixin {

  double get maxWidth {
    RenderBox renderBox = context.findRenderObject();
    BoxConstraints constraints = renderBox?.constraints;
    double maxWidth = constraints?.maxWidth ?? 0.0;
    return maxWidth;
  }

  AnimationController _animationController;
  Animation<double> _cardSizeAnimation;
  Animation<double> _durationPositionAnimation;
  Animation<double> _airportsPositionAnimation;
  Animation<double> _datePositionAnimation;
  Animation<double> _pricePositionAnimation;
  Animation<double> _fromToPositionAnimation;
  Animation<double> _lineAnimation;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void runAnimation() {
    _animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _cardSizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.9, curve: ElasticOutCurve(0.8)),
    );
    _durationPositionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.05, 0.95, curve: ElasticOutCurve(0.95)),
    );
    _airportsPositionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.1, 1.0, curve: ElasticOutCurve(0.95)),
    );
    _datePositionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.1, 0.8, curve: ElasticOutCurve(0.95)),
    );
    _pricePositionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.9, curve: ElasticOutCurve(0.95)),
    );
    _fromToPositionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.1, 0.95, curve: ElasticOutCurve(0.95)),
    );
    _lineAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.2, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FlightStopCard.height,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget widget) => Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            buildLine(),
            buildCard(),
            buildDurationText(),
            buildAirportNamesText(),
            buildDateText(),
            buildPriceText(),
            buildFormToTimeText(),
          ],
        ),
      ),
    );
  }

  Positioned buildDurationText() {
    double animationValue = _durationPositionAnimation.value;
    return Positioned(
      // top: getMarginTop,
      top: getMarginTop(animationValue),
      // right: getMarginRight,
      right: getMarginRight(animationValue),
      child: Text(
        widget.flightStop.duration,
        style: TextStyle(
          // fontSize: 10.0,
          fontSize: 14.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned buildAirportNamesText() {
    double animationValue = _airportsPositionAnimation.value;
    return Positioned(
      // top: getMarginTop,
      top: getMarginTop(animationValue),
      // right: getMarginRight,
      // right: getMarginRight(animationValue),
      left: getMarginLeft(animationValue),
      child: Text(
        '${widget.flightStop.from} \u00B7 ${widget.flightStop.to}',
        style: TextStyle(
          // fontSize: 14.0,
          fontSize: 14.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned buildDateText() {
    double animationValue = _datePositionAnimation.value;
    return Positioned(
      // left: getMarginLeft,
      left: getMarginLeft(animationValue),
      child: Text(
        '${widget.flightStop.date}',
        style: TextStyle(
          // fontSize: 14.0,
          fontSize: 14.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned buildPriceText() {
    double animationValue = _pricePositionAnimation.value;
    return Positioned(
      // right: getMarginRight,
      right: getMarginRight(animationValue),
      child: Text(
        '${widget.flightStop.price}',
        style: TextStyle(
          // fontSize: 16.0,
          fontSize: 16.0 * animationValue,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Positioned buildFormToTimeText() {
    double animationValue = _fromToPositionAnimation.value;
    return Positioned(
      // left: getMarginLeft,
      left: getMarginLeft(animationValue),
      bottom: getMarginBottom(animationValue),
      child: Text(
        '${widget.flightStop.fromToTime}',
        style: TextStyle(
          // fontSize: 12.0,
          fontSize: 12.0 * animationValue,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildLine() {
    double animationValue = _lineAnimation.value;
    double maxLength = maxWidth - FlightStopCard.width;
    return Align(
      alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        height: 2.0,
        // width: maxLength,
        width: maxLength * animationValue,
        color: Color.fromARGB(255, 200, 200, 200),
      ),
    );
  }

  Positioned buildCard() {
    double animationValue = _cardSizeAnimation.value;
    double minOuterMargin = 8.0;
    double outerMargin = minOuterMargin + (1 - animationValue) * maxWidth;
    return Positioned(
      right: widget.isLeft ? null : outerMargin,
      left: widget.isLeft ? outerMargin : null,
      child: Transform.scale(
        scale: animationValue,
        child: Container(
          width: 140.0,
          height: 80.0,
          child: Card(
            color: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }

  double getMarginTop(double animationValue) {
    double minMarginTop = 8.0;
    double marginTop =
        minMarginTop + (1 - animationValue) * FlightStopCard.height * 0.5;
    return marginTop;
  }

  double getMarginBottom(double animationValue) {
    double minMarginBottom = 8.0;
    double marginBottom =
        minMarginBottom + (1 - animationValue) * minMarginBottom;
    return marginBottom;
  }

  double getMarginRight(double animationValue) {
    return getMarginHorizontal(animationValue, isTextLeft: false);
  }

  double getMarginLeft(double animationValue) {
    return getMarginHorizontal(animationValue, isTextLeft: true);
  }

  double getMarginHorizontal(double animationValue,
      {@required bool isTextLeft}) {
    if (isTextLeft == widget.isLeft) {
      double minHorizontalMargin = 16.0;
      double maxHorizontalMargin = maxWidth - minHorizontalMargin;
      double horizontalMargin =
          minHorizontalMargin + (1 - animationValue) * maxHorizontalMargin;
      return horizontalMargin;
    } else {
      double maxHorizontalMargin = maxWidth - FlightStopCard.width;
      double horizontalMargin = animationValue * maxHorizontalMargin;
      return horizontalMargin;
    }
  }
}
