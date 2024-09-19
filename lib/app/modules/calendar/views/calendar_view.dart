import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/data/models/visite.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Calendrier des visites',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: secondColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildTableCalendar(),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.visites.isEmpty) {
                return const Center(child: Text('Aucune visite disponible.'));
              }

              return _buildVisiteTimeline(controller.selectedDate.value);
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if(controller.clientNo.isEmpty){
          return const SizedBox.shrink();
        }
        return SpeedDial(
          icon: controller.isMenuOpen.value ? Icons.close : Icons.arrow_forward,
          backgroundColor: secondColor,
          activeBackgroundColor: secondColor,
          foregroundColor: Colors.white,
          onOpen: () => controller.isMenuOpen.value = true,
          onClose: () => controller.isMenuOpen.value = false,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add, color: Colors.white),
              label: 'Passer une commande indirect',
              onTap: () {
                Get.toNamed(Routes.ADDCOMMANDE,arguments: {'isQuote': false});
              },
              backgroundColor: secondColor,
              labelBackgroundColor: secondColor,
              labelStyle: const TextStyle(color: Colors.white),
            ),
            SpeedDialChild(
              child: const Icon(Icons.location_on_outlined, color: Colors.white),
              label: 'Planifier une visite',
              onTap: () {
                _showPlanifierVisiteDialog(context);
              },
              backgroundColor: secondColor,
              labelBackgroundColor: secondColor,
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTableCalendar() {
    return Obx(() => TableCalendar(
          focusedDay: controller.focusedDay.value,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: controller.calendarFormat.value,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mois',
            CalendarFormat.week: 'Semaine',
          },
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDate.value, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            controller.onDaySelected(selectedDay, focusedDay);
          },
          eventLoader: (day) {
            return controller.getVisitesForDay(day);
          },
          onFormatChanged: (format) {
            controller.onFormatChanged(format);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            formatButtonTextStyle: const TextStyle(color: Colors.white),
            formatButtonDecoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            titleTextStyle: const TextStyle(color: primaryColor, fontSize: 16),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: secondColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ));
  }

  Widget _buildVisiteTimeline(DateTime selectedDate) {
    final visitesForDay = controller.getVisitesForDay(selectedDate);

    if (visitesForDay.isEmpty) {
      return const Center(child: Text('Aucune visite ce jour-là.'));
    }

    return ListView.builder(
      itemCount: visitesForDay.length,
      itemBuilder: (context, index) {
        final visite = visitesForDay[index];
        return _buildTimelineTile(visite, visitesForDay.length, index);
      },
    );
  }

  Widget _buildTimelineTile(Visite visite, int itemCount, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildTimelineDot(visite.status),
              if (index < itemCount)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visite.type,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nom de client: ${visite.clientName}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nom de contact: ${visite.contactName}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot(String status) {
    Color dotColor;

    switch (status.toLowerCase()) {
      case 'planifiée':
        dotColor = Colors.green;
        break;
      case 'encours':
        dotColor = Colors.orange;
        break;
      case 'cloturée':
        dotColor = Colors.red;
        break;
      default:
        dotColor = Colors.blue;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }

void _showPlanifierVisiteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Détails de la visite planifiée',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Display the selected date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Date de visite:'),
                  Obx(() {
                    final date = controller.selectedDate.value;
                    final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    return Text(
                      formattedDate,
                      style: TextStyle(color: secondColor),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Display the selected client
              Obx(() {
               return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        'Client sélectionné:',
        style: const TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis, 
      ),
    ),
    Expanded(
      child: Text(
        controller.selectedClient.value, 
        style: const TextStyle(fontSize: 14, color: Color(0xffe74c3c)),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end, 
      ),
    ),
  ],
);

              }),
              const SizedBox(height: 16),

              // Display the contact if available
              Obx(() {
                return controller.selectedContact.value.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Contact sélectionné:'),
                          Text(
                            controller.selectedContact.value,
                            style: TextStyle(color: secondColor),
                          ),
                        ],
                      )
                    : const SizedBox(); // Don't show anything if no contact
              }),
              const SizedBox(height: 16),

              // Dropdown for Type selection with label
              const Text(
                'Sélectionnez le type :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedType.value.isEmpty
                        ? null
                        : controller.selectedType.value,
                    hint: const Text('Sélectionnez le type'),
                    underline: SizedBox(), // Hide default underline
                    items: controller.actionsList
                        .map((e) => e.type)
                        .toSet()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newType) {
                      controller.selectedType.value = newType ?? '';
                      controller.selectedAction.value = ''; // Reset the action
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Dropdown for Action selection with label
              const Text(
                'Sélectionnez l\'action :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedAction.value.isEmpty
                        ? null
                        : controller.selectedAction.value,
                    hint: const Text('Sélectionnez l\'action'),
                    underline: SizedBox(), // Hide default underline
                    items: controller
                        .getActionsForSelectedType()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newAction) {
                      controller.selectedAction.value = newAction ?? '';
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondColor,
                    ),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10), // Space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Call the createVisite method from the controller
                      controller.createVisite();
                      Get.back(); // Close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Change color as needed
                    ),
                    child: const Text(
                      'Confirmer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


}