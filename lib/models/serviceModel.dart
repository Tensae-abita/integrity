class ServiceModel{
  late String name;
  late String categoryName;
  late String description;
  late String availabilityStartTime;
  late String availabilityEndTime;
  late String availabilityStartDate;
  late String availabilityEndDate;

  ServiceModel(this.name,this.categoryName,this.description,
      this.availabilityStartTime,this.availabilityEndTime,
      this.availabilityStartDate,this.availabilityEndDate);

  ServiceModel.fromJson(Map<String,dynamic> json){
    name=json['name'].toString();
    categoryName=json['category'].toString();
    description=json['desc'].toString();
    availabilityStartTime=json['startTime'].toString();
    availabilityEndTime=json['endTime'].toString();
    availabilityStartDate=json['startDate'].toString();
    availabilityEndDate=json['endDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.categoryName;
    data['desc'] = this.description;
    data['startTime'] = this.availabilityStartTime;
    data['endTime'] = this.availabilityEndTime;
    data['startDate'] = this.availabilityStartDate;
    data['endDate'] = this.availabilityEndDate;
    return data;
  }

}