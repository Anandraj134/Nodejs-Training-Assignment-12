import 'package:assignment_12/core/utils/globals.dart';
import 'package:dio/dio.dart';

Future<void> dioGetRequest({
  required String url,
  required Function successCallback,
  required Function errorCallback,
  bool contextMounted = false,
}) async {
  try {
    Response response = await Dio().get(
      url,
      options: Options(
        headers: {"Authorization": authToken},
      ),
    );

    if (response.data["success"]) {
      successCallback(response.data);
    } else {
      if (!contextMounted) return;
      errorCallback(response.data["data"]);
    }
  } on DioException catch (error) {
    if (!contextMounted) return;
    errorCallback(error.response?.data["data"]);
  } catch (error) {
    if (!contextMounted) return;
    errorCallback(error.toString());
  }
}

Future<void> dioPostRequest({
  required String url,
  dynamic data,
  required Function successCallback,
  required Function errorCallback,
  bool contextMounted = false,
}) async {
  try {
    Response response = await Dio().post(
      url,
      data: data,
      options: Options(
        headers: {"Authorization": authToken},
      ),
    );
    if (response.data["success"]) {
      successCallback(response.data);
    } else {
      if (!contextMounted) return;
      errorCallback(response.data["data"]);
    }
  } on DioException catch (error) {
    if (!contextMounted) return;
    errorCallback(error.response?.data["data"]);
  } catch (error) {
    if (!contextMounted) return;
    errorCallback(error.toString());
  }
}

Future<void> dioPutRequest({
  required String url,
  dynamic data,
  required Function successCallback,
  required Function errorCallback,
  bool contextMounted = false,
}) async {
  try {
    Response response = await Dio().put(
      url,
      data: data,
      options: Options(
        headers: {"Authorization": authToken},
      ),
    );

    if (response.data["success"]) {
      successCallback(response.data);
    } else {
      if (!contextMounted) return;
      errorCallback(response.data["data"]);
    }
  } on DioException catch (error) {
    if (!contextMounted) return;
    errorCallback(error.response?.data["data"]);
  } catch (error) {
    if (!contextMounted) return;
    errorCallback(error.toString());
  }
}

Future<void> dioDeleteRequest({
  required String url,
  required Function successCallback,
  required Function errorCallback,
  bool contextMounted = false,
}) async {
  try {
    Response response = await Dio().delete(
      url,
      options: Options(
        headers: {"Authorization": authToken},
      ),
    );

    if (response.data["success"]) {
      successCallback(response.data);
    } else {
      if (!contextMounted) return;
      errorCallback(response.data["data"]);
    }
  } on DioException catch (error) {
    if (!contextMounted) return;
    errorCallback(error.response?.data["data"]);
  } catch (error) {
    if (!contextMounted) return;
    errorCallback(error.toString());
  }
}
