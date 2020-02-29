import 'package:flutter/material.dart';

class SubscribeWidget extends StatefulWidget {
  SubscribeWidget(this.status,
      {this.channelID, this.userID, @required this.onClick});
  final String userID;
  final String channelID;
  bool status;
  Function(bool status) onClick;
  @override
  _SubscribeWidgetState createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  Color clr = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status) {
      clr = Colors.red;
    } else {
      clr = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            widget.status = !widget.status;
            print(widget.status);
            widget.onClick(widget.status);
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
