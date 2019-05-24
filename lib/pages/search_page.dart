import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/webview.dart';

const TYPES = [
  'channelgroup', 
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup',
  ];

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.keyword, this.hint}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: searchModel?.data?.length ?? 0,
                itemBuilder: (BuildContext context, int position) {
                  return _item(position);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onTextChanged(text) {
    keyword = text;
    if(text.length == 0) {
      setState(() {
       searchModel = null; 
      });
      return;
    }
    SearchDao.fetch(keyword).then((SearchModel model){
      if(model.keyword == keyword) {
        setState(() {
        searchModel = model; 
        });
      }
    }).catchError((onError){
      print(onError);
    });

  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              speakClick: _jumpToSpeak,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChanged,
            ),
          ),
        ),
      ],
    );
  }
  _jumpToSpeak() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeakPage()
      ),
    );
  }

  _item(int position) {
    if(searchModel == null || searchModel.data == null) return null;
    SearchItemModel item = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebView(
              url: item.url,
              title: '详情',
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.3,
              color: Colors.grey,
            )
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _typeImage(String type) {
    if(type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if(type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(SearchItemModel item) {
    if(item ==null) return null;
    List<TextSpan> spans = []; 
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(
      TextSpan(
        text: '' + (item.districtname ?? '') + '' + (item.zonename ?? ''),
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }

  _keywordTextSpans(String word, String wordkey) {
    List<TextSpan> spans = [];
    if(word == null || word.length ==0) return spans;
    List<String> arr = word.split(wordkey);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);

    for(int i = 0 ; i < arr.length ; i++) {
      if( i + 1 % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if(val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _subTitle(SearchItemModel item) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: item.price ?? '',
            style: TextStyle(fontSize: 16, color: Colors.orange),
          ),
          TextSpan(
            text: ' ' + (item.price ?? ''),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ]
      ),
    );
  }

}