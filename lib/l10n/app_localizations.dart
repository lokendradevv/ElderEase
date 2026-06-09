import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'nav_home': 'Home',
      'nav_med': 'Med',
      'nav_history': 'History',
      'nav_profile': 'Profile',
      
      'profile_title': 'Profile',
      'profile_role_elder': 'ElderEase User',
      'profile_role_caregiver': 'Caregiver',
      'profile_quick_age': 'Age',
      'profile_quick_meds': 'Meds',
      'profile_quick_blood': 'Blood',
      'profile_caregiver_title': 'Caregiver',
      'profile_caregiver_connected': 'Connected',
      'profile_caregiver_pending': 'Pending',
      'profile_btn_manage_caregiver': 'Manage Caregiver',
      'profile_settings_title': 'Settings',
      'profile_settings_notifications': 'Notifications',
      'profile_settings_reminders': 'Reminder Settings',
      'profile_settings_privacy': 'Privacy & Security',
      'profile_settings_language': 'Language',
      'profile_btn_emergency': 'Emergency Contact',
      'profile_btn_logout': 'Log Out',
      
      'dialog_edit_profile': 'Edit Profile',
      'dialog_manage_caregiver': 'Manage Caregiver',
      'dialog_cancel': 'Cancel',
      'dialog_save': 'Save',
    },
    'zh_TW': {
      'nav_home': '首頁',
      'nav_med': '藥物',
      'nav_history': '紀錄',
      'nav_profile': '個人檔案',
      
      'profile_title': '個人檔案',
      'profile_role_elder': 'ElderEase 用戶',
      'profile_role_caregiver': '照護者',
      'profile_quick_age': '年齡',
      'profile_quick_meds': '藥物',
      'profile_quick_blood': '血型',
      'profile_caregiver_title': '照護者',
      'profile_caregiver_connected': '已連結',
      'profile_caregiver_pending': '待處理',
      'profile_btn_manage_caregiver': '管理照護者',
      'profile_settings_title': '設定',
      'profile_settings_notifications': '通知',
      'profile_settings_reminders': '提醒設定',
      'profile_settings_privacy': '隱私與安全',
      'profile_settings_language': '語言',
      'profile_btn_emergency': '緊急聯絡人',
      'profile_btn_logout': '登出',
      
      'dialog_edit_profile': '編輯個人檔案',
      'dialog_manage_caregiver': '管理照護者',
      'dialog_cancel': '取消',
      'dialog_save': '儲存',
    },
  };

  String translate(String key) {
    String languageCode = locale.languageCode;
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      languageCode = 'zh_TW';
    } else if (!_localizedValues.containsKey(languageCode)) {
      languageCode = 'en'; // fallback
    }
    
    return _localizedValues[languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
