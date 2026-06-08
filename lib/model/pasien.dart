class Pasien {
  int? noRekamMedis;
  String? namaPasien;
  String? nikKtp;
  String? noBpjs;
  String? alamat;
  String? tanggalLahir;

  Pasien({
    this.noRekamMedis,
    this.namaPasien,
    this.nikKtp,
    this.noBpjs,
    this.alamat,
    this.tanggalLahir,
  });

  factory Pasien.fromJson(Map<String, dynamic> obj) {
    return Pasien(
      noRekamMedis: int.tryParse(obj['no_rekam_medis'].toString()),
      namaPasien: obj['nama_pasien'],
      nikKtp: obj['nik_ktp'],
      noBpjs: obj['no_bpjs'],
      alamat: obj['alamat'],
      tanggalLahir: obj['tanggal_lahir'],
    );
  }
}
