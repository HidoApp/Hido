import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final List<String> sortBy = [
    //'newest'.tr,
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
  var eventFilterCounter = 0.obs;
  var hospitalityFilterCounter = 0.obs;
  var activityFilterCounter = 0.obs;

  /// Filters and sorts the event list from EventController
  List<Event> applyEventFilters() {
    eventFilterCounter.value = 0;
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

    // Filter by city (if selected)
    if (selectedCity.value.isNotEmpty && selectedCity.value != 'All') {
      eventFilterCounter++;

      final filterdList = <Event>[].obs;
      filterdList.assignAll(eventController.originalEventList
          .where((event) => event.regionEn == selectedCity.value)
          .toList());

      eventController.eventList.clear();
      eventController.eventList.assignAll(filterdList);
    } else {
      eventController.eventList.clear();
      eventController.eventList.assignAll(eventController.originalEventList);
    }

    // Sort by selected option (if selected)
    if (sortBySelected.isNotEmpty) {
      eventFilterCounter++;
      switch (sortBySelected.value) {
        case 'Highest Rated':
          eventController.eventList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'الأعلى تقييما':
          eventController.eventList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'Price (Low to High)':
          eventController.eventList
              .sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          break;
        case 'السعر (من الأدنى إلى الأعلى)':
          eventController.eventList
              .sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          break;
        case 'Price (High to Low)':
          eventController.eventList
              .sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));

          break;
        case 'السعر (من الأعلى إلى الأدنى)':
          eventController.eventList
              .sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));

          break;
      }
      //put finished  item in the last of list
      eventController.eventList.sort((a, b) {
        if (a.status == 'CLOSED' && b.status != 'CLOSED') return 1;
        if (a.status != 'CLOSED' && b.status == 'CLOSED') return -1;
        return 0;
      });
    }
    return eventController.eventList;
  }

  /// Updates the filtered events in EventController
  void updateFilteredEvents() {
    final EventController eventController = Get.put(EventController());
    RxList<Event> event = applyEventFilters().obs;
    eventController.eventList.clear();
    eventController.eventList.assignAll(event);
  }

  /// Filters and sorts the event list from Activity
  List<Adventure> applyActivitytFilters() {
    activityFilterCounter.value = 0;
    final activityController =
        Get.put(AdventureController()); // Access Activity controller
    RxList<Adventure> acitvity = <Adventure>[].obs;
    acitvity.value =
        List<Adventure>.from(activityController.originalAdventureList);

    // Ensure at least one filter is selected
    if (sortBySelected.isEmpty && selectedCity.isEmpty) {
      activityController.adventureList.clear();
      activityController.adventureList
          .assignAll(activityController.originalAdventureList);
      return acitvity; // No filters applied, return the original list
    }

    // Filter by city (if selected)
    if (selectedCity.value.isNotEmpty && selectedCity.value != 'All') {
      activityFilterCounter++;

      final filterdList = <Adventure>[].obs;
      filterdList.assignAll(acitvity
          .where((event) => event.regionEn == selectedCity.value)
          .toList());

      activityController.adventureList.clear();
      activityController.adventureList.assignAll(filterdList);
    } else {
      activityController.adventureList.clear();
      activityController.adventureList
          .assignAll(activityController.originalAdventureList);
    }

    // Sort by selected option (if selected)
    if (sortBySelected.isNotEmpty) {
      activityFilterCounter++;

      switch (sortBySelected.value) {
        // case 'newest':
        //   filteredEvents.sort((a, b) => b.id.compareTo(a.id)); // Assuming `id` reflects time
        //   break;
        case 'Highest Rated':
          activityController.adventureList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'الأعلى تقييما':
          activityController.adventureList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'Price (Low to High)':
          activityController.adventureList
              .sort((a, b) => (a.price).compareTo(b.price));
          break;
        case 'السعر (من الأدنى إلى الأعلى)':
          activityController.adventureList
              .sort((a, b) => (a.price).compareTo(b.price));
          break;
        case 'Price (High to Low)':
          activityController.adventureList
              .sort((a, b) => (b.price).compareTo(a.price));

          break;
        case 'السعر (من الأعلى إلى الأدنى)':
          activityController.adventureList
              .sort((a, b) => (b.price).compareTo(a.price));

          break;
      }
      //put finished  item in the last of list
      activityController.adventureList.sort((a, b) {
        if (a.status == 'CLOSED' && b.status != 'CLOSED') return 1;
        if (a.status != 'CLOSED' && b.status == 'CLOSED') return -1;
        return 0;
      });
    }
    return activityController.adventureList;
  }

  /// Updates the filtered events in ActivityController
  void updateFilteredActivity() {
    final activityController = Get.put(AdventureController());
    RxList<Adventure> activity = applyActivitytFilters().obs;
    activityController.adventureList.clear();
    activityController.adventureList.assignAll(activity);
  }

  /// Filters and sorts the event list from Hospitality
  List<Hospitality> applyHospitalityFilters() {
    hospitalityFilterCounter.value = 0;
    final hospitalityController =
        Get.put(HospitalityController()); // Access Hospitality controller
    final hospitality = <Hospitality>[].obs;
    hospitality.value =
        List<Hospitality>.from(hospitalityController.originalHospitalityList);

    // Ensure at least one filter is selected
    if (sortBySelected.isEmpty && selectedCity.isEmpty) {
      hospitalityController.hospitalityList.clear();
      hospitalityController.hospitalityList
          .assignAll(hospitalityController.originalHospitalityList);
      return hospitality; // No filters applied, return the original list
    }

    // Filter by city (if selected)
    if (selectedCity.value.isNotEmpty && selectedCity.value != 'All') {
      hospitalityFilterCounter++;

      final filterdList = <Hospitality>[].obs;
      filterdList.assignAll(hospitality
          .where((event) => event.regionEn == selectedCity.value)
          .toList());

      hospitalityController.hospitalityList.clear();
      hospitalityController.hospitalityList.assignAll(filterdList);
    } else {
      hospitalityController.hospitalityList.clear();
      hospitalityController.hospitalityList
          .assignAll(hospitalityController.originalHospitalityList);
    }

    // Sort by selected option (if selected)
    if (sortBySelected.isNotEmpty) {
      hospitalityFilterCounter++;

      switch (sortBySelected.value) {
        case 'Highest Rated':
          hospitalityController.hospitalityList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'الأعلى تقييما':
          hospitalityController.hospitalityList
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'Price (Low to High)':
          hospitalityController.hospitalityList
              .sort((a, b) => (a.price).compareTo(b.price));
          break;
        case 'السعر (من الأدنى إلى الأعلى)':
          hospitalityController.hospitalityList
              .sort((a, b) => (a.price).compareTo(b.price));
          break;
        case 'Price (High to Low)':
          hospitalityController.hospitalityList
              .sort((a, b) => (b.price).compareTo(a.price));

          break;
        case 'السعر (من الأعلى إلى الأدنى)':
          hospitalityController.hospitalityList
              .sort((a, b) => (b.price).compareTo(a.price));

          break;
      }
      //put finished  item in the last of list
      hospitalityController.hospitalityList.sort((a, b) {
        if (a.status == 'CLOSED' && b.status != 'CLOSED') return 1;
        if (a.status != 'CLOSED' && b.status == 'CLOSED') return -1;
        return 0;
      });
    }
    return hospitalityController.hospitalityList;
  }

  /// Updates the filtered events in HospitalityController
  void updateFilteredHospitality() {
    final hospitalityController = Get.put(HospitalityController());
    RxList<Hospitality> hospitality = applyHospitalityFilters().obs;
    hospitalityController.hospitalityList.clear();
    hospitalityController.hospitalityList.assignAll(hospitality);
  }

  /// Resets all filters and restores the original list
  void resetFilters() {
    sortBySelected.value = '';
    selectedCity.value = '';
    selectedCityIndex = -1;
    selectedGenderIndex = -1;
    selectedGender.value = '';
    eventFilterCounter.value = 0;
    activityFilterCounter.value = 0;
    hospitalityFilterCounter.value = 0;
    final EventController eventController = Get.put(EventController());
    final activityController = Get.put(AdventureController());
    final hospitalityController = Get.put(HospitalityController());
    // reset hospitalty
    hospitalityController.hospitalityList.clear();
    hospitalityController.hospitalityList.assignAll(
      hospitalityController.originalHospitalityList,
    );
    //reset event
    eventController.eventList.clear();
    eventController.eventList.assignAll(eventController.originalEventList);
    //reset activtiy
    activityController.adventureList.clear();
    activityController.adventureList
        .assignAll(activityController.originalAdventureList);
    update();
  }
}
