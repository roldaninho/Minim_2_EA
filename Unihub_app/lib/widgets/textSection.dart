import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String _tipo;
  final String _info;

  TextSection(this._tipo, this._info);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Text(_tipo + ": ",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
          Text(
            _info,
            style: TextStyle(fontSize: 15),
            maxLines: 3,
          )
        ]));
  }
}
