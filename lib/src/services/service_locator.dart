import 'package:get_it/get_it.dart';
import 'package:miincode/src/services/calls_and_messages_service.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}