class Poli {
  int? idPoli;
  String? namaPoli;
  String? lokasiRuangan;

  Poli({this.idPoli, this.namaPoli, this.lokasiRuangan});

  factory Poli.fromJson(Map<String, dynamic> obj) {
    return Poli(
      idPoli: int.tryParse(obj['id_poli'].toString()),
      namaPoli: obj['nama_poli'],
      lokasiRuangan: obj['lokasi_ruangan'],
    );
  }
}
