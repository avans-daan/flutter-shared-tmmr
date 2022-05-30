import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api-resources/pagination.dart';
import '../api-resources/time_entry.dart';
import '../../http_client.dart';
import 'time_data_list_model.dart';

import '../../models/user_tenants.dart';

@immutable
class TimeDataModel {
  const TimeDataModel(
      {required this.timeEntry, required this.tenant, required this.target});

  final TimeEntry timeEntry;
  final String tenant;
  final String target;

  TimeDataModel copyWith({
    TimeEntry? timeEntry,
    String? tenant,
    String? target,
  }) {
    return TimeDataModel(
        timeEntry: timeEntry ?? this.timeEntry,
        tenant: tenant ?? this.tenant,
        target: target ?? this.target);
  }
}

class TimeDataListNotifier {
  static final provider = FutureProvider<TimeDataListState>((ref) async {
    var selectedTenant = ref.watch(UserSelectedTenantNotifier.provider);
    final timeDataList = ref.read(timeDataListStateProvider);

    if (selectedTenant == null) {
      return TimeDataListState(
          list: const {},
          meta: PaginationMetaData(currentPage: 1, total: 0, lastPage: 1));
    }

    final currentPage =
        timeDataList.meta.currentPage + 1 < timeDataList.meta.lastPage
            ? timeDataList.meta.currentPage + 1
            : timeDataList.meta.lastPage;
    final timeEntryResponse = await HttpClient().getAuthorizedClient().get(
        '/api/tenants/${selectedTenant.id}/time_entries?page=$currentPage');

    final timeEntryData = timeEntryResponse.data['data'] as List;
    final timeEntries = timeEntryData.map((value) {
      var test = TimeEntry.fromJson(value);
      return test;
    }).toList();

    final paginationMetaData =
        PaginationMetaData.fromJson(timeEntryResponse.data['meta']);

    Map<DateTime, List<TimeDataModel>> models = Map.from(timeDataList.list);
    for (var timeEntry in timeEntries) {
      var date = DateUtils.dateOnly(timeEntry.start);
      var timeDataModel = TimeDataModel(
          timeEntry: timeEntry,
          tenant: selectedTenant.id,
          target: timeEntry.target?.name ?? '');
      if (models.containsKey(date)) {
        models[date]?.add(timeDataModel);
      } else {
        models[date] = [timeDataModel];
      }
    }

    final data = TimeDataListState(
        list: SplayTreeMap.from(models, (val1, val2) {
          return val1.compareTo(val2) * -1;
        }),
        meta: paginationMetaData);
    ref.read(timeDataListStateProvider.notifier).finishLoadingNextPage(
        models, data.meta, currentPage != paginationMetaData.lastPage);
    return data;
  });
}
