import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/hom_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地';
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
  List<CommonModel> localNavList = [];
  GridNavModel gridNav;
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _handlerRefresh();
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

  Future<void> _handlerRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      print('loading data');
      setState(() {
        isLoading = false;
        localNavList = model.localNavList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        bannerList = model.bannerList;
      });
    } catch(e){
      setState(() {
        isLoading = false;
        print(e);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: RefreshIndicator(
                onRefresh: _handlerRefresh,
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: _listView,
                ),
              ), 
            ),
            _appBar,
          ],
        ),
        isLoading: isLoading,
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
          child: LocalNav(
            localNavList: localNavList,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 4.0),
          child: GridNav(
            gridNavModel: gridNav,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 4.0),
          child: SubNav(
            subNavList: subNavList,
          ),
        ),
        Container(
          height: 800,
          child: Text(
            'long text'
          ),
        ),
      ],
    );          
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: bannerList[index].url,
                  ),
                ),
              );
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                ? SearchBarType.homeLight
                : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black12,
              blurRadius: 0.5,
            )],
          ),
        ),
      ],
    );
  }

  _jumpToSearch() {

  }
  _jumpToSpeak() {

  }
}