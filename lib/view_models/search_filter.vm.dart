import 'package:flutter/material.dart';
import 'package:midnightcity/models/search_data.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/requests/search.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';

class SearchFilterViewModel extends MyBaseViewModel {
  //
  SearchRequest _searchRequest = SearchRequest();
  SearchData? searchData;
  String? keyword = "";
  Search search;
  int? selectTagId = 2;
  bool? filterByProducts = true;

  SearchFilterViewModel(BuildContext context, this.search) {
    this.viewContext = context;
    this.vendorType = this.search.vendorType;
    //
    fetchSearchData();
  }

  fetchSearchData() async {
    //
    if (searchData != null) {
      return;
    }

    //
    try {
      setBusyForObject(searchData, true);
      searchData = await _searchRequest.getSearchFilterData(
        vendorTypeId: search?.vendorType?.id,
      );
    } catch (error) {
      toastError("$error");
    }
    setBusyForObject(searchData, false);
  }
}
