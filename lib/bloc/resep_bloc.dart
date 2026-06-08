import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/resep.dart';

class ResepBloc {
  static Future<List<Resep>> getReseps() async {
    String apiUrl = ApiUrl.listResep;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listResep = (jsonObj as Map<String, dynamic>)['data'];
    List<Resep> reseps = [];
    for (int i = 0; i < listResep.length; i++) {
      reseps.add(Resep.fromJson(listResep[i]));
    }
    return reseps;
  }

  static Future addResep({Resep? resep}) async {
    String apiUrl = ApiUrl.createResep;
    var body = {
      "id_pemeriksaan": resep!.idPemeriksaan.toString(),
      "no_rekam_medis": resep.noRekamMedis.toString(),
      "id_dokter": resep.idDokter.toString(),
      "tanggal_resep": resep.tanggalResep,
      "total_biaya_obat": resep.totalBiayaObat.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateResep({Resep? resep}) async {
    String apiUrl = ApiUrl.updateResep(resep!.idResep!);
    var body = {
      "id_pemeriksaan": resep.idPemeriksaan.toString(),
      "no_rekam_medis": resep.noRekamMedis.toString(),
      "id_dokter": resep.idDokter.toString(),
      "tanggal_resep": resep.tanggalResep,
      "total_biaya_obat": resep.totalBiayaObat.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteResep({int? id}) async {
    String apiUrl = ApiUrl.deleteResep(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
