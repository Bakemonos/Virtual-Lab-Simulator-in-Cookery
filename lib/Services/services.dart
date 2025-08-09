import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:virtual_lab/components/custom_dalog.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/coc1.dart';
import 'package:virtual_lab/json/coc1_combination.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/models/user_model.dart';
import 'package:virtual_lab/services/api_response.dart';
import 'package:virtual_lab/utils/helper.dart';
import 'package:virtual_lab/utils/routes.dart';

class ApiServices extends GetxController {
  static ApiServices get instance => Get.find();
  static AppController get controller => Get.find();
  static Helper get helper => Get.find();

  final String apiKey = dotenv.env['API_URL']!;

  //? GET
  Future<ApiResponse> get(String endpoint) async {
    print('\nENDPOINT : $apiKey/$endpoint\n');

    try {
      final response = await http.get(Uri.parse('$apiKey/$endpoint')).timeout(Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(jsonDecode(response.body));
      } else {
        final body = jsonDecode(response.body);
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'GET failed: ${response.statusCode}',
          data: null,
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timeout. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  //? POST
  Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    print('\nENDPOINT : $apiKey/$endpoint\n');

    final response = await http.post(
      Uri.parse('$apiKey/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('POST failed: ${response.body}');
    }
  }

  Future<void> signup(BuildContext context) async {
    controller.loader.value = true;
    try {
      final data = UserModel(
        lrn: controller.lrnController.text,
        firstName: controller.firstnameController.text,
        lastName: controller.lastnameController.text,
        email: controller.emailController.text,
        gender: controller.gender.value,
        password: controller.passwordController.text,
        gradeLevel: controller.gradeLevel.value,
        status: 'pending',
      );

      debugPrint('\nData : ${data.toJson()}\n');

      final response = await post('student/create', data.toJson());

      if (response.success!) {
        controller.loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Account Created!',
            message: response.message.toString(),
            onConfirmBtnTap: () {
              context.go(Routes.signIn);
            },
          );
        }

        controller.resetSignup();
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Sign up Failed!',
          message: errorMessage,
        );
      }
      debugPrint('Error: $e');
    }
  }

  Future<void> signin(BuildContext context) async {
    controller.loader.value = true;
    try {
      final data = {
        'email': controller.emailController.text,
        'password': controller.passwordController.text,
      };

      final response = await post('auth/loginStudent', data);

      if (response.success!) {
        controller.loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Login Successful!',
            message: response.message.toString(),
            onConfirmBtnTap: () {
              controller.loader.value = false;
              controller.resetSignin();
              controller.userData.value = UserModel.fromJson(response.data!);
              context.go(Routes.menu);
            },
          );
        }
      }
    } catch (e) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Login Failed!',
          message: errorMessage,
        );
      }
      debugPrint('Error: $e');
    }
  }

  Future<void> ingredientsCreate(BuildContext context) async {
    controller.loader.value = true;
    try {

      final user = controller.userData.value;
      controller.ingredientsData.clear();

      for (int i = 0; i < ingredientsCOC1.length; i++) {
        if (controller.selectedList[i].value) {
          controller.ingredientsData.add(
            IngredientsModel(
              name: ingredientsCOC1[i].name,
              path: ingredientsCOC1[i].path,
              category: ingredientsCOC1[i].category,
            ),
          );
        }
      }

      controller.ingredientsData.refresh();

      final data = InventoryModel(
        type: controller.typeSelected.value!.menu ?? '',
        studentId: user.id ?? '',
        take: 'take_one',
        ingredients: controller.ingredientsData,
      );
      
      final response = await post('inventory/create', data.toJson());

      if (response.success!) {
        controller.loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Success Created!',
            message: response.message.toString(),
            onConfirmBtnTap: () {
              context.go(Routes.playUI);
            },
          );
        }
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Create Failed!',
          message: errorMessage,
        );
      }
      debugPrint('Error: $e');
    }
  }

  Future<void> createDish(BuildContext context) async {
    controller.loader.value = true;
    try {

      final coc = controller.typeSelected.value?.menu;
      if (coc == null) {
        debugPrint('typeSelected or its menu is null');
        controller.loader.value = false;
        return;
      }

      final studentId = controller.userData.value.id;
      final ingredients = controller.preparedData.value.ingredients;

      if (ingredients.any((i) => i.name.isEmpty)) {
        debugPrint('Found ingredient with empty name!');
        for (var i in ingredients) {
          debugPrint('${i.name} | ${i.category} | ${i.path}');
        }
      }

      final matchedDish = getBestMatchedDish(
        ingredients,
        helper.toCamelCase(controller.category.value), 
      );

      final data = SubmitedCocModel(
        type: coc, 
        category: helper.toCamelCase(controller.category.value), 
        name: controller.nameDishController.text, 
        image: matchedDish?['image'] ?? '', 
        studentId: studentId!, 
        ingredients: controller.preparedData.value.ingredients, 
        // equipments: equipmentData,
        equipments: [
          EquipmentsModel(
            name: 'pot', 
            image: 'pot.url',
          ),
          EquipmentsModel(
            name: 'hair net', 
            image: 'hair.url',
          ),
          EquipmentsModel(
            name: 'gloves', 
            image: 'gloves.url',
          ),
          EquipmentsModel(
            name: 'apron', 
            image: 'apron.url',
          ),
        ],
      );

      debugPrint('\nDATA : ${data.toJson()}\n');

      final response = await post('coc/create', data.toJson());

      if(response.success! && context.mounted){
        debugPrint('SUCCESS : ${response.message}');
        context.pop();
        controller.submitResetErrorHandler();
        controller.preparedIngredients.clear();
        // preparedData.value = InventoryModel.empty();
        if(context.mounted){
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Submitted Successful!',
            message: response.message.toString(),
          );
        }
      }{
        debugPrint('FAILED : ${response.message}');
        controller.preparedIngredients.clear();
      }

    } catch (e, t) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      debugPrint('Error: $errorMessage');
      debugPrint('STACKTRACE: $t');
      if (context.mounted) {
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Submitted Failed!',
          message: errorMessage,
        );
      }
    }
  }

  Future<void> submitCoc() async {
    controller.loader.value = true;
    try {

      final coc = controller.typeSelected.value!.menu;
      final studentId = controller.userData.value.id;
    
      Map<String, dynamic> data = {
        'image': controller.platingImageUrl.value,
        'studentId': studentId,
        'type': coc,
      }; 

      final response = await post('plating/create', data);

      if(response.success!){
        debugPrint('SUCCESS : ${response.message}');
      }{
        debugPrint('FAILED : ${response.message}');
      }

    } catch (e, t) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      debugPrint('Error: $errorMessage');
      debugPrint('STACKTRACE: $t');
    }
  }
  
  Future<void> getInventory(BuildContext context) async {
    controller.loader.value = true;
    
    try {
      final studentId = controller.userData.value.id;
      final coc = controller.typeSelected.value!.menu;
      final type = 'take_one';

      final response = await get('inventory/read/$studentId/?type=$coc&take=$type');
      controller.loader.value = false;

      if (!context.mounted) return;

      if (response.success! && response.data != null) {
        try {
          controller.typeInventory.value = InventoryModel.fromJson(response.data!);

          if (context.mounted) {
            context.go(Routes.playUI);
          }
          
        } catch (e) {
          debugPrint('PARSING ERROR: $e');
          controller.typeInventory.value = InventoryModel.empty();
        }

      } else {
        controller.typeInventory.value = InventoryModel.empty();

        if (context.mounted) {
          context.go(Routes.ingredientsSelection);
        }

        debugPrint('Inventory fetch failed: ${response.message}');
      }

    } catch (e, t) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      debugPrint('Error: $errorMessage');
      debugPrint('STACKTRACE: $t');
    }
  }

  Future<void> getDish(BuildContext context, {String? type}) async {
    controller.loader.value = true;

    try { 
      final studentId = controller.userData.value.id;
      final response = await get('coc/read/$studentId${(type == null || type.isEmpty) ? '' : '?type=$type'}');
      controller.loader.value = false;

      if (!context.mounted) return;

      if (response.success == true && response.data != null) {
        try {
          if (response.data is List) {
            final List<dynamic> list = response.data as List<dynamic>;

            controller.submittedCocList.value = list.map((e) => SubmitedCocModel.fromJson(e)).toList();

          } else {
            debugPrint('Expected list but got: ${response.data.runtimeType}');
            controller.submittedCocList.clear();
          }
        } catch (e) {
          debugPrint('PARSING ERROR: $e');
          controller.submittedCocList.clear();
        }
      } else {
        controller.submittedCocList.clear();
        debugPrint('Dish fetch failed: ${response.message}');
      }
    } catch (e, t) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      debugPrint('Error: $errorMessage');
      debugPrint('STACKTRACE: $t');
    }
  }

  Future<void> getScore(BuildContext context, String type) async {
    controller.loader.value = true;
    try { 
      final studentId = controller.userData.value.id;
      final response = await get('performance/read/$studentId/?type=$type');
      controller.loader.value = false;

      if (!context.mounted) return;

      if (response.success == true && response.data != null) {
        try {
          debugPrint('DATA: ${response.data}');

        } catch (e) {
          debugPrint('PARSING ERROR: $e');
        }
      } else {
        debugPrint('Score fetch failed: ${response.message}');
      }
    } catch (e, t) {
      controller.loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      debugPrint('Error: $errorMessage');
      debugPrint('STACKTRACE: $t');
    }
  }

  Future<String?> uploadImageToCloudinary(Uint8List imageBytes) async {
    final String cloudName = dotenv.env['CLOUD_NAME']!;
    const String uploadPreset = 'upload_plating';

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'screenshot.png',
          contentType: MediaType('image', 'png'),
        ),
      );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(responseData);
      return data['secure_url'];
    } else {
      debugPrint('Cloudinary upload failed: ${response.statusCode}');
      return null;
    }
  }

}
