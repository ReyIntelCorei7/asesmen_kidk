import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pasien.dart';

class PasienBloc {
  static Future<List<Pasien>> getPasiens() async {
    String apiUrl = ApiUrl.listPasien;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPasien = (jsonObj as Map<String, dynamic>)['data'];
    List<Pasien> pasiens = [];
    for (int i = 0; i < listPasien.length; i++) {
      pasiens.add(Pasien.fromJson(listPasien[i]));
    }
    return pasiens;
  }

  static Future addPasien({Pasien? pasien}) async {
    String apiUrl = ApiUrl.createPasien;
    var body = {
      "nama_pasien": pasien!.namaPasien,
      "nik_ktp": pasien.nikKtp,
      "no_bpjs": pasien.noBpjs,
      "alamat": pasien.alamat,
      "tanggal_lahir": pasien.tanggalLahir
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePasien({Pasien? pasien}) async {
    String apiUrl = ApiUrl.updatePasien(pasien!.noRekamMedis!);
    var body = {
      "nama_pasien": pasien.namaPasien,
      "nik_ktp": pasien.nikKtp,
      "no_bpjs": pasien.noBpjs,
      "alamat": pasien.alamat,
      "tanggal_lahir": pasien.tanggalLahir
    };
    var response = await Api().post(apiUrl, body); // Assuming POST for update based on PDF pattern
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePasien({int? id}) async {
    String apiUrl = ApiUrl.deletePasien(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
