import '../networking/apibasehelper.dart';
import 'package:http/http.dart' as http;

ApiBaseHelper _helper = ApiBaseHelper();

class FeedController {
  Future<dynamic> createFeedPub(
      String username, String content, String date) async {
    var body = {'username': username, 'content': content, 'date': date};
    print(body);
    final http.Response response = await _helper.post('/Feed/newFeed', body);
    print("Estoy en response " + response.body);
    return response;
  }

  Future<dynamic> createSugerenciaPub(
      String username, String content, String date) async {
    var body = {'username': username, 'content': content, 'date': date};
    print(body);
    final http.Response response =
        await _helper.post('/Sugerencia/newSugerencia', body);
    print("Estoy en response " + response.body);
    return response;
  }

  Future<dynamic> getFeedPubs() async {
    final http.Response response = await _helper.get('/Feed/getAllFeeds');
    return response;
  }

  Future<dynamic> getSugerenciaPubs() async {
    final http.Response response =
        await _helper.get('/Sugerencia/getAllSugerencias');
    return response;
  }

  Future<dynamic> deleteFeedPost(String id) async {
    final http.Response response = await _helper.delete('/Feed/deleteFeed/$id');
    print('Response: ' + response.body);
    return response;
  }

  Future<dynamic> deleteSugerenciaPost(String id) async {
    final http.Response response =
        await _helper.delete('/Sugerencia/deleteSugerencia/$id');
    print('Response: ' + response.body);
    return response;
  }

  Future<dynamic> getUserImage(String username) async {
    final http.Response response =
        await _helper.get('/User/getUserImage/$username');
    return response.body;
  }

  Future<dynamic> setLikes(String username, String action, String id) async {
    var body = {'username': username, '_id': id};
    final http.Response response =
        await _helper.post('/Feed/updateLikes/$action', body);
    return response.statusCode;
  }
}
