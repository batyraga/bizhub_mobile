import 'dart:developer';

import 'package:bizhub/api/auctions.dart';
import 'package:bizhub/api/auth.dart';
import 'package:bizhub/api/banners.dart';
import 'package:bizhub/api/brands.dart';
import 'package:bizhub/api/categories.dart';
import 'package:bizhub/api/chat.dart';
import 'package:bizhub/api/cities.dart';
import 'package:bizhub/api/collections.dart';
import 'package:bizhub/api/feedbacks.dart';
import 'package:bizhub/api/notifications.dart';
import 'package:bizhub/api/packages.dart';
import 'package:bizhub/api/posts.dart';
import 'package:bizhub/api/products.dart';
import 'package:bizhub/api/sellers.dart';
import 'package:bizhub/api/wallet.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api with ChangeNotifier {
  final Dio dio = Dio();

  Future<void> loadApiAddress() async {
    final api_ = storage.read("api_address");
    log("server api: $api_");
    if (api_ != null) {
      url = "$api_:3000";
      apiUrl = "http://$url";
      wsUrl = "ws://$url";
      cdnUrl = "$apiUrl/cdn/";
    }
  }

  Future<void> init() async {
    checkAuth();
  }

  void checkAuth() {
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      // * protection
      options.headers.addAll({'ojo-mobile': 'by OJO dev.'});

      if (options.headers[ApiConstants.authorizationHeader] != null) {
        options.headers.remove(ApiConstants.dismissInterceptor);
        return handler.next(options);
      }
      final String? accessToken = storage.read("access_token");
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] = "Bearer $accessToken";
      }
      return handler.next(options);
    }, onError: (DioException err, ErrorInterceptorHandler handler) async {
      try {
        if (err.response?.statusCode == 401) {
          RequestOptions origin = err.response!.requestOptions;
          final data = ApiResponse.fromJson(err.response!.data as Map<String, dynamic>);
          if (data.error?.code == ApiErrorConstants.accessTokenExpired) {
            try {
              final String accessToken = await auth.refreshToken();
              if (accessToken == ApiErrorConstants.refreshTokenExpired) {
                globalEvents.emit("logout");
                origin.headers.remove(ApiConstants.authorizationHeader);
                final resp = await dio.request(origin.path,
                    data: origin.data,
                    cancelToken: origin.cancelToken,
                    onReceiveProgress: origin.onReceiveProgress,
                    onSendProgress: origin.onSendProgress,
                    queryParameters: origin.queryParameters,
                    options: Options(
                      contentType: origin.contentType,
                      extra: origin.extra,
                      followRedirects: origin.followRedirects,
                      headers: origin.headers,
                      listFormat: origin.listFormat,
                      maxRedirects: origin.maxRedirects,
                      method: origin.method,
                      receiveDataWhenStatusError: origin.receiveDataWhenStatusError,
                      receiveTimeout: origin.receiveTimeout,
                      requestEncoder: origin.requestEncoder,
                      responseDecoder: origin.responseDecoder,
                      responseType: origin.responseType,
                      sendTimeout: origin.sendTimeout,
                      validateStatus: origin.validateStatus,
                    ));
                return handler.resolve(resp);
              }
              log("status access token => $accessToken aa");
              origin.headers[ApiConstants.authorizationHeader] = "Bearer $accessToken";
              globalEvents.emit("at-changed", [accessToken]);
              final resp = await dio.request(origin.path,
                  data: origin.data,
                  cancelToken: origin.cancelToken,
                  onReceiveProgress: origin.onReceiveProgress,
                  onSendProgress: origin.onSendProgress,
                  queryParameters: origin.queryParameters,
                  options: Options(
                    contentType: origin.contentType,
                    extra: origin.extra,
                    followRedirects: origin.followRedirects,
                    headers: origin.headers,
                    listFormat: origin.listFormat,
                    maxRedirects: origin.maxRedirects,
                    method: origin.method,
                    receiveDataWhenStatusError: origin.receiveDataWhenStatusError,
                    receiveTimeout: origin.receiveTimeout,
                    requestEncoder: origin.requestEncoder,
                    responseDecoder: origin.responseDecoder,
                    responseType: origin.responseType,
                    sendTimeout: origin.sendTimeout,
                    validateStatus: origin.validateStatus,
                  ));
              return handler.resolve(resp);
            } catch (error) {
              return handler.next(err);
            }
          }
        }
        return handler.next(err);
      } catch (errr) {
        return handler.next(err);
      }
    }));
  }

  // void checkAuth() {
  //   dio.interceptors.clear();
  //   dio.interceptors.add(InterceptorsWrapper(onRequest:
  //           (RequestOptions options, RequestInterceptorHandler handler) async {
  //     if (options.headers[ApiConstants.authorizationHeader] != null) {
  //       options.headers.remove(ApiConstants.dismissInterceptor);
  //       return handler.next(options);
  //     }
  //     final String? accessToken = storage.read("access_token");
  //     debugPrint("status => $accessToken");
  //     if (accessToken != null && accessToken.isNotEmpty) {
  //       options.headers[ApiConstants.authorizationHeader] =
  //           "Bearer $accessToken";
  //     }
  //     debugPrint(
  //       "request header => ${options.headers}",
  //     );
  //     return handler.next(options);
  //   },
  //       // onResponse: (Response res, ResponseInterceptorHandler handler) async {
  //       //   log("taze response =>>>>>>>>>>>>>>>>>>>>>>>> ${res.statusCode}");
  //       //   try {
  //       //     if (res.statusCode == 401) {
  //       //       log("error boldy");
  //       //       RequestOptions origin = res.requestOptions;
  //       //       final data = ApiResponse.fromJson(res.data as Map<String, dynamic>);
  //       //       if (data.error == ApiConstants.accessTokenExpired) {
  //       //         try {
  //       //           final String accessToken = await auth.refreshToken();
  //       //           log("status access token => $accessToken aa");
  //       //           origin.headers["Authorization"] = "Bearer $accessToken";
  //       //           final resp = await dio.request(origin.path,
  //       //               data: origin.data,
  //       //               cancelToken: origin.cancelToken,
  //       //               onReceiveProgress: origin.onReceiveProgress,
  //       //               onSendProgress: origin.onSendProgress,
  //       //               queryParameters: origin.queryParameters,
  //       //               options: Options(
  //       //                 contentType: origin.contentType,
  //       //                 extra: origin.extra,
  //       //                 followRedirects: origin.followRedirects,
  //       //                 headers: origin.headers,
  //       //                 listFormat: origin.listFormat,
  //       //                 maxRedirects: origin.maxRedirects,
  //       //                 method: origin.method,
  //       //                 receiveDataWhenStatusError:
  //       //                     origin.receiveDataWhenStatusError,
  //       //                 receiveTimeout: origin.receiveTimeout,
  //       //                 requestEncoder: origin.requestEncoder,
  //       //                 responseDecoder: origin.responseDecoder,
  //       //                 responseType: origin.responseType,
  //       //                 sendTimeout: origin.sendTimeout,
  //       //                 validateStatus: origin.validateStatus,
  //       //               ));
  //       //           return handler.resolve(resp);
  //       //         } catch (error) {
  //       //           return handler.next(res);
  //       //         }
  //       //       } else if (data.error == ApiConstants.refreshTokenExpired) {
  //       //         await globalEvents.emit("logout");
  //       //         origin.headers.remove("Authorization");
  //       //         final resp = await dio.request(origin.path,
  //       //             data: origin.data,
  //       //             cancelToken: origin.cancelToken,
  //       //             onReceiveProgress: origin.onReceiveProgress,
  //       //             onSendProgress: origin.onSendProgress,
  //       //             queryParameters: origin.queryParameters,
  //       //             options: Options(
  //       //               contentType: origin.contentType,
  //       //               extra: origin.extra,
  //       //               followRedirects: origin.followRedirects,
  //       //               headers: origin.headers,
  //       //               listFormat: origin.listFormat,
  //       //               maxRedirects: origin.maxRedirects,
  //       //               method: origin.method,
  //       //               receiveDataWhenStatusError: origin.receiveDataWhenStatusError,
  //       //               receiveTimeout: origin.receiveTimeout,
  //       //               requestEncoder: origin.requestEncoder,
  //       //               responseDecoder: origin.responseDecoder,
  //       //               responseType: origin.responseType,
  //       //               sendTimeout: origin.sendTimeout,
  //       //               validateStatus: origin.validateStatus,
  //       //             ));
  //       //         return handler.resolve(resp);
  //       //       }
  //       //     }
  //       //     return handler.next(res);
  //       //   } catch (errr) {
  //       //     return handler.next(res);
  //       //   }
  //       // }

  //       onError: (DioError err, ErrorInterceptorHandler handler) async {
  //     log("error boldy ${err.response?.statusCode} ${err.response?.data}");
  //     log("statusCode:${err.response?.statusCode}; code:${err.response?.data}");
  //     try {
  //       if (err.response?.statusCode == 401) {
  //         RequestOptions origin = err.response!.requestOptions;
  //         final data =
  //             ApiResponse.fromJson(err.response!.data as Map<String, dynamic>);
  //         log("code check:${data.error?.code == ApiConstants.accessTokenExpired}");
  //         log("error obj:${data.error}; code field:${data.error?.code}");
  //         if (data.error?.code == ApiConstants.accessTokenExpired) {
  //           try {
  //             final String accessToken = await auth.refreshToken();
  //             log("access token refreshed: $accessToken");
  //             if (accessToken == ApiConstants.refreshTokenExpired) {
  //               globalEvents.emit("logout");
  //               origin.headers.remove(ApiConstants.authorizationHeader);
  //               final resp = await dio.request(origin.path,
  //                   data: origin.data,
  //                   cancelToken: origin.cancelToken,
  //                   onReceiveProgress: origin.onReceiveProgress,
  //                   onSendProgress: origin.onSendProgress,
  //                   queryParameters: origin.queryParameters,
  //                   options: Options(
  //                     contentType: origin.contentType,
  //                     extra: origin.extra,
  //                     followRedirects: origin.followRedirects,
  //                     headers: origin.headers,
  //                     listFormat: origin.listFormat,
  //                     maxRedirects: origin.maxRedirects,
  //                     method: origin.method,
  //                     receiveDataWhenStatusError:
  //                         origin.receiveDataWhenStatusError,
  //                     receiveTimeout: origin.receiveTimeout,
  //                     requestEncoder: origin.requestEncoder,
  //                     responseDecoder: origin.responseDecoder,
  //                     responseType: origin.responseType,
  //                     sendTimeout: origin.sendTimeout,
  //                     validateStatus: origin.validateStatus,
  //                   ));
  //               return handler.resolve(resp);
  //             }
  //             log("status access token => $accessToken aa");
  //             origin.headers[ApiConstants.authorizationHeader] =
  //                 "Bearer $accessToken";
  //             final resp = await dio.request(origin.path,
  //                 data: origin.data,
  //                 cancelToken: origin.cancelToken,
  //                 onReceiveProgress: origin.onReceiveProgress,
  //                 onSendProgress: origin.onSendProgress,
  //                 queryParameters: origin.queryParameters,
  //                 options: Options(
  //                   contentType: origin.contentType,
  //                   extra: origin.extra,
  //                   followRedirects: origin.followRedirects,
  //                   headers: origin.headers,
  //                   listFormat: origin.listFormat,
  //                   maxRedirects: origin.maxRedirects,
  //                   method: origin.method,
  //                   receiveDataWhenStatusError:
  //                       origin.receiveDataWhenStatusError,
  //                   receiveTimeout: origin.receiveTimeout,
  //                   requestEncoder: origin.requestEncoder,
  //                   responseDecoder: origin.responseDecoder,
  //                   responseType: origin.responseType,
  //                   sendTimeout: origin.sendTimeout,
  //                   validateStatus: origin.validateStatus,
  //                 ));
  //             return handler.resolve(resp);
  //           } catch (error) {
  //             err.error = error;
  //             return handler.next(err);
  //           }
  //         }
  //       }
  //       return handler.next(err);
  //     } catch (errr) {
  //       err.error = errr;
  //       return handler.next(err);
  //     }
  //   }));
  // }

  final PostsApi posts = PostsApi();
  final CollectionsApi collections = CollectionsApi();
  final ProductsApi products = ProductsApi();
  final SellersApi sellers = SellersApi();
  final CategoriesApi categories = CategoriesApi();
  final BrandsApi brands = BrandsApi();
  final CitiesApi cities = CitiesApi();
  final AuthApi auth = AuthApi();
  final PackagesApi packages = PackagesApi();
  final AuctionsApi auctions = AuctionsApi();
  final FeedbacksApi feedbacks = FeedbacksApi();
  final BannersApi banners = BannersApi();
  final WalletApi wallet = WalletApi();
  final NotificationsApi notifications = NotificationsApi();
  final ChatApi chat = ChatApi();
}

final api = Api();
