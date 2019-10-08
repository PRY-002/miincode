import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {

  void call(String number) => launch("tel://$number");

  void sendSms(String number) => launch("sms:$number");

  void sendEmail(String email) => launch("mailto:$email");

}

/* 
  FUENTE DE APOYO: 
    https://medium.com/flutter-community/flutter-making-phone-calls-sending-sms-and-emails-with-url-launcher-56414b06f84e 
*/