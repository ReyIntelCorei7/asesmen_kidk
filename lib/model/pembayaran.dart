class Pembayaran {
  int? idPembayaran;
  int? idPemeriksaan;
  double? totalTagihan;
  String? tanggalBayar;
  String? statusPembayaran;
  String? diagnosis;
  String? namaPasien;

  Pembayaran({
    this.idPembayaran,
    this.idPemeriksaan,
    this.totalTagihan,
    this.tanggalBayar,
    this.statusPembayaran,
    this.diagnosis,
    this.namaPasien,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> obj) {
    return Pembayaran(
      idPembayaran: int.tryParse(obj['id_pembayaran'].toString()),
      idPemeriksaan: int.tryParse(obj['id_pemeriksaan'].toString()),
      totalTagihan: double.tryParse(obj['total_tagihan'].toString()),
      tanggalBayar: obj['tanggal_bayar'],
      statusPembayaran: obj['status_pembayaran'],
      diagnosis: obj['diagnosis'],
      namaPasien: obj['nama_pasien'],
    );
  }
}
