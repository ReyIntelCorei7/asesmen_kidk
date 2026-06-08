import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';

class PemeriksaanBloc {
  static Future<List<Pemeriksaan>> getPemeriksaans() async {
    String apiUrl = ApiUrl.listPemeriksaan;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPemeriksaan = (jsonObj as Map<String, dynamic>)['data'];
    List<Pemeriksaan> pemeriksaans = [];
    for (int i = 0; i < listPemeriksaan.length; i++) {
      pemeriksaans.add(Pemeriksaan.fromJson(listPemeriksaan[i]));
    }
    return pemeriksaans;
  }

  static Future addPemeriksaan({Pemeriksaan? pemeriksaan}) async {
    String apiUrl = ApiUrl.createPemeriksaan;
    var body = {
      "no_rekam_medis": pemeriksaan!.noRekamMedis.toString(),
      "id_dokter": pemeriksaan.idDokter.toString(),
      "tanggal_periksa": pemeriksaan.tanggalPeriksa,
      "diagnosis": pemeriksaan.diagnosis,
      "tindakan": pemeriksaan.tindakan,
      "biaya_pemeriksaan": pemeriksaan.biayaPemeriksaan.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePemeriksaan({Pemeriksaan? pemeriksaan}) async {
    String apiUrl = ApiUrl.updatePemeriksaan(pemeriksaan!.idPemeriksaan!);
    var body = {
      "no_rekam_medis": pemeriksaan.noRekamMedis.toString(),
      "id_dokter": pemeriksaan.idDokter.toString(),
      "tanggal_periksa": pemeriksaan.tanggalPeriksa,
      "diagnosis": pemeriksaan.diagnosis,
      "tindakan": pemeriksaan.tindakan,
      "biaya_pemeriksaan": pemeriksaan.biayaPemeriksaan.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePemeriksaan({int? id}) async {
    String apiUrl = ApiUrl.deletePemeriksaan(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
