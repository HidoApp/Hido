import 'package:get/get.dart';

class FilterController extends GetxController {
  final List<String> sortBy = [
    'Newest',
    'Highest Rated',
    'Price (Low to High)',
    'Price (High to Low)',
  ];
  var sortBySelected = ''.obs;
  var selectedCity = ''.obs;
  var selectedCityIndex =-1;
  var selectedGenderIndex =-1;

}
