import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

class CustomChopperClient extends ChopperClient{

  CustomChopperClient({
    baseUrl: "",
    http.Client client,
    Iterable interceptors: const [],
    converter,
    errorConverter,
    Iterable<ChopperService> services: const [],
  }): super(baseUrl: baseUrl, client: client, interceptors: interceptors, converter: converter, errorConverter: errorConverter, services: services);

  Future<Response<BodyType>> send<BodyType, InnerType>(
      Request request, {
        ConvertRequest requestConverter,
        ConvertResponse responseConverter,
      }) async {

    final res = await super.send(request, requestConverter: requestConverter, responseConverter: responseConverter);
    if(!responseIsSuccessful(res.statusCode) && _tokenExpired()){
      await _refresh();
      return await super.send(request, requestConverter: requestConverter, responseConverter: responseConverter);
    }
    else{
      return res;
    }
  }

  bool _tokenExpired() => true;

  void _refresh() async{

  }

  bool responseIsSuccessful(int statusCode) =>
      statusCode >= 200 && statusCode < 300;
}