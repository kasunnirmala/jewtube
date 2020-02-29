import 'package:flutter/material.dart';

class SubscribeWidget extends StatefulWidget {
  SubscribeWidget(this.status, {this.channelID, this.userID});
  final String userID;
  final String channelID;
  final bool status;
  @override
  _SubscribeWidgetState createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  bool _selected;
  Color clr = Colors.grey;

  @override
  void initState() {
    _selected = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selected) {
      clr = Colors.red;
    } else {
      clr = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            
            _selected = !_selected;
            print(_selected);
            
          });
        },
        child: Text(
          "SUBSCRIBE",
          style: TextStyle(color: clr),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(side: BorderSide(color: clr, width: 1)),
      ),
    );
  }
}
