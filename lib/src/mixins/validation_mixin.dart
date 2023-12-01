import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:flutter/material.dart';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  String validateEmail(String email) {
    return email.contains('@') ? null : 'قم بادخال بريد الكتروني صحيح';
  }

  String validateUsername(String username) {
    return username.length > 0 ? null : 'قم بادخال اسم المستخدم';
  }

  String validateAdTitle(String title) {
    return title.length > 0 ? null : 'قم بادخال عنوان الإعلان';
  }

  String validatePrice(String price) {
    return price.length > 0 ? null : 'قم بادخال السعر';
  }

  String validateName(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال الاسم';
  }

  String validateCarBrand(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال نوع السيارة';
  }

  String validateCarModel(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال موديل السيارة';
  }

  String validateContactText(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال نص الرسالة';
  }

  String validateContactTitle(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال عنوان الرسالة';
  }

  String validateDescription(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال الوصف';
  }

  String validateCarPlate(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال رقم لوحة السيارة';
  }

  String validateBankAccount(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال رقم الحساب البنكي';
  }

  String validateBankName(String username) {
    return username.length > 0
        ? null
        : 'من فضلك قم بادخال إسم البنك المحول منه';
  }

  String validateStoreName(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال إسم المتجر';
  }

  String validateStoreAddress(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال عنوان المتجر';
  }

  String validateAddress(String address) {
    return address.length > 0 ? null : 'من فضلك قم بادخال العنوان';
  }

  String validateCommercialReg(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال رقم السجل التجاري';
  }

  String validateNationalId(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال رقم الهوية';
  }

  String validateCommercialName(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال الإسم التجاري';
  }

  String validateAccountName(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال إسم الحساب';
  }

  String validateProductName(String username) {
    return username.length > 0 ? null : 'من فضلك قم بادخال إسم المنتج';
  }

  String validateDropdownRegister(dynamic value) {
    return value != 0 ? null : 'قم باختيار البلد';
  }

  String validateDropdownBanks(dynamic value) {
    return value != 0 ? null : 'قم باختيار البنك';
  }

  String validateDropdownCategories(dynamic value) {
    return value != 0 ? null : 'قم باختيار القسم';
  }

  String validateDropdownSubCategories(dynamic value) {
    return value != 0 ? null : 'قم باختيار القسم الفرعي';
  }

  String validateDropdownCities(dynamic value) {
    return value != 0 ? null : 'قم باختيار  المدينة';
  }

  String validateDropdownReasons(dynamic value) {
    return value != 0 ? null : 'قم باختيار نوع الشكوى';
  }

  String validatePhone(String phone) {
    if (phone.length == 0) {
      return '${AppLocalizations.of(context).pleaseEnter} ${AppLocalizations.of(context).phone}';
    } else {
      return null;
    }
  }

  String validateQuestion(String question) {
    return question.length > 0 ? null : 'من فضلك قم بادخال نص السؤال';
  }

  String validateAnswer(String answer) {
    return answer.length > 0 ? null : 'من فضلك قم بادخال نص الاجابة';
  }

  String validatePassword(String password) {
    return password.length > 5
        ? null
        : 'يجب أن تحتوي كلمة المرور على 6 حروف على الاقل';
  }

  String validateOldPassword(String password) {
    return password.length > 0 ? null : 'من فضلك أدخل كلمة المرور القديمة';
  }
}
