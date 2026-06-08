class Dokter {
  int? idDokter;
  String? namaDokter;
  String? spesialisasi;
  int? idPoli;

  Dokter({this.idDokter, this.namaDokter, this.spesialisasi, this.idPoli});

  factory Dokter.fromJson(Map<String, dynamic> obj) {
    return Dokter(
      idDokter: int.tryParse(obj['id_dokter'].toString()),
      namaDokter: obj['nama_dokter'],
      spesialisasi: obj['spesialisasi'],
      idPoli: int.tryParse(obj['id_poli'].toString()),
    );
  }
}
