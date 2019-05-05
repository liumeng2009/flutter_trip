import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/hom_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
const APPBAR_SCROLL_OFFSET = 100;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://hbimg.huabanimg.com/2de4d342c1767616c0307733f231978f16159be511a14-jXX4jo_fw658',
    'https://hbimg.huabanimg.com/043f46e618db6167bab76d66526b4d1430eb970269e0a-3AooUa_fw658',
    'https://hbimg.huabanimg.com/acb67d0867fc191ac3a0e3a469151ba1948c31dc26788-J6L697_fw658',
  ];
  double appBarAlpha = 0;
  String resultString = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if(alpha < 0) {
      alpha = 0;
    } else if(alpha > 1) {
      alpha = 1;
    }
    setState(() {
     appBarAlpha = alpha; 
    });
    print(appBarAlpha);
  }

  loadData() async {
    // HomeDao.fetch().then((result){
    //   setState(() {
    //    resultString = json.encode(result); 
    //   });
    // }).catchError((e){
    //   resultString = e.toString();
    // });
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model); 
      });
    } catch(e){
      setState(() {
        resultString = e.toString(); 
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          _imageUrls[index],
                          fit: BoxFit.fill,
                          );
                      },
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Container(
                    height: 800,
                    child: ListTile(
                      title: Text(resultString),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Opacity(
            opacity: appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('首页'),
                ),
              ),
            ),
          ),
        ],
      ), 
    );
  }
}