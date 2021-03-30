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
  /**
   * 0 - Todas
   * 1 - Essa semana
   */
  int dateFilter = 0;
  String dateFilterText = 'Todas';
  

  _applyFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_bookmark', isBookmark);
    prefs.setInt('date_filter', dateFilter);
    widget._listener.update();
    Navigator.pop(context);
  }

  _cleanFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_bookmark', false);
    prefs.setInt('date_filter', 0);
    widget._listener.update();
    Navigator.pop(context);
  }

  _getFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBookmark = prefs.getBool('show_bookmark') ?? false;
      dateFilter = prefs.getInt('date_filter') ?? 0;
      switch(dateFilter) {
        case 0:
          dateFilterText = 'Todas';
          break;
        case 1:
          dateFilterText = 'Essa semana';
          break;
      }
    });
  }

  _showOptionsDialog() {
    Widget optionAll = SimpleDialogOption(
      child: Text('Todas'),
      onPressed: (){
        Navigator.pop(context);
        setState(() {
          dateFilter = 0;
          dateFilterText = 'Todas';
        });
      },
    );

    Widget optionThisWeek = SimpleDialogOption(
      child: Text('Essa semana'),
      onPressed: (){
        Navigator.pop(context);
        setState(() {
          dateFilter = 1;
          dateFilterText = 'Essa semana';
        });
      },
    );

    SimpleDialog dialog = SimpleDialog(
      title: Text('Data'),
      children: [
        optionAll,
        optionThisWeek
      ]
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  void initState() {
    _getFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro'),
        actions: [

          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: _cleanFilter,
                child: Container(
                  width: 50,
                  child: Text('Limpar'),
                ),
              ),
            )
          )

        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            ListTile(
              title: Text('Data'),
              trailing: Text(dateFilterText),
              onTap: _showOptionsDialog,
            ),
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
