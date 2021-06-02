import 'package:unihub_app/models/user.dart';

import '../networking/apibasehelper.dart';
import 'package:http/http.dart' as http;

ApiBaseHelper _helper = ApiBaseHelper();

class EditProfileController {
  Future<dynamic> getProfile(String username) async {
    final http.Response response = await _helper.get('/User/getUser/$username');
    print("Response: " + response.body);
    return response.body;
  }

  Future<dynamic> updateProfile(UserApp user) async {
    var json = user.toJSON();
    print('Envio este usuario: ' + json.toString());
    final http.Response response = await _helper.post('/User/updateUser', json);
    print("Estoy en response: " + response.body);
    return response;
  }

  Future<dynamic> deleteProfile(String username) async {
    final http.Response response =
        await _helper.delete('/User/deleteUser/$username');
    print("Response: " + response.body);
    return response;
  }

  Future<dynamic> getUniversities() async {
    final http.Response response = await _helper.get('/Data/getUniversities');
    print("Response: " + response.body);
    return response;
  }

  Future<dynamic> getSchool(String school) async {
    final http.Response response =
        await _helper.get('/Data/getDegrees/$school');
    print("Response: " + response.body);
    return response;
  }

  Future<dynamic> getDegree(String degree) async {
    final http.Response response =
        await _helper.get('/Data/getSubjects/$degree');
    print("Response: " + response.body);
    return response;
  }
}
