// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get app_name {
    return Intl.message("Simple chat", name: 'app_name');
  }

  String get notify_header {
    return Intl.message("New message", name: 'notify_header');
  }

  String get notify_body {
    return Intl.message("You have an unread message", name: 'notify_body');
  }

  String get dialog_cancel {
    return Intl.message("Cancel", name: 'dialog_cancel');
  }

  String get dialog_ok {
    return Intl.message("OK", name: 'dialog_ok');
  }

  String get auth_login_not_valid {
    return Intl.message("The Login must be at least 2 characters.", name: 'auth_login_not_valid');
  }

  String get auth_password_not_valid {
    return Intl.message("The Password must be at least 2 characters.", name: 'auth_password_not_valid');
  }

  String get auth_welcome {
    return Intl.message("Welcome", name: 'auth_welcome');
  }

  String get auth_sub_welcome {
    return Intl.message("to the app", name: 'auth_sub_welcome');
  }

  String get auth_login {
    return Intl.message("Login", name: 'auth_login');
  }

  String get auth_enter_login {
    return Intl.message("Enter your login", name: 'auth_enter_login');
  }

  String get auth_password {
    return Intl.message("Password", name: 'auth_password');
  }

  String get auth_enter_password {
    return Intl.message("Enter your password", name: 'auth_enter_password');
  }

  String get auth_input {
    return Intl.message("LogIn", name: 'auth_input');
  }

  String get auth_sign {
    return Intl.message("Sign up", name: 'auth_sign');
  }

  String auth_user_created(user) {
    return Intl.message("User '${user}' created", name: 'auth_user_created', args: [user]);
  }

  String auth_user_fail(message) {
    return Intl.message("Sign up failed: ${message}", name: 'auth_user_fail', args: [message]);
  }

  String get auth_login_fail {
    return Intl.message("Login failed", name: 'auth_login_fail');
  }

  String auth_create_user(username) {
    return Intl.message("Do you want to create user '${username}' ?", name: 'auth_create_user', args: [username]);
  }

  String get tabs_chats {
    return Intl.message("Chats", name: 'tabs_chats');
  }

  String get tabs_friends {
    return Intl.message("Friends", name: 'tabs_friends');
  }

  String get tabs_tab_chat {
    return Intl.message("chats", name: 'tabs_tab_chat');
  }

  String get tabs_tab_friends {
    return Intl.message("friends", name: 'tabs_tab_friends');
  }

  String get load_list_error {
    return Intl.message("An error occurred while loading", name: 'load_list_error');
  }

  String get load_list_repeat {
    return Intl.message("Repeat", name: 'load_list_repeat');
  }

  String get load_list_success {
    return Intl.message("Data updated", name: 'load_list_success');
  }

  String get account {
    return Intl.message("Account", name: 'account');
  }

  String account_id(id) {
    return Intl.message("My id: ${id}", name: 'account_id', args: [id]);
  }

  String get account_name {
    return Intl.message("Name", name: 'account_name');
  }

  String get account_enter_name {
    return Intl.message("Enter your name", name: 'account_enter_name');
  }

  String get account_surname {
    return Intl.message("Surname", name: 'account_surname');
  }

  String get account_enter_surname {
    return Intl.message("Enter your surname", name: 'account_enter_surname');
  }

  String get account_phone {
    return Intl.message("Phone", name: 'account_phone');
  }

  String get account_enter_phone {
    return Intl.message("Enter your phone number", name: 'account_enter_phone');
  }

  String get account_email {
    return Intl.message("E-mail", name: 'account_email');
  }

  String get account_enter_email {
    return Intl.message("Enter your e-mail", name: 'account_enter_email');
  }

  String get account_save {
    return Intl.message("save", name: 'account_save');
  }

  String get account_reset {
    return Intl.message("Reset Info", name: 'account_reset');
  }

  String get chat_enter_message {
    return Intl.message("Your message", name: 'chat_enter_message');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("en", ""),
			Locale("ru", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

// ignore_for_file: unnecessary_brace_in_string_interps
