import 'package:get/get.dart';

import '../modules/addcommande/bindings/addcommande_binding.dart';
import '../modules/addcommande/views/addcommande_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/clients/bindings/clients_binding.dart';
import '../modules/clients/views/clients_view.dart';
import '../modules/commandes/bindings/commandes_binding.dart';
import '../modules/commandes/views/commandes_view.dart';
import '../modules/details/bindings/details_binding.dart';
import '../modules/details/views/details_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/newcommande/bindings/newcommande_binding.dart';
import '../modules/newcommande/views/newcommande_view.dart';
import '../modules/status/bindings/status_binding.dart';
import '../modules/status/views/status_view.dart';
import '../modules/visite/bindings/visite_binding.dart';
import '../modules/visite/views/visite_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CLIENTS,
      page: () => const ClientsView(),
      binding: ClientsBinding(),
    ),
    GetPage(
      name: _Paths.COMMANDES,
      page: () => const CommandesView(),
      binding: CommandesBinding(),
    ),
    GetPage(
      name: _Paths.DETAILS,
      page: () => const DetailsView(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADDCOMMANDE,
      page: () => const AddcommandeView(),
      binding: AddcommandeBinding(),
    ),
    GetPage(
      name: _Paths.NEWCOMMANDE,
      page: () => const NewcommandeView(),
      binding: NewcommandeBinding(),
    ),
    GetPage(
      name: _Paths.STATUS,
      page: () => const StatusView(),
      binding: StatusBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: _Paths.VISITE,
      page: () => const VisiteView(),
      binding: VisiteBinding(),
    ),
  ];
}
