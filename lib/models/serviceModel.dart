class ServiceModel{
  late String userId;
  late String name;
  late String categoryName;
  late String description;
  late String availabilityStartTime;
  late String availabilityEndTime;
  late String availabilityStartDate;
  late String availabilityEndDate;
  late String city;
  late String country;
  late String pinCode;
  late String latitude;
  late String longitude;
  late String email;
  late String upiLink;
  late String watsApp;
  late String telegram;
  late String zoom;
  late String webAddress;

  ServiceModel(this.userId,this.name,this.categoryName,this.description,
      this.availabilityStartTime,this.availabilityEndTime,
      this.availabilityStartDate,this.availabilityEndDate,this.city,this.country,this.pinCode,this.latitude,this.longitude,
      this.email,this.upiLink,this.watsApp,this.telegram,this.zoom,this.webAddress);

  ServiceModel.fromJson(Map<String,dynamic> json){
    userId=json['userId'].toString();
    name=json['name'].toString();
    categoryName=json['category'].toString();
    description=json['desc'].toString();
    availabilityStartTime=json['startTime'].toString();
    availabilityEndTime=json['endTime'].toString();
    availabilityStartDate=json['startDate'].toString();
    availabilityEndDate=json['endDate'].toString();
    city=json['city'].toString();
    country=json['country'].toString();
    pinCode=json['pinCode'].toString();
    latitude=json['latitude'].toString();
    longitude=json['longitude'].toString();
    email=json['email'].toString();
    upiLink=json['upiLink'].toString();
    watsApp=json['watsApp'].toString();
    telegram=json['telegram'].toString();
    zoom=json['zoom'].toString();
    webAddress=json['webLink'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId']=this.userId;
    data['name'] = this.name;
    data['category'] = this.categoryName;
    data['desc'] = this.description;
    data['startTime'] = this.availabilityStartTime;
    data['endTime'] = this.availabilityEndTime;
    data['startDate'] = this.availabilityStartDate;
    data['endDate'] = this.availabilityEndDate;
    data['city'] = this.city;
    data['country'] = this.country;
    data['pinCode'] = this.pinCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['email'] = this.email;
    data['upiLink']=this.upiLink;
    data['watsApp'] = this.watsApp;
    data['telegram'] = this.telegram;
    data['zoom'] = this.zoom;
    data['webLink'] = this.webAddress;

    return data;
  }

}