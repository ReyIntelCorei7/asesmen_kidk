class Obat {
  int? idObat;
  String? namaObat;
  int? stok;
  double? hargaSatuan;

  Obat({this.idObat, this.namaObat, this.stok, this.hargaSatuan});

  factory Obat.fromJson(Map<String, dynamic> obj) {
    return Obat(
      idObat: int.tryParse(obj['id_obat'].toString()),
      namaObat: obj['nama_obat'],
      stok: int.tryParse(obj['stok'].toString()),
      hargaSatuan: double.tryParse(obj['harga_satuan'].toString()),
    );
  }
}
