import 'package:drape_shoppe_crm/utils/secrets.dart';
import 'package:postgres/postgres.dart';

class apiController {
  late final Connection connection;
  bool _isConnectionOpen = false; // Track connection state

  apiController._();

  // Factory constructor to handle asynchronous initialization
  static Future<apiController> init() async {
    final dbHelper = apiController._();

    // Open the connection
    dbHelper.connection = await Connection.open(
      Endpoint(
        host: Secrets.dbHost,
        database: Secrets.db,
        username: Secrets.dbUsername,
        password: Secrets.dbpass,
      ),
    );
print(dbHelper.connection);
    dbHelper._isConnectionOpen = true; // Update connection state
    return dbHelper;
  }

  Future<Map<String, dynamic>> createTask({
    required String createdBy,
    required String priority,
    required String title,
    required String description,
    required DateTime dueDate,
    required String status,
    required int progress,
  }) async {
    // Ensure the connection is open
    if (!_isConnectionOpen) {
      connection = await Connection.open(
        Endpoint(
          host: Secrets.dbHost,
          database: Secrets.db,
          username: Secrets.dbUsername,
          password: Secrets.dbpass,
        ),
      );
      _isConnectionOpen = true;
    }

    final result = await connection.execute(
      Sql.named(
        'SELECT * FROM public.create_task(@created_by, @priority, @title, @description, @due_date, @status, @progress)',
      ),
      parameters: {
        'created_by': createdBy,
        'priority': priority,
        'title': title,
        'description': description,
        'due_date': dueDate.toIso8601String(),
        'status': status,
        'progress': progress,
      },
    );

    print(result);
    // Assuming the function returns deal_no and id
    return {
      'deal_no': result.first[0],
      'id': result.first[1],
    };
  }

  // Close connection
  Future<void> closeConnection() async {
    if (_isConnectionOpen) {
      await connection.close();
      _isConnectionOpen = false; // Update connection state
    }
  }
}
