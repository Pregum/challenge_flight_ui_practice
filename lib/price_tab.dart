import 'package:challenge_flight_ui/animated_dot.dart';
import 'package:challenge_flight_ui/flight_stop.dart';
import 'package:challenge_flight_ui/flight_stop_card.dart';
import 'package:flutter/material.dart';

import 'animated_plane_icon.dart';

class PriceTab extends StatefulWidget {
  final double height;
  final VoidCallback onPlaneFlightStart;

  const PriceTab({Key key, this.height, this.onPlaneFlightStart})
      : super(key: key);

  @override
  State<PriceTab> createState() => _PriceTabState();
}

class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  final List<FlightStop> _flightStops = [
    FlightStop('JFK', 'ORY', 'JUN 05', '6h 25m', '\$851', '9:26 am - 3:43 pm'),
    FlightStop('MRG', 'FTB', 'JUN 20', '6h 25m', '\$532', '9:26 am - 3:43 pm'),
    FlightStop('ERT', 'TVS', 'JUN 20', '6h 25m', '\$718', '9:26 am - 3:43 pm'),
    FlightStop('KKR', 'RTY', 'JUN 20', '6h 25m', '\$663', '9:26 am - 3:43 pm'),
  ];

  final List<GlobalKey<FlightStopCardState>> _stopKeys = [];
  AnimationController _fabAnimationController;
  Animation _fabAnimation;

  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;
  // final List<int> _flightStops = [1, 2, 3, 4];
  final double _cardHeight = 80.0;

  AnimationController _dotsAnimationController;
  List<Animation<double>> _dotPositions = [];

  AnimationController _planeTravelController;
  AnimationController _planeSizeAnimationController;
  Animation _planeSizeAnimation;
  Animation _planeTravelAnimation;

  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;
  double get _maxPlaneTopPadding =>
      widget.height - _initialPlanePaddingBottom - _planeSize;
  double get _planeSize => _planeSizeAnimation.value;

  @override
  void initState() {
    super.initState();
    _initSizeAnimation();
    _initPlaneTravelAnimation();
    _initDotAnimationController();
    _initDotAnimations();
    _initFabAnimationController();
    _flightStops
        .forEach((stop) => _stopKeys.add(GlobalKey<FlightStopCardState>()));
    _planeSizeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildPlane(),
        ]
          // ..addAll(_flightStops.map(_mapFlightStopToDot)),
          ..addAll(_flightStops.map(_buildStopCard))
          ..addAll(_flightStops.map(_mapFlightStopToDot))
          ..add(_buildFab()),
      ),
    );
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    super.dispose();
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Column(
        children: <Widget>[
          // _buildPlaneIcon(),
          AnimatedPlaneIcon(
            animation: _planeSizeAnimation,
          ),
          Container(
            width: 2.0,
            // height: 240.0,
            height: _flightStops.length * _cardHeight * 0.8,
            color: Color.fromARGB(255, 200, 200, 200),
          ),
        ],
      ),
      builder: (context, child) => Positioned(
        top: _planeTopPadding,
        child: child,
      ),
    );
  }

  void _initSizeAnimation() {
    _planeSizeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 340),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 500), () {
            widget?.onPlaneFlightStart();
            _planeTravelController.forward();
          });
          Future.delayed(Duration(milliseconds: 700), () {
            _dotsAnimationController.forward();
          });
        }
      });
    _planeSizeAnimation = Tween<double>(begin: 60.0, end: 36.0).animate(
      CurvedAnimation(
        parent: _planeSizeAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _initPlaneTravelAnimation() {
    _planeTravelController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _planeTravelAnimation = CurvedAnimation(
      parent: _planeTravelController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _initDotAnimations() {
    final double slideDurationInterval = 0.4;
    final double slideDelayInterval = 0.2;
    double startingMarginTop = widget.height;
    double minMarginTop =
        _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * _cardHeight);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * _cardHeight);
      Animation<double> animation = Tween<double>(
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        CurvedAnimation(
          parent: _dotsAnimationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
      _dotPositions.add(animation);
    }
  }

  void _initDotAnimationController() {
    _dotsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animateFlightStopCards().then((_) => _animateFab());
        }
      });
  }

  Widget _mapFlightStopToDot(FlightStop stop) {
    int index = _flightStops.indexOf(stop);
    bool isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    Color color = isStartOrEnd ? Colors.red : Colors.green;
    return AnimatedDot(
      animation: _dotPositions[index],
      color: color,
    );
  }

  Widget _buildStopCard(FlightStop stop) {
    int index = _flightStops.indexOf(stop);
    double topMargin = _dotPositions[index].value -
        0.5 * (FlightStopCard.height - AnimatedDot.size);
    bool isLeft = index.isOdd;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLeft ? Container() : Expanded(child: Container()),
            Expanded(
              child: FlightStopCard(
                key: _stopKeys[index],
                flightStop: stop,
                isLeft: isLeft,
              ),
            ),
            !isLeft ? Container() : Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      bottom: 16.0,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.check, size: 36.0),
        ),
      ),
    );
  }

  void _initFabAnimationController() {
    _fabAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOut,
    );
  }

  Future _animateFlightStopCards() {
    return Future.forEach(_stopKeys, (GlobalKey<FlightStopCardState> stopKey){
      return Future.delayed(Duration(milliseconds: 250),() {
        stopKey.currentState.runAnimation();
      });
    });
  }

  void _animateFab() {
    _fabAnimationController.forward();
  }
}
