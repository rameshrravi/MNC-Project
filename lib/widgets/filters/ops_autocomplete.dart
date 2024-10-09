import 'package:flutter/material.dart';
import 'package:midnightcity/models/address.dart';
import 'package:midnightcity/view_models/ops_map.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OPSAutocompleteTextField extends StatelessWidget {
  const OPSAutocompleteTextField({
    this.onselecteds,
    this.textEditingController,
    this.inputDecoration,
    this.debounceTime,
    Key? key,
  }) : super(key: key);

  final Function(Address)? onselecteds;
  final TextEditingController? textEditingController;
  final InputDecoration? inputDecoration;
  final int? debounceTime;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OPSMapViewModel>.reactive(
      viewModelBuilder: () => OPSMapViewModel(context),
      builder: (ctx, vm, child) {
        return TypeAheadField<Address>(
          suggestionsCallback: (search) => vm.fetchPlaces(search),
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter your address...".tr(),
                ));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: suggestion.addressLine!.text.base.semiBold.make(),
              subtitle: suggestion.adminArea!.text.sm.make(),
            );
          },
          onSelected: (address) async {
            final mAddress = await vm.fetchPlaceDetails(address);
            this.onselecteds!(mAddress);
          },
        );
      },
    );
  }
}
