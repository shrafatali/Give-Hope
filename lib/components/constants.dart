import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColor {
  static Color blackColor = const Color.fromRGBO(12, 10, 34, 1);
  static Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color pagesColor = const Color.fromRGBO(235, 235, 235, 1);
  static Color fonts = const Color(0XFF504B4D);

  static Color primaryColor = const Color(0xff471a91);
}

class Constants {
  static SharedPreferences? prefs;
}

// flutter build apk --split-per-abi

var phoneNumberFormatter = MaskTextInputFormatter(
    mask: '+92##########',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var cnicNumberFormatter = MaskTextInputFormatter(
    mask: '#####-#######-#',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

List<Map<String, dynamic>> donationCategoryList = [
  {"name": "Books", "image": "assets/images/book.png"},
  {"name": "Blood", "image": "assets/images/medical-check.png"},
  {"name": "Clothing", "image": "assets/images/brand.png"},
  {"name": "Food", "image": "assets/images/fast-food.png"},
  {"name": "Medicine", "image": "assets/images/drugs.png"},
  {"name": "Toys", "image": "assets/images/toys.png"}
];

List donationCategoryList1 = [
  "Books",
  "Blood",
  "Clothing",
  "Food",
  "Medicine",
  "Toys",
];

List<String> occupationsList = [
  "Doctor",
  "Engineer",
  "Lawyer",
  "CEO",
  "Architect",
  "Scientist",
  "Artist",
  "Writer",
  "Entrepreneur",
  "Teacher",
  "Manager",
  "Accountant",
  "Designer",
  "Consultant",
  "officer",
  "Pilot",
  "Musician"
];

List<String> cityList = [
  "Karachi",
  "Lahore",
  "Faisalabad",
  "Rawalpindi",
  "Gujranwala",
  "Peshawar",
  "Multan",
  "Hyderabad",
  "Islamabad",
  "Quetta",
  "Bahawalpur",
  "Sargodha",
  "Sialkot",
  "Sukkur",
  "Larkana",
  "Rahim Yar Khan",
  "Sheikhupura",
  "Jhang",
  "Dera Ghazi Khan",
  "Gujrat",
  "Sahiwal",
  "Wah Cantonment",
  "Mardan",
  "Kasur",
  "Okara",
  "Mingora",
  "Nawabshah",
  "Chiniot",
  "Kotri",
  "Kāmoke",
  "Hafizabad",
  "Sadiqabad",
  "Mirpur Khas",
  "Burewala",
  "Kohat",
  "Khanewal",
  "Dera Ismail Khan",
  "Turbat",
  "Muzaffargarh",
  "Abbottabad",
  "Mandi Bahauddin",
  "Shikarpur",
  "Jacobabad",
  "Jhelum",
  "Khanpur",
  "Khairpur",
  "Khuzdar",
  "Pakpattan",
  "Hub",
  "Daska",
  "Gojra",
  "Dadu",
  "Muridke",
  "Bahawalnagar",
  "Samundri",
  "Tando Allahyar",
  "Tando Adam",
  "Jaranwala",
  "Chishtian",
  "Muzaffarabad",
  "Attock",
  "Vehari",
  "Kot Abdul Malik",
  "Ferozwala",
  "Chakwal",
  "Gujranwala Cantonment",
  "Kamalia",
  "Umerkot",
  "Ahmedpur East",
  "Kot Addu",
  "Wazirabad",
  "Mansehra",
  "Layyah",
  "Mirpur",
  "Swabi",
  "Chaman",
  "Taxila",
  "Nowshera",
  "Khushab",
  "Shahdadkot",
  "Mianwali",
  "Kabal",
  "Lodhran",
  "Hasilpur",
  "Charsadda",
  "Bhakkar",
  "Badin",
  "Arif Wala",
  "Ghotki",
  "Sambrial",
  "Jatoi",
  "Haroonabad	",
  "Daharki",
  "Narowal",
  "Tando Muhammad Khan",
  "Kamber Ali Khan",
  "Mirpur Mathelo",
  "Kandhkot",
  "Bhalwal"
];
