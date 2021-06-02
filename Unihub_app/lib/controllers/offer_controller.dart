import 'package:unihub_app/models/offer.dart';

import '../networking/apibasehelper.dart';
import 'package:http/http.dart' as http;

ApiBaseHelper _helper = ApiBaseHelper();

class OfferController {
  Future<dynamic> createOffer(String username, String title, String university,
      String subject, String type, String description, String price) async {
    var body = {
      'username': username,
      'title': title,
      'university': university,
      'subject': subject,
      'type': type,
      'description': description,
      'price': price,
    };
    print(body);
    final http.Response response = await _helper.post('/Offer/newOffer', body);
    print("Estoy en response " + response.body);
    return response.statusCode;
  }

  Future<dynamic> updateOffer(OfferApp offer) async {
    var json = offer.toJSON();
    print('Envio esta oferta: ' + json.toString());
    final http.Response response =
        await _helper.post('/Offer/updateOffer', json);
    print("Estoy en response: " + response.body);
    return response;
  }

  Future<dynamic> deleteOffer(String id) async {
    final http.Response response =
        await _helper.delete('/User/deleteOffer/$id');
    print("Response: " + response.body);
    return response;
  }

  Future<dynamic> getOffers() async {
    final http.Response response = await _helper.get('/Offer/getAllOffers');
    print("Response: " + response.body);
    return response;
  }

  Future<dynamic> getOffer(String username) async {
    final http.Response response =
        await _helper.get('/Offer/getOffer/$username');
    print("Response: " + response.body);
    return response.body;
  }
}
