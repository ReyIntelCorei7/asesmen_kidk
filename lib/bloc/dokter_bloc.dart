import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/dokter.dart';

class DokterBloc {
  static Future<List<Dokter>> getDokters() async {
    String apiUrl = ApiUrl.listDokter;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listDokter = (jsonObj as Map<String, dynamic>)['data'];
    List<Dokter> dokters = [];
    for (int i = 0; i < listDokter.length; i++) {
      dokters.add(Dokter.fromJson(listDokter[i]));
    }
    return dokters;
  }

  static Future addDokter({Dokter? dokter}) async {
    String apiUrl = ApiUrl.createDokter;
    var body = {
      "nama_dokter": dokter!.namaDokter,
      "spesialisasi": dokter.spesialisasi,
      "id_poli": dokter.idPoli.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateDokter({Dokter? dokter}) async {
    String apiUrl = ApiUrl.updateDokter(dokter!.idDokter!);
    var body = {
      "nama_dokter": dokter.namaDokter,
      "spesialisasi": dokter.spesialisasi,
      "id_poli": dokter.idPoli.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteDokter({int? id}) async {
    String apiUrl = ApiUrl.deleteDokter(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
