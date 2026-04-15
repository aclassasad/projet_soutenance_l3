import 'package:flutter/material.dart';
import 'employee_service.dart';

class EmployeeDetailPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EmployeeDetailPage({required this.user, super.key});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  List<Map<String, dynamic>> ventes = [];
  bool loadingVentes = true;

  @override
  void initState() {
    super.initState();
    if (widget.user["role"] == "caissier") {
      _loadVentes();
    }
  }

  Future<void> _loadVentes() async {
    try {
      final data = await EmployeeService.getEmployeeSales(widget.user["id"]);
      setState(() {
        ventes = data;
        loadingVentes = false;
      });
    } catch (e) {
      setState(() => loadingVentes = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  String _getInitials() {
    final name = widget.user["name"] ?? "??";
    if (name.isEmpty) return "??";
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String _getRoleLabel() {
    final role = widget.user["role"];
    switch (role) {
      case "admin": return "Administrateur";
      case "gerant": return "Gérant";
      case "caissier": return "Caissier";
      default: return role?.toUpperCase() ?? "Inconnu";
    }
  }

  Color _getRoleColor() {
    final role = widget.user["role"];
    switch (role) {
      case "admin": return const Color(0xFFEF4444);
      case "gerant": return const Color(0xFFF59E0B);
      case "caissier": return const Color(0xFF4361EE);
      default: return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statut = (widget.user["statut"] == 1 || widget.user["statut"] == "1");
    final statutLabel = statut ? "Actif" : "En congé";
    final role = widget.user["role"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Détails Employé",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF64748B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte d'informations employé
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _getRoleColor().withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _getRoleColor(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nom
                    Text(
                      widget.user["name"] ?? "Sans nom",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Badge rôle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getRoleColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getRoleLabel(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getRoleColor(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Badge statut
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statut
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: statut ? const Color(0xFF10B981) : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            statutLabel,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: statut ? const Color(0xFF10B981) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    const Divider(),
                    const SizedBox(height: 12),
                    
                    // Email
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.email_outlined, size: 18, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.user["email"] ?? "Non renseigné",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Téléphone
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.phone_outlined, size: 18, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Téléphone",
                                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.user["telephone"] ?? "Non renseigné",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Date d'inscription
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date d'inscription",
                                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.user["created_at"] ?? "Non renseignée",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    if (widget.user["horaire"] != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.access_time_outlined, size: 18, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Horaire",
                                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.user["horaire"],
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text("Retour"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/employees/edit",
                        arguments: widget.user,
                      );
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Modifier"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4361EE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section ventes (uniquement pour les caissiers)
            if (role == "caissier") ...[
              const Text(
                "Historique des ventes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: loadingVentes
                    ? const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFF4361EE)),
                        ),
                      )
                    : ventes.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.receipt_outlined, size: 48, color: Color(0xFF94A3B8)),
                                  SizedBox(height: 12),
                                  Text(
                                    "Aucune vente trouvée",
                                    style: TextStyle(color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ventes.length,
                            itemBuilder: (context, i) {
                              final v = ventes[i];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade100),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4361EE).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: Color(0xFF4361EE),
                                    ),
                                  ),
                                  title: Text(
                                    "Vente #${v['id']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${(v['lignes'] ?? []).length} article(s)",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${v['total']} FCFA",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                      const Text(
                                        "Détails >",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF4361EE),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        final lignes = v['lignes'] ?? [];
                                        final totalGeneral = double.tryParse(v['total'].toString()) ?? 0.0;

                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          title: Text(
                                            "Détails Vente #${v['id']}",
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: lignes.length,
                                                    itemBuilder: (context, j) {
                                                      final ligne = lignes[j];
                                                      final produit = ligne['produit'] ?? {};
                                                      final quantite = int.tryParse(ligne['quantite'].toString()) ?? 0;
                                                      final prixUnitaire = double.tryParse(ligne['prix_unitaire'].toString()) ?? 0.0;
                                                      final sousTotal = quantite * prixUnitaire;

                                                      return ListTile(
                                                        leading: Container(
                                                          width: 36,
                                                          height: 36,
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFF10B981).withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: const Icon(
                                                            Icons.shopping_cart,
                                                            size: 18,
                                                            color: Color(0xFF10B981),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          produit['nom'] ?? "Produit inconnu",
                                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                                        ),
                                                        subtitle: Text("Quantité : $quantite"),
                                                        trailing: Text("$sousTotal FCFA"),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    "Total : ${totalGeneral.toStringAsFixed(0)} FCFA",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xFF4361EE),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("Fermer"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}