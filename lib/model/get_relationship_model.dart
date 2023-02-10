class RelationshipName {
  int? id;
  String? name;

  RelationshipName({this.id, this.name});

  RelationshipName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

}