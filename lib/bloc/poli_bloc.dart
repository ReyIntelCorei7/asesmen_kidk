import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/poli.dart';

class PoliBloc {
  static Future<List<Poli>> getPolis() async {
    String apiUrl = ApiUrl.listPoli;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPoli = (jsonObj as Map<String, dynamic>)['data'];
    List<Poli> polis = [];
    for (int i = 0; i < listPoli.length; i++) {
      polis.add(Poli.fromJson(listPoli[i]));
    }
    return polis;
  }

  static Future addPoli({Poli? poli}) async {
    String apiUrl = ApiUrl.createPoli;
    var body = {
      "nama_poli": poli!.namaPoli,
      "lokasi_ruangan": poli.lokasiRuangan
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePoli({Poli? poli}) async {
    String apiUrl = ApiUrl.updatePoli(poli!.idPoli!);
    var body = {
      "nama_poli": poli.namaPoli,
      "lokasi_ruangan": poli.lokasiRuangan
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePoli({int? id}) async {
    String apiUrl = ApiUrl.deletePoli(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
