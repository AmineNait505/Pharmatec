
import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/typeVisite.dart';
import 'package:pharmatec/app/data/models/visite.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:pharmatec/app/services/visiteService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final visites = <Visite>[].obs;
  final isLoading = false.obs;
  final salesPersonCode = ''.obs;
  final contactNo = ''.obs;
  final clientNo = ''.obs;
  final selectedClient=''.obs;
  final selectedContact =''.obs;
  final VisiteService _visiteService = VisiteService();
  final selectedDate = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.week.obs;
    var isMenuOpen=false.obs;
      var selectedType = ''.obs;
  var selectedAction = ''.obs;
  List<TypeVisite> actionsList = [];

  @override
  void onInit() {
    super.onInit();
    loadArguments();
    fetchActions();
  }

  void loadArguments() async {
    final args = Get.arguments as Map<String, dynamic>?;
    print("ahmed ${args?['from']}");
    if (args?['from'] == Routes.HOME) {
      final prefs = await SharedPreferences.getInstance();
      clientNo.value = prefs.getString('client_id') ?? '';
      contactNo.value = prefs.getString('contact_id') ?? '';
      selectedClient.value=prefs.getString('client_name') ?? '';
      selectedContact.value =prefs.getString('contact_name') ??'';
    } else {
      clientNo.value ='';
      contactNo.value =  '';
    }
    await loadClientData();
  }
    Future<void> fetchActions() async {
    try {
      final actions = await _visiteService.fetchActions();
      actionsList = actions;
    } catch (e) {
      print('Error fetching actions: $e');
    }
  }
    List<String> getActionsForSelectedType() {
    return actionsList
        .where((action) => action.type == selectedType.value)
        .map((action) => action.action)
        .toList();
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    salesPersonCode.value = prefs.getString('salesperson') ?? '';
    if (salesPersonCode.isNotEmpty) {
      print(" ahmed ${clientNo.value}");
      print(" ahmed123 ${contactNo.value}");
      if(contactNo.isEmpty){
        await fetchVisites(salesPersonCode.value, clientNo.value);
      }else{
        await fetchVisites(salesPersonCode.value, contactNo.value);
      }
      
    }
  }

Future<void> fetchVisites(String salesPersonCode, String contactno) async {
  try {
    isLoading(true);
    List<Visite> visiteList;
      print("calendar ${contactNo}");
     

      visiteList = await _visiteService.fetchVisites(salesPersonCode, contactno);
    visites.assignAll(visiteList);
    selectedDate.value = DateTime.now();
    focusedDay.value = DateTime.now();
  } catch (e) {
    print('Failed to fetch visites: $e');
  } finally {
    isLoading(false);
  }
}

  // Handle day selection in the calendar
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    selectedDate.value = selectedDay;
    this.focusedDay.value = focusedDay;
  }

  // Get the visites for a specific day
  List<Visite> getVisitesForDay(DateTime day) {
    return visites.where((visite) {
      final visiteDate = DateTime.parse(visite.dateVisite);
      return isSameDay(visiteDate, day);
    }).toList();
  }
Future<void> createVisite() async {
  try {
    isLoading(true);
    final dateFormatted = '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
    final contactOrClientNo = contactNo.value.isNotEmpty ? contactNo.value : clientNo.value;
    final result = await _visiteService.createVisite(
      type: selectedType.value,
      action: selectedAction.value,
      commercialNo: salesPersonCode.value,
      contactNo: contactOrClientNo,
      dateVisite: dateFormatted,
    );
    if (result == 1) {
      print('Visite créée avec succès');
      if(contactNo.isEmpty){
        await fetchVisites(salesPersonCode.value, clientNo.value);
      }else{
        await fetchVisites(salesPersonCode.value, contactNo.value);
      }
    } else {
      print('Échec de la création de la visite');
    }
  } catch (e) {
    print('Erreur lors de la création de la visite: $e');
  } finally {
    isLoading(false);
  }
}

  @override
  void dispose() {
    Get.delete<CalendarController>();
    super.dispose();
  }
}
