class Pemeriksaan {
  int? idPemeriksaan;
  int? noRekamMedis;
  int? idDokter;
  String? tanggalPeriksa;
  String? diagnosis;
  String? tindakan;
  double? biayaPemeriksaan;

  Pemeriksaan({
    this.idPemeriksaan,
    this.noRekamMedis,
    this.idDokter,
    this.tanggalPeriksa,
    this.diagnosis,
    this.tindakan,
    this.biayaPemeriksaan,
  });

  factory Pemeriksaan.fromJson(Map<String, dynamic> obj) {
    return Pemeriksaan(
      idPemeriksaan: int.tryParse(obj['id_pemeriksaan'].toString()),
      noRekamMedis: int.tryParse(obj['no_rekam_medis'].toString()),
      idDokter: int.tryParse(obj['id_dokter'].toString()),
      tanggalPeriksa: obj['tanggal_periksa'],
      diagnosis: obj['diagnosis'],
      tindakan: obj['tindakan'],
      biayaPemeriksaan: double.tryParse(obj['biaya_pemeriksaan'].toString()),
    );
  }
}
