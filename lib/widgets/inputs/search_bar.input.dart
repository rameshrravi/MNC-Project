import 'package:autocomplete_textfield/autocomplete_textfield.dart' as ac;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class SearchBarInput extends StatelessWidget {
  SearchBarInput({
    this.hintText,
    this.onTap,
    this.onFilterPressed,
    this.onSubmitted,
    this.readOnly = true,
    this.showFilter = false,
    this.search,
    Key? key,
  }) : super(key: key);

  final String? hintText;
  final Function? onTap;
  final Function? onFilterPressed;
  final Function(String)? onSubmitted;
  final bool? readOnly;
  final Search? search;
  final bool? showFilter;

  List<String>? suggestions = [
    "Pizza",
    "t-feel",
    "Coke 50cl",
    "quarter peppered chicken",
    "kellogg's frosties",
    "Dano full cream",
    "creamy toffes",
    "dettol",
    "Advil Easy",
    "Rits bits",
    "Seafood pasta",
    "Single Chicken Burger",
    "Beef Shawarma",
    "Hypo Bleach",
    "Sunlight Gentle Fabric",
    "Quarter Southern BBQ Chicken",
    "Fanta 50cl",
    "Sprite 50cl",
    "Double Chicken Burger",
    "Maryland Cookies",
    "TUC Original",
    "Breakfast Burger",
    "Double Smoked Turkey Burger",
    "Chicken Burger",
    "Beef Burger",
    "Southern BBQ Chicken",
    "Peppered Chicken",
    "Peppered Turkey Wings",
    "BBQ Chicken Wings",
    "Peppered Chicken Wings",
    "Honey Glazed Chicken Wings",
    "Bacon cheese fries",
    "Chili Fries",
    "Sweet potato fries",
    "Plantain and Prawn’s on skewers",
    "Yam Chips",
    "Plantain",
    "Jollof Rice",
    "Fried Rice",
    "Small Chops",
    "White Rice and Beef Stew",
    "Ofada Rice and Sauce",
    "Catfish pepper soup",
    "Spring rolls.",
    "Midnight City Platter",
    "Beef and Seafood Stir Fry",
    "Meat Lovers Stir Fry",
    "Seafood stir fry",
    "Noodles",
    "T feel",
    "Club Sandwich",
    "Egg Bacon & Cheese Sandwich",
    "Hotdog",
    "Chicken Shawarma",
    "Beef Shawarma",
    "Mixed Shawarma",
    "Midnight City Turkey Wrap",
    "Suya Box",
    "Disposable Red Cups (50 pcs)",
    "Small Disposable Cups",
    "Nestle Water",
    "Coke",
    "Fanta",
    "Sprite",
    "Malta Guinness",
    "Schweppes Chapman",
    "Schweppes Mojito",
    "Scheweppes Zobo",
    "Schweppes Tonic",
    "Ceres Sparkling Red Grape",
    "Purdey's Rejuvenate Grape",
    "Pure Heaven",
    "Ceres Sparkling Apple",
    "Four Cousins Sweet White Wine",
    "Four Cousins Sweet Red Wine",
    "Carlo Rossi Sweet Red Wine",
    "Carlo Rossi Rose Wine",
    "Carlo Rossi Red Wine",
    "Carlo Rossi White Wine",
    "Martini Prosecco",
    "Martini Rose",
    "Moet & Chandon Rose",
    "Bic Lighter",
    "Raw Papers with Tips",
    "Raw Papers",
    "Plastic Herb Crusher",
    "Pringles Original",
    "Pringles Sour Cream & Onion",
    "Pringles Hot & Spicy",
    "Pringles Original",
    "Pringles Sour Cream & Onion",
    "Pringles Texas BBQ Sauce",
    "Munch It Sweet",
    "Munch It Classic",
    "Munch It Creamy",
    "Singleton Whiskey",
    "Glenfiddich 12 Years",
    "Chivas XV 15 Years",
    "Hennessy XO",
    "Hennessy VSOP",
    "Hennessy VS",
    "Hennessy VS",
    "Martel Blue Swift",
    "Martel VSSD",
    "Don Julio 1942",
    "Clase Azul Reposado Tesquila",
    "Olmeca Chocolate",
    "Bacardi Gold Rum",
    "Bacardi Spiced Rum",
    "Bacardi Carta Blanca",
    "Famous Amos Cookies",
    "Fox's Milk Chocolate Cookies",
    "Fox's White Chocolate Cookies",
    "Fox's Triple Chocolate Cookies",
    "Fox's Half Coated Chunkie Cookies",
    "Maryland Choc Chip Cookies",
    "Maryland Double Choc Chip Cookie",
    "McVities Original Digestives",
    "McVities Rich Tea",
    "Mars Chocolate Bar",
    "Mars Miniatures",
    "Bounty Milk Twin",
    "Snickers Chocolate Bar",
    "Snickers Miniatures",
    "KitKat Original",
    "Dairy Mild Plain",
    "Dairy Milk Fruit n' Nut",
    "Dairy Milk Wholenut",
    "Nivea Original Lip Balm",
    "Colgate Total Care Medium Tooth Brush",
    "Angel Cotton Bud Swabs",
    "2sure Hand Sanitizer Gel",
    "2sure Hand Sanitizer Liquid",
    "Neutrogena Makeup Remover",
    "Lightly Salted Ripe Plantain Chips",
    "Chilli Ripe Plantain Chips",
    "Sweet Cinnamon Ripe Plantain Chips",
    "Lightly Salted Un-Ripe Plantain Chips",
    "Chilli Un-Ripe Plantain Chips",
    "Roasted Gralic Un-Ripe Plantain Chips",
    "Classic Sweet Potato Crisps",
    "Onion Sweet Potato Cristps",
    "Minimie Chin Chin",
    "Pineapple and coconut extract",
    "Lime juice",
    "Rum",
    "Blue curacao",
    "Whiskey",
    "Grenadine",
    "Blue curacao",
    "Fresh lime juice",
    "Red wine",
    "Berry syrup",
    "Vodka",
    "Fresh watermelon",
    "Passion fruit extract",
    "Pineapple juice",
    "Passion fruit liqueur",
    "Tropical juice",
    "Guava extract",
    "Pineapple extract",
    "Guava juice",
    "Blue curacao",
    "Sprite",
    "Fresh Lime juice",
    "Orange extract",
    "Mango extract",
    "Fanta",
    "Sprite",
    "Grenadine",
    "Angustora bitters",
    "Caramel syrup",
    "Pineapple juice",
    "Orange extract",
    "Guava extract",
    "Lime juice",
    "Strawberry popsicles",
    "Mango popsicles",
    "Orange popsicles",
    "durex Featherlite condoms (3pcs)"
  ];

  List<String> added = [];
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
/*
        SimpleAutoCompleteTextField(
        key: key,
        decoration: InputDecoration(errorText: "Beans"),
    controller: TextEditingController(text: "Starting Text"),
    suggestions: suggestions,
    textChanged: (text) => currentText = text,
    clearOnSubmit: true,
    textSubmitted: (text) {
    },
    ),*/
        ac.SimpleAutoCompleteTextField(
          key: AppService().key,
          style: TextStyle(color: Colors.black),
          controller: TextEditingController(text: ""),
          // readOnly: readOnly,
          /*  onTap: search != null
              ? () {
                  //pages
                  final page = NavigationService().searchPageWidget(search);
                  context.nextPage(page);
                }
              : onTap,*/
          textChanged: (text) => currentText = text,

          clearOnSubmit: false,
          textSubmitted: onSubmitted,

          suggestions: suggestions!,
          decoration: InputDecoration(
              hintText: hintText ?? "Search".tr(),
              hintStyle: context.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w100,
                color: Colors.grey,
              ),
              labelStyle: context.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w100,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                FlutterIcons.search_fea,
                //Icons.abc_sharp,
                size: 20,
                color: Colors.grey,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              filled: true,
              fillColor: Colors.grey.shade100),
        )
            .box
            .black
            .outerShadowSm
            .roundedSM
            .clip(Clip.antiAlias)
            .make()
            .expand(),
        Visibility(
          visible: showFilter ?? true,
          child: HStack(
            [
              UiSpacer.horizontalSpace(),
              //filter icon
              IconButton(
                onPressed: null,
                color: context.backgroundColor,
                icon: Icon(
                  FlutterIcons.sliders_faw,
                  color: context.primaryColor,
                  size: 20,
                ),
              )
                  .onInkTap(onFilterPressed as VoidCallback?)
                  .material(color: context.backgroundColor)
                  .box
                  .color(context.backgroundColor)
                  .outerShadowSm
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .make(),
            ],
          ),
        ),
      ],
    );
  }
}
