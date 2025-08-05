import 'dart:ui';

import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//? API ACCESS
final cloudName = dotenv.env['CLOUD_NAME'];
final apiKey = dotenv.env['API_KEY'];
final apiSecret = dotenv.env['API_SECRET'];
final cloudinary = Cloudinary.fromCloudName(cloudName: cloudName!);

//? COLORS
const textLight = Color(0xFFEFEFF8);
const backgroundColor = Color(0xFFFFD795);
const foregroundColor = Color(0xFFFFE1AD);

const lightBrown = Color(0xFF814F2C);
const darkBrown = Color(0xFF603721);

const greenLighter = Color(0xFF4ED018);
const greenLight = Color(0xFF59B334);
const greenDark = Color(0xFF2B6E0F);

const redLighter = Color(0xFFF35F31);
const redLight = Color(0xFFFE3F04);
const redDark = Color(0xFFA74223);

const lightGridColor = Color(0xFFDAB66F);
const darkGridColor = Color(0xFFAD886E);

const lightButtonBackground = Color(0xFF603721);

//? SOUND EFFECTS
const String clickEffect1 = "effects/click_effect1.wav";

//? LOGO
const String logo = "assets/logo/logo.png";

//? ICONS / IMAGES
const String characterIcon = "assets/icons/character.svg";
const String information = "assets/icons/information.svg";
const String menu = "assets/icons/menu.svg";
const String home = "assets/icons/home.svg";
const String setting = "assets/icons/setting.svg";
const String plate = "assets/icons/plate.svg";
const String board1 = "assets/icons/board1.svg";
const String board2 = "assets/icons/board2.svg";
const String bag = "assets/icons/bag.svg";
const String burger = "assets/icons/burger.svg";
const String close = "assets/icons/close.svg";
const String back = "assets/icons/back.svg";
const String basket = "assets/icons/basket.svg";
const String box = "assets/icons/box.svg";
const String trashbag = "assets/icons/trashbag.svg";
const String tap = "assets/icons/tap.svg";

//? ON
const String soundOn = "assets/icons/sound_on.svg";
const String musicOn = "assets/icons/music_on.svg";

//? OFF
const String soundOff = "assets/icons/sound_off.svg";
const String musicOff = "assets/icons/music_off.svg";


const String equipment = "https://res.cloudinary.com/dgvi2di6t/image/upload/v1754402329/equipment_ioey5d.png";
const String plating = "https://res.cloudinary.com/dgvi2di6t/image/upload/v1754402328/plating_jcxuar.png";
const String kaldero = 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753361570/pot_obti4v.png';
