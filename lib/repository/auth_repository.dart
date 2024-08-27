// import 'package:followup/models/register_model.dart';
// import 'package:followup/models/registration_model.dart';
// import 'package:followup/models/subscription_model.dart';
// import 'package:followup/models/subscription_year_model.dart';
// import '../api/api_manager.dart';
// import '../constant/string_constant.dart';
// import '../models/login_model.dart';
//
// class AuthRepository {
//   final APIManager apiManager;
//   AuthRepository(this.apiManager);
//
//   Future<LoginModel> loginApiCall({required var params, bool isLoaderShow = true}) async {
//     var jsonData = await apiManager.postAPICall(
//       url: '${baseUrl}api/employee/login',
//       params: params,
//       isLoaderShow: isLoaderShow,
//     );
//     var response = LoginModel.fromJson(jsonData);
//     return response;
//   }
//
//   Future<SubscriptionModel> getCheckSubscriptionApiCall({bool isLoaderShow = true}) async {
//     var jsonData = await apiManager.getAPICall(
//       url: '${baseUrl}api/subscription',
//       isLoaderShow: isLoaderShow,
//     );
//     var response = SubscriptionModel.fromJson(jsonData);
//     return response;
//   }
//
//   Future<SubscriptionYearlyModel> subscribeApiCall({required var params, bool isLoaderShow = true}) async {
//     var jsonData = await apiManager.postAPICall(
//       url: '${baseUrl}subscribe-yearly',
//       params: params,
//       isLoaderShow: isLoaderShow,
//     );
//     var response = SubscriptionYearlyModel.fromJson(jsonData);
//     return response;
//   }
//
//   Future<RegisterModel> getRegisterApiCall({required var params, bool isLoaderShow = true}) async {
//     var jsonData = await apiManager.postAPICall(
//       url: '${baseUrl}register',
//       params: params,
//       isLoaderShow: isLoaderShow,
//     );
//     var response = RegisterModel.fromJson(jsonData);
//     return response;
//   }
//
//   Future<RegistrationModel> getRegistrationApiCall({bool isLoaderShow = true}) async {
//     var jsonData = await apiManager.getAPICall(
//       url: '${baseUrl}api/registration',
//       isLoaderShow: isLoaderShow,
//     );
//     var response = RegistrationModel.fromJson(jsonData);
//     return response;
//   }
// }
