class ModelMakanan{
  int? id;
  String? nama;
  String? harga;
  String? description;
  String? link;
  String? category;

  ModelMakanan({required this.id, required this.nama, required this.description, required this.harga, required this.link, required this.category });
  ModelMakanan.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nama = json['name'];
    harga = json['harga'];
    description = json['desk'];
    link = json['link'];
    category = json['category'];
  }
}