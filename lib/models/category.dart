class Category{
  late String id;
  late String name;

  Category.fromJson(Map<String,dynamic> json){
    id=json['id'].toString();
    name=json['name'].toString();
  }

}