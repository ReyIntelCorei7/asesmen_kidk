class Dokter {
  int? idDokter;
  String? namaDokter;
  String? spesialisasi;
  int? idPoli;
  String? namaPoli;

  Dokter({this.idDokter, this.namaDokter, this.spesialisasi, this.idPoli, this.namaPoli});

  factory Dokter.fromJson(Map<String, dynamic> obj) {
    return Dokter(
      idDokter: int.tryParse(obj['id_dokter'].toString()),
      namaDokter: obj['nama_dokter'],
      spesialisasi: obj['spesialisasi'],
      idPoli: int.tryParse(obj['id_poli'].toString()),
      namaPoli: obj['nama_poli'],
    );
  }
}
