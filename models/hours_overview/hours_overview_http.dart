import 'time_data_model.dart';

import '../../http_client.dart';
import '../../models/api-resources/time_entry.dart';

class HoursOverviewHTTP {
  static Future<bool> removeApi(TimeDataModel timeDataModel) async {
    var client = HttpClient();
    try {
      final result = await client.getAuthorizedClient().delete(
          '/api/tenants/${timeDataModel.tenant}/time_entries/${timeDataModel.timeEntry.id}');
      if (result.statusCode == 204) {
        return true;
      }
      return false;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static Future<bool> approveApi(TimeDataModel timeDataModel, States newState) async {
    var client = HttpClient();
    try {
      final data = timeDataModel.timeEntry.toJsonNewState(newState);
      final result = await client.getAuthorizedClient().put(
          '/api/tenants/${timeDataModel.tenant}/time_entries/${timeDataModel.timeEntry.id}',
          data: data);
      if (result.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}
