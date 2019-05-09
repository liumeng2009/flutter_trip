class SearchModel {
  String keyword;
  final List<SearchItemModel> data;

  SearchModel({
    this.keyword,
    this.data
  });
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var searchData = json['data'] as List;
    List<SearchItemModel> searchDataList = searchData.map((i)=>SearchItemModel.fromJson(i)).toList();
    return SearchModel(
      keyword: json['keyword'],
      data: searchDataList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    if(this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class SearchItemModel {
  final String word;
  final String type;
  final String price;
  final String start;
  final String zonename;
  final String districtname;
  final String url;

  SearchItemModel({
    this.word,
    this.type,
    this.price,
    this.start,
    this.zonename,
    this.districtname,
    this.url,
  });

  factory SearchItemModel.fromJson(Map<String, dynamic> json) {
    return SearchItemModel(
      word: json['word'],
      type: json['type'],
      price: json['price'],
      start: json['start'],
      zonename: json['zonename'],
      districtname: json['districtname'],
      url: json['url'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['price'] = this.price;
    data['start'] = this.start;
    data['zonename'] = this.zonename;
    data['districtname'] = this.districtname;
    data['url'] = this.url;
    return data;
  }
}