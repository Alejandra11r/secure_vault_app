import 'package:secure_vault_app/core/workers/data_worker.dart';

class DataRepository {
  final DataWorker _worker = DataWorker();

  Future<void> init() async {
    await _worker.init();
  }

  Future<List<String>> getProcessedData(String json) async {
    return await _worker.processJson(json);
  }

  void dispose() {
    _worker.dispose();
  }
}