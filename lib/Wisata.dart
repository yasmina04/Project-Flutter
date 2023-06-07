class Wisata {
  final int id;
  final String nama;
  final String ket;
  final String lokasi;
  final String tipe;
  final String maps;
  final String detail;
  final dynamic total_rating;
  final int total_ulasan;
  final String img;

  const Wisata({
    required this.id,
    required this.nama,
    required this.ket,
    required this.lokasi,
    required this.tipe,
    required this.maps,
    required this.detail,
    required this.total_rating,
    required this.total_ulasan,
    required this.img,
  });

  factory Wisata.fromJson(Map<String, dynamic> json){
    return Wisata(id: json['id'], nama: json['nama'], ket: json['ket'], lokasi: json['lokasi'], tipe: json['tipe'], maps: json['maps'], detail: json['detail'], total_rating: json['total_rating'], total_ulasan: json['total_ulasan'], img: json['img']);
  }
}