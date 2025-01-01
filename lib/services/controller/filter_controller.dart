import 'dart:developer';

import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final List<String> sortBy = [
    'newest'.tr,
    'highestRated'.tr,
    'priceFromLow'.tr,
    'priceFromHigh'.tr,
  ];
  final List<String> genderSort = [
    'male'.tr,
    'female'.tr,
    'both'.tr,
  ];
  var sortBySelected = ''.obs;
  var selectedCity = ''.obs;
  var selectedCityIndex = -1;
  var selectedGenderIndex = -1;
  var selectedGender = ''.obs;

  /// Filters and sorts the event list from EventController
  List<Event> applyFilters() {
    final eventController =
        Get.put(EventController()); // Access EventController
    RxList<Event> events = <Event>[].obs;
    events.value = List<Event>.from(eventController.originalEventList);

    // Ensure at least one filter is selected
    if (sortBySelected.isEmpty && selectedCity.isEmpty) {
      eventController.eventList.clear();
      eventController.eventList.assignAll(eventController.originalEventList);
      return events; // No filters applied, return the original list
    }
    log(selectedCity.value);
    log(sortBySelected.value);

    // Filter by city (if selected)
    if (selectedCity.value.isNotEmpty && selectedCity.value != 'All') {
      log("message");
      log(selectedCity.value);
      final filterdList = <Event>[].obs;
      filterdList.assignAll(events
          .where((event) => event.regionEn == selectedCity.value)
          .toList());

      eventController.eventList.clear();
      eventController.eventList.assignAll(filterdList);
    }

    // Sort by selected option (if selected)
    if (sortBySelected.isNotEmpty) {
      switch (sortBySelected.value) {
        // case 'newest':
        //   filteredEvents.sort((a, b) => b.id.compareTo(a.id)); // Assuming `id` reflects time
        //   break;
        case 'Highest Rated':
          eventController.eventList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'Price (Low to High)':
          log("here low");
          // print(eventController.eventList.value.length);
          // print(eventController.eventList.length);

          eventController.eventList
              .sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          break;
        case 'Price (High to Low)':
          eventController.eventList
              .sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
          log('here high');
          // print(eventController.originalventList.first.price);
          // print(eventController.eventList.first.price);
          break;
      }
    }
    return eventController.eventList;
  }

  /// Updates the filtered events in EventController
  void updateFilteredEvents() {
    final EventController eventController = Get.put(EventController());
    RxList<Event> event = applyFilters().obs;
    eventController.eventList.clear();
    eventController.eventList.assignAll(event);
  }

  /// Resets all filters and restores the original list
  void resetFilters() {
    sortBySelected.value = '';
    selectedCity.value = '';
    selectedCityIndex = -1;
    selectedGenderIndex = -1;
    selectedGender.value = '';
    final EventController eventController = Get.put(EventController());
    eventController.eventList.clear();
    eventController.eventList.assignAll(eventController.originalEventList);

    // updateFilteredEvents(); // Apply filters with no selection
  }
}
