import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import '../serializer/serializers.dart';

class BuiltValueConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    print("body: ${request.body}");
    return super.convertRequest(
      request.replace(
        body: request.body != null ? serializers.serializeWith(
          serializers.serializerForType(request.body.runtimeType),
          request.body,
        ): null, // body is set to null value if there is a request to post a multipart file
      ),
    );
  }
  @override
  Response<BodyType> convertResponse<BodyType, SingleItemType> (Response response) =>
    response.headers.values.contains("application/octet-stream")
        ? _convertBinaryFile<BodyType, SingleItemType>(response)
        : _convertJsonResponse<BodyType, SingleItemType>(response);



  Response <BodyType> _convertBinaryFile<BodyType, SingleItemType>(Response response)  {
    return response.replace<BodyType>(body: response.bodyBytes as BodyType);
    // ^ do not convert to Json like in the functions below, just make the content (that is a character array) a strongly-typed String
  }
  
  Response<BodyType> _convertJsonResponse<BodyType, SingleItemType>(Response response){
    // The response parameter contains raw binary JSON data by default.
    // Utilize the already written code which converts this data to a dynamic Map or a List of Maps.
    final Response dynamicResponse = super.convertResponse(response);
    // customBody can be either a BuiltList<SingleItemType> or just the SingleItemType (if there's no list).
    final BodyType customBody =
    _convertToCustomObject<SingleItemType>(dynamicResponse.body);

    // Return the original dynamicResponse with a no-longer-dynamic body type.
    return dynamicResponse.replace<BodyType>(body: customBody);

  }

  dynamic _convertToCustomObject<SingleItemType>(dynamic element) {
    // If the type which the response should hold is explicitly set to a dynamic Map,
    // there's nothing we can convert.
    if (element is SingleItemType) return element;
    if (element is List)
      return _deserializeListOf<SingleItemType>(element);
    else
      return _deserialize<SingleItemType>(element);
  }

  BuiltList<SingleItemType> _deserializeListOf<SingleItemType>(
      List dynamicList,
      ) {
    // Make a BuiltList holding individual custom objects
    final primitives = [String, int, double];

    return BuiltList<SingleItemType>(
      dynamicList.map((element) =>
      primitives.contains(element.runtimeType)
          ? element
          : _deserialize<SingleItemType>(element)
      ),
    );
  }

  SingleItemType _deserialize<SingleItemType>(
      Map<String, dynamic> value,
      ) {
    // We have a type parameter for the BuiltValue type
    // which should be returned after deserialization.
    return serializers.deserializeWith<SingleItemType>(
      serializers.serializerForType(SingleItemType),
      value,
    );
  }
}