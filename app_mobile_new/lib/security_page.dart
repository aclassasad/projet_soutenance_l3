import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'security_service.dart';
import 'loading_widget.dart';
import 'theme_provider.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> incidents = [];
  List<Map<String, dynamic>> incidentStats = [];
  bool loading = true;
  
  // États locaux pour la sécurité
  bool _motionDetectionEnabled = true;
  bool _alarmActive = false;
  bool _isTogglingMotion = false;
  bool _isTogglingAlarm = false;

  @override
  void initState() {
    super.initState();
    _loadSecurityData();
    ThemeProvider.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeProvider.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadSecurityData() async {
    try {
      final statsData = await SecurityService.getSecurityStats();
      final incidentsData = await SecurityService.getIncidents();
      final incidentStatsData = await SecurityService.getIncidentStats();
      setState(() {
        stats = statsData;
        incidents = incidentsData;
        incidentStats = incidentStatsData;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getSystemStatus() {
    final status = stats?['system_status']?.toString() ?? "Inconnu";
    if (status == "OK") return "Sécurisé";
    if (status == "Warning") return "Alerte";
    if (status == "Critical") return "Critique";
    return status;
  }

  Color _getStatusColor() {
    final status = stats?['system_status']?.toString() ?? "";
    if (status == "OK") return Colors.green;
    if (status == "Warning") return Colors.orange;
    if (status == "Critical") return Colors.red;
    return Colors.grey;
  }

  String _getSeverityText(String severity) {
    switch (severity.toLowerCase()) {
      case "high": return "ÉLEVÉE";
      case "medium": return "MOYENNE";
      case "low": return "FAIBLE";
      default: return severity.toUpperCase();
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case "high": return Colors.red;
      case "medium": return Colors.orange;
      case "low": return Colors.green;
      default: return Colors.grey;
    }
  }

  Future<void> _toggleMotionDetection() async {
    setState(() => _isTogglingMotion = true);
    try {
      final newState = !_motionDetectionEnabled;
      await SecurityService.toggleMotionDetection(newState);
      setState(() => _motionDetectionEnabled = newState);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_motionDetectionEnabled 
              ? "Détection de mouvement activée" 
              : "Détection de mouvement désactivée"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF4361EE),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isTogglingMotion = false);
    }
  }

  Future<void> _toggleAlarm() async {
    setState(() => _isTogglingAlarm = true);
    try {
      final newState = !_alarmActive;
      await SecurityService.toggleAlarm(newState);
      setState(() => _alarmActive = newState);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_alarmActive 
              ? "Alarme activée" 
              : "Alarme désactivée"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: _alarmActive ? Colors.red : const Color(0xFF4361EE),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isTogglingAlarm = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';
    
    if (loading) {
      return const LoadingWidget(
        message: "Chargement de la sécurité...",
        backgroundColor: Color(0xFF4361EE),
      );
    }

    final systemStatus = _getSystemStatus();
    final statusColor = _getStatusColor();

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Surveillance de sécurité",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
            onPressed: _loadSecurityData,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sous-titre
            Text(
              "Surveillez la sécurité de votre magasin",
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            // Section indicateurs clés
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4361EE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "État du système",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Carte État du système
            _buildSystemStatusCard(systemStatus, statusColor, isDarkMode),
            const SizedBox(height: 12),

            // Carte Détection de mouvement
            _buildMotionDetectionCard(isDarkMode),
            const SizedBox(height: 12),

            // Carte Alarme
            _buildAlarmCard(isDarkMode),
            const SizedBox(height: 12),

            // Carte Incidents actifs
            _buildStatCard(
              "Incidents actifs",
              stats?['active_incidents']?.toString() ?? "0",
              "À traiter",
              const Color(0xFFEF4444),
              Icons.warning,
              isDarkMode,
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 24),

            // Section incidents récents
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4361EE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Incidents récents",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            incidents.isEmpty
                ? _buildEmptyIncidentsState(isDarkMode)
                : _buildIncidentsList(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard(String status, Color statusColor, bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "État du système",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Statut général",
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [statusColor, statusColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.security, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotionDetectionCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Détection de mouvement",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _motionDetectionEnabled ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _motionDetectionEnabled ? "Activé" : "Désactivé",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _motionDetectionEnabled ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: _motionDetectionEnabled,
              onChanged: _isTogglingMotion ? null : (_) => _toggleMotionDetection(),
              activeColor: const Color(0xFF4361EE),
              activeTrackColor: const Color(0xFF4361EE).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alarme",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        size: 16,
                        color: _alarmActive ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _alarmActive ? "Active (sonne)" : "Inactive",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _alarmActive ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: _alarmActive,
              onChanged: _isTogglingAlarm ? null : (_) => _toggleAlarm(),
              activeColor: Colors.red,
              activeTrackColor: Colors.red.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color color, IconData icon, bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentsList(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: incidents.length,
      itemBuilder: (context, index) {
        final i = incidents[index];
        final severity = i['severity'] ?? "medium";
        final severityText = _getSeverityText(severity);
        final severityColor = _getSeverityColor(severity);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: severityColor.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: severityColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showIncidentDetails(i, isDarkMode),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: severityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          i['description'] ?? "Sans description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          severityText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        i['location'] ?? "N/A",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today_outlined, size: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        i['date'] ?? "N/A",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Appuyez pour plus de détails >",
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF4361EE),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showIncidentDetails(Map<String, dynamic> incident, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Détails de l'incident",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow("Description", incident['description'] ?? "Non spécifiée", isDarkMode),
            _buildDetailRow("Localisation", incident['location'] ?? "Non spécifiée", isDarkMode),
            _buildDetailRow("Date", incident['date'] ?? "Non spécifiée", isDarkMode),
            _buildDetailRow("Sévérité", _getSeverityText(incident['severity'] ?? "medium"), isDarkMode),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await SecurityService.investigateIncident(incident['id'] ?? 0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Incident ${incident['id'] ?? "?"} en investigation"),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xFF4361EE),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4361EE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Enquêter"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label :",
              style: TextStyle(color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyIncidentsState(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            "Aucun incident signalé",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tout est sous contrôle",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}