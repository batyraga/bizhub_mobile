class ApiError {
  final String message;
  final String code;
  const ApiError({required this.message, required this.code});

  ApiError.fromJson(Map<String, dynamic> map)
      : message = map["message"],
        code = map["code"];
}

class ApiResponse<T> {
  final bool isSuccess;
  final ApiError? error;
  final T result;
  const ApiResponse(
      {required this.isSuccess, this.error, required this.result});

  ApiResponse.fromJson(Map<String, dynamic> map)
      : isSuccess = map["isSuccess"],
        error = map["error"] == null ? null : ApiError.fromJson(map["error"]),
        result = map["result"];
}

// class ApiResponseDecoder {
//   const ApiResponseDecoder();
//   ApiResponseDecoder.fromJson(Map map);
// }

// class ApiResponseList<T implements ApiResponseDecoder>  {
//   final List<T> list;
//   const ApiResponseList(this.list);

//   ApiResponseList.fromArray(List l) : list = List<T>.from(T.fromJson);
// }

// class ApiResponseTaze<T> {
//   final bool isSuccess;
//   final ApiError? error;
//   final T result;
//   const ApiResponseTaze(
//       {required this.isSuccess, this.error, required this.result});

//   ApiResponseTaze.fromJson(
//       Map<String, dynamic> map, T Function(dynamic) itemDecoder)
//       : isSuccess = map["isSuccess"],
//         error = map["error"] == null ? null : ApiError.fromJson(map["error"]),
//         result = T is List
//             ? List.from((map["result"] as List).map((e) => itemDecoder(e)))
//                 .cast()
//                 .toList()
//             : itemDecoder(map["result"] as dynamic);
// }
