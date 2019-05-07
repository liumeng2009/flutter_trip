import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if(subNavList == null) return null;

    int rowNum = 0;
    print(subNavList.length/5);
    rowNum = subNavList.length % 5 == 0 ? subNavList.length ~/ 5  : (subNavList.length ~/ 5 + 1);

    List<Widget> items = [];
    for(int i = 0; i < rowNum; i++) {
      items.add(_row(context, i * 5, (i + 1) * 5));
    }

    return Column(
      children: items,
    );
  }

  _row(BuildContext context, int start, int end) {
    List<Widget> items = [];
    var sepSubNavList = subNavList.sublist(start, end);
    sepSubNavList.forEach((model){
      items.add(_item(context, model));
    });
    return Padding(
      padding: start != 0 ? EdgeInsets.only(top: 10.0) : EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => WebView(
                url: model.url,
                statusBarColor: model.statusBarColor,
                hideAppBar: model.hideAppBar,
              ),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Image.network(
              model.icon,
              width: 18.0,
              height: 18.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                model.title,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}