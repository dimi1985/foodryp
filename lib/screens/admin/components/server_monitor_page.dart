import 'package:flutter/material.dart';
import 'package:foodryp/utils/web_socket_service.dart';
import 'package:foodryp/utils/server_monitor_service.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:intl/intl.dart';  // For formatting numbers

class ServerMonitorPage extends StatefulWidget {
  @override
  _ServerMonitorPageState createState() => _ServerMonitorPageState();
}

class _ServerMonitorPageState extends State<ServerMonitorPage> {
  late WebSocketService _webSocketService;
  final ServerMonitorService serverMonitorService = ServerMonitorService(); // Use your server's base URL
  final List<String> _alerts = [];
  Map<String, dynamic> serverStatus = {};
  Map<String, dynamic> databaseStatus = {};
  List<dynamic> backupStatus = [];

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    fetchServerStatus();
    fetchDatabaseStatus();
    fetchBackupStatus();
  }

  void _initializeWebSocket() {
    try {
      _webSocketService = WebSocketService('ws://localhost:3000'); // Use your server's WebSocket URL
      _webSocketService.stream.listen((message) {
        setState(() {
          _alerts.add(message);
        });
      }, onError: (error) {
        print('WebSocket error: $error');
      }, onDone: () {
        print('WebSocket connection closed');
      });
    } catch (e) {
      print('Failed to initialize WebSocket: $e');
    }
  }

  Future<void> fetchServerStatus() async {
    try {
      final status = await serverMonitorService.getServerStatus();
      setState(() {
        serverStatus = status;
      });
    } catch (e) {
      print('Failed to load server status: $e');
    }
  }

  Future<void> fetchDatabaseStatus() async {
    try {
      final status = await serverMonitorService.getDatabaseStatus();
      setState(() {
        databaseStatus = status;
      });
    } catch (e) {
      print('Failed to load database status: $e');
    }
  }

  Future<void> fetchBackupStatus() async {
    try {
      final status = await serverMonitorService.getBackupStatus();
      setState(() {
        backupStatus = status;
      });
    } catch (e) {
      print('Failed to load backup status: $e');
    }
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  String _formatNumber(dynamic number) {
    if (number is num) {
      return NumberFormat.compact().format(number);
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('server_monitor')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServerStatusCard(context),
              SizedBox(height: 20),
              _buildDatabaseStatusCard(context),
              SizedBox(height: 20),
              _buildBackupStatusCard(context),
              SizedBox(height: 20),
              _buildAlertsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerStatusCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('server_status'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            Divider(),
            _buildStatusRow(context, 'uptime', _formatNumber(serverStatus['uptime'] ?? 0)),
            _buildStatusRow(context, 'load_average', serverStatus['loadAverage']?.toString() ?? '-'),
            _buildStatusRow(context, 'memory_usage', _formatNumber(serverStatus['memoryUsage'] ?? 0)),
            _buildStatusRow(context, 'free_memory', _formatNumber(serverStatus['freeMemory'] ?? 0)),
            _buildStatusRow(context, 'total_memory', _formatNumber(serverStatus['totalMemory'] ?? 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseStatusCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('database_status'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            Divider(),
            _buildStatusRow(context, 'status', databaseStatus['dbStatusText'] ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupStatusCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('backup_status'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            Divider(),
            ...backupStatus.map((backup) {
              return ListTile(
                title: Text(
                  backup['file'],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${AppLocalizations.of(context).translate('size')}: ${_formatNumber(backup['size'] ?? 0)} bytes\n${AppLocalizations.of(context).translate('last_modified')}: ${backup['lastModified']}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('alerts'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            Divider(),
            _alerts.isEmpty
                ? Text(AppLocalizations.of(context).translate('no_alerts'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
                : Column(
                    children: _alerts.map((alert) {
                      return ListTile(
                        title: const Text('Alert'),
                        subtitle: Text(alert),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              AppLocalizations.of(context).translate(key),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value?.toString() ?? '-',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
