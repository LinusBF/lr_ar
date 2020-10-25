import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class StatsBlock extends StatelessWidget {
  final Position pos;
  final double heading;

  const StatsBlock({Key key, this.pos, this.heading}) : super(key: key);

  List<Widget> getStats() {
    print(pos);

    if(pos == null) return [Container()];
    return [
      Text('Lat: ${pos.latitude}'),
      Text('Lon: ${pos.longitude}'),
      Text('Acc: ${pos.accuracy.round()}'),
      Text('Heading: ${heading.round()}'),
      Text('Altitude: ${pos.altitude.round()}'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(25),
      child: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(pos == null) Text('Loading'),
            ...getStats(),
          ],
        ),
      ),
    );
  }
}
