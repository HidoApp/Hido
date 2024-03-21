import 'package:ajwad_v4/localization/locale_ar.dart';
import 'package:ajwad_v4/localization/locale_en.dart';
import 'package:get/get.dart';



class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {'ar_AR': localeAr, 'en_US': localeEn};
}
