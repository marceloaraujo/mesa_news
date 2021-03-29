import 'package:flutter/material.dart';
import 'package:mesa_news/utils/ColorUtils.dart';
import 'package:mesa_news/utils/UpdateListener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {

  UpdateListener _listener;

  FilterPage(this._listener);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  bool isBookmark = false;

  _applyFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_bookmark', isBookmark);
    widget._listener.update();
    Navigator.pop(context);
  }

  _getBookmarkConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBookmark = prefs.getBool('show_bookmark');
    });
  }

  @override
  void initState() {
    _getBookmarkConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Apenas favoritos'),
              value: isBookmark, 
              onChanged: (checked) {
                setState(() {
                  isBookmark = checked;
                });
              }
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: ColorUtils.getColorFromHex('#010A53'),
          child: FlatButton(
            onPressed: _applyFilter,
            color: ColorUtils.getColorFromHex('#010A53'),
            child: Text(
              'Filtrar',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}