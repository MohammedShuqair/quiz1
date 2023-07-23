class QImage {
  String? provider;
  String? license;
  String? terms;
  String? url;

  QImage({this.provider, this.license, this.terms, this.url});

  QImage.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    license = json['license'];
    terms = json['terms'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['license'] = this.license;
    data['terms'] = this.terms;
    data['url'] = this.url;
    return data;
  }
}
