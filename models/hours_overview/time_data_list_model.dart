import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/api-resources/pagination.dart';
import '../../models/api-resources/time_entry.dart';
import 'hours_overview_http.dart';
import 'time_data_model.dart';

@immutable
class TimeDataListState {
  const TimeDataListState(
      {required this.list,
      required this.meta,
      this.hasNext = false,
      this.isLoading = true});

  final Map<DateTime, List<TimeDataModel>> list;
  final PaginationMetaData meta;
  final bool hasNext;
  final bool isLoading;

  TimeDataListState copyWith(
      {Map<DateTime, List<TimeDataModel>>? list,
      PaginationMetaData? meta,
      bool? hasNext,
      required bool isLoading}) {
    return TimeDataListState(
        list: list ?? this.list,
        meta: meta ?? this.meta,
        hasNext: hasNext ?? this.hasNext,
        isLoading: isLoading);
  }
}

class TimeDataListStateNotifier extends StateNotifier<TimeDataListState> {
  TimeDataListStateNotifier(TimeDataListState state) : super(state);

  void startLoadingNextPage() {
    state = state.copyWith(isLoading: true);
  }

  void finishLoadingNextPage(Map<DateTime, List<TimeDataModel>> list,
      PaginationMetaData meta, bool hasNext) {
    state = state.copyWith(
        list: list, meta: meta, hasNext: hasNext, isLoading: false);
  }

  Future<bool> removeTimeEntry(
      DateTime date, TimeDataModel timeDataModel) async {
    DateTime key = DateUtils.dateOnly(date);
    Map<DateTime, List<TimeDataModel>> mapCopy = Map.from(state.list);
    bool isRemoved = await HoursOverviewHTTP.removeApi(timeDataModel);
    if (isRemoved) {
      final list = mapCopy[key] as List<TimeDataModel>;
      list.removeWhere(
          (element) => element.timeEntry.id == timeDataModel.timeEntry.id);
      if (list.isEmpty) {
        mapCopy.removeWhere((checkKey, value) => checkKey == key);
      }
      state = state.copyWith(list: mapCopy, isLoading: false);
      return true;
    } else {
      return false;
    }
  }

  Future<void> completeTimeEntry(
      DateTime date, TimeDataModel timeDataModel) async {
    DateTime key = DateUtils.dateOnly(date);
    Map<DateTime, List<TimeDataModel>> mapCopy = Map.from(state.list);
    final list = mapCopy[key] as List<TimeDataModel>;
    var item = list
        .where((element) => element.timeEntry.id == timeDataModel.timeEntry.id)
        .first;
    final newState = item.timeEntry.state == States.complete
        ? States.approved
        : States.complete;
    bool isUpdated =
        await HoursOverviewHTTP.approveApi(timeDataModel, newState);
    if (isUpdated) {
      item = item.copyWith(timeEntry: item.timeEntry.copyWith(state: newState));
      list[list.indexWhere((tdm) =>
          tdm.timeEntry.id == timeDataModel.timeEntry.id)] = item;
      state = state.copyWith(list: mapCopy, isLoading: false);
    }
  }

  void refreshState() {
    state = state.copyWith(
        list: {},
        meta: PaginationMetaData(currentPage: 1, total: 0, lastPage: 1),
        isLoading: true);
  }
}

final timeDataListStateProvider =
    StateNotifierProvider<TimeDataListStateNotifier, TimeDataListState>((ref) {
  return TimeDataListStateNotifier(TimeDataListState(
      list: const {},
      meta: PaginationMetaData(currentPage: 1, total: 0, lastPage: 1)));
});

final timeDataListProvider =
    Provider<Map<DateTime, List<TimeDataModel>>>((ref) {
  return ref.watch(timeDataListStateProvider.select((value) => value.list));
});

final timeDataListIsLoadingProvider = Provider<bool>((ref) {
  return ref
      .watch(timeDataListStateProvider.select((value) => value.isLoading));
});
