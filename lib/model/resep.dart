class Resep {
  int? idResep;
  int? idPemeriksaan;
  int? noRekamMedis;
  int? idDokter;
  String? tanggalResep;
  double? totalBiayaObat;

  Resep({
    this.idResep,
    this.idPemeriksaan,
    this.noRekamMedis,
    this.idDokter,
    this.tanggalResep,
    this.totalBiayaObat,
  });

  factory Resep.fromJson(Map<String, dynamic> obj) {
    return Resep(
      idResep: int.tryParse(obj['id_resep'].toString()),
      idPemeriksaan: int.tryParse(obj['id_pemeriksaan'].toString()),
      noRekamMedis: int.tryParse(obj['no_rekam_medis'].toString()),
      idDokter: int.tryParse(obj['id_dokter'].toString()),
      tanggalResep: obj['tanggal_resep'],
      totalBiayaObat: double.tryParse(obj['total_biaya_obat'].toString()),
    );
  }
}
