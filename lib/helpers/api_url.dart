class ApiUrl {
  static const String baseUrl = 'http://localhost/rs-api/public';
  
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Pasien
  static const String listPasien = '$baseUrl/pasien';
  static const String createPasien = '$baseUrl/pasien';
  static String showPasien(int id) => '$baseUrl/pasien/$id';
  static String updatePasien(int id) => '$baseUrl/pasien/$id/update';
  static String deletePasien(int id) => '$baseUrl/pasien/$id';

  // Poli
  static const String listPoli = '$baseUrl/poli';
  static const String createPoli = '$baseUrl/poli';
  static String showPoli(int id) => '$baseUrl/poli/$id';
  static String updatePoli(int id) => '$baseUrl/poli/$id/update';
  static String deletePoli(int id) => '$baseUrl/poli/$id';

  // Dokter
  static const String listDokter = '$baseUrl/dokter';
  static const String createDokter = '$baseUrl/dokter';
  static String showDokter(int id) => '$baseUrl/dokter/$id';
  static String updateDokter(int id) => '$baseUrl/dokter/$id/update';
  static String deleteDokter(int id) => '$baseUrl/dokter/$id';

  // Pemeriksaan
  static const String listPemeriksaan = '$baseUrl/pemeriksaan';
  static const String createPemeriksaan = '$baseUrl/pemeriksaan';
  static String showPemeriksaan(int id) => '$baseUrl/pemeriksaan/$id';
  static String updatePemeriksaan(int id) => '$baseUrl/pemeriksaan/$id/update';
  static String deletePemeriksaan(int id) => '$baseUrl/pemeriksaan/$id';

  // Resep
  static const String listResep = '$baseUrl/resep';
  static const String createResep = '$baseUrl/resep';
  static String showResep(int id) => '$baseUrl/resep/$id';
  static String updateResep(int id) => '$baseUrl/resep/$id/update';
  static String deleteResep(int id) => '$baseUrl/resep/$id';

  // Obat
  static const String listObat = '$baseUrl/obat';
  static const String createObat = '$baseUrl/obat';
  static String showObat(int id) => '$baseUrl/obat/$id';
  static String updateObat(int id) => '$baseUrl/obat/$id/update';
  static String deleteObat(int id) => '$baseUrl/obat/$id';

  // Pembayaran
  static const String listPembayaran = '$baseUrl/pembayaran';
  static const String createPembayaran = '$baseUrl/pembayaran';
  static String showPembayaran(int id) => '$baseUrl/pembayaran/$id';
  static String updatePembayaran(int id) => '$baseUrl/pembayaran/$id/update';
  static String deletePembayaran(int id) => '$baseUrl/pembayaran/$id';
}
