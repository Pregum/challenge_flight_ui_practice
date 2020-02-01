import 'package:challenge_flight_ui/air_asia_bar.dart';
import 'package:challenge_flight_ui/content_card.dart';
import 'package:challenge_flight_ui/rounded_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AirAsiaBar(
            height: 210.0,
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40.0),
              child: Column(
                children: <Widget>[
                  _buildButtonsRow(),
                  // Container(),
                  Expanded(child: ContentCard(),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildButtonsRow() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        RoundedButton(text: 'ONE WAY'),
        RoundedButton(text: 'ROUND'),
        RoundedButton(text: 'MULTICITY', selected: true),
      ],
    ),
  );
}
