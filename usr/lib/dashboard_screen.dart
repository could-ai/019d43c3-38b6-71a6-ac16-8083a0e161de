import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analyse PM10 : Dakar & Banlieue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
            tooltip: 'Informations sur les données',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Contexte
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade200),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.air, color: Colors.blueGrey, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contexte Environnemental',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Les concentrations de PM10 à Dakar dépassent souvent les normes de l\'OMS (20 µg/m³), avec des facteurs de dépassement de 6 à 9 fois. Les pics sont observés durant la saison sèche (novembre à mars) à cause de l\'harmattan et des activités anthropiques (trafic, industries en banlieue).',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Indicateurs Clés (Moyennes Annuelles)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Cartes de statistiques (KPIs)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      Expanded(child: _buildStatCard('Moyenne Dakar', '145 µg/m³', '7x la norme', Icons.location_city, Colors.orange)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('Moyenne Banlieue', '178 µg/m³', '9x la norme', Icons.factory, Colors.red)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('Seuil OMS', '20 µg/m³', 'Limite saine', Icons.health_and_safety, Colors.green)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildStatCard('Moyenne Dakar', '145 µg/m³', '7x la norme', Icons.location_city, Colors.orange),
                      const SizedBox(height: 16),
                      _buildStatCard('Moyenne Banlieue (ex: HLM)', '178 µg/m³', '9x la norme', Icons.factory, Colors.red),
                      const SizedBox(height: 16),
                      _buildStatCard('Seuil OMS', '20 µg/m³', 'Limite saine', Icons.health_and_safety, Colors.green),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            
            // Graphique principal
            const Text(
              'Variation Mensuelle du PM10 (µg/m³)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comparaison entre le centre de Dakar et la banlieue sur une année type.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              height: 350,
              padding: const EdgeInsets.only(right: 24, left: 8, top: 24, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildLineChart(),
            ),
            const SizedBox(height: 16),
            // Légende du graphique
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.orange, 'Dakar Centre'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.red, 'Banlieue (Zones Industrielles)'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Seuil OMS (20 µg/m³)', isDashed: true),
              ],
            ),
            const SizedBox(height: 32),

            // Tableau de données par zone
            const Text(
              'Répartition par Zones (Données estimées)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Text('Zone', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Moyenne PM10', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Pic Saison Sec', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Niveau de Risque', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildDataRow('Dakar Plateau', 'Centre Urbain', '110 µg/m³', '160 µg/m³', 'Élevé', Colors.orange),
                    _buildDataRow('HLM', 'Banlieue / Mixte', '165 µg/m³', '210 µg/m³', 'Très Élevé', Colors.deepOrange),
                    _buildDataRow('Pikine', 'Banlieue Dense', '150 µg/m³', '195 µg/m³', 'Très Élevé', Colors.deepOrange),
                    _buildDataRow('Rufisque', 'Industriel', '190 µg/m³', '250 µg/m³', 'Dangereux', Colors.red),
                    _buildDataRow('Almadies', 'Résidentiel Côtier', '85 µg/m³', '130 µg/m³', 'Modéré', Colors.amber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: color, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 50,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11);
                const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
                if (value.toInt() >= 0 && value.toInt() < 12) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(months[value.toInt()], style: style),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 11));
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 300,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 20,
              color: Colors.green,
              strokeWidth: 2,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                labelResolver: (line) => 'Seuil OMS (20)',
              ),
            ),
          ],
        ),
        lineBarsData: [
          // Ligne Dakar Centre
          LineChartBarData(
            spots: const [
              FlSpot(0, 170), // Jan (Saison sèche / Harmattan)
              FlSpot(1, 185), // Fév
              FlSpot(2, 160), // Mar
              FlSpot(3, 120), // Avr
              FlSpot(4, 90),  // Mai
              FlSpot(5, 60),  // Juin (Début hivernage)
              FlSpot(6, 45),  // Juil
              FlSpot(7, 40),  // Aoû (Pluies)
              FlSpot(8, 50),  // Sep
              FlSpot(9, 80),  // Oct
              FlSpot(10, 130), // Nov (Retour saison sèche)
              FlSpot(11, 155), // Déc
            ],
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withOpacity(0.1),
            ),
          ),
          // Ligne Banlieue (Industrielle)
          LineChartBarData(
            spots: const [
              FlSpot(0, 210), // Jan
              FlSpot(1, 230), // Fév
              FlSpot(2, 200), // Mar
              FlSpot(3, 160), // Avr
              FlSpot(4, 130), // Mai
              FlSpot(5, 95),  // Juin
              FlSpot(6, 80),  // Juil
              FlSpot(7, 75),  // Aoû
              FlSpot(8, 85),  // Sep
              FlSpot(9, 120), // Oct
              FlSpot(10, 170), // Nov
              FlSpot(11, 195), // Déc
            ],
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String zone, String type, String moyenne, String pic, String risque, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(zone, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(type, style: TextStyle(color: Colors.grey.shade700))),
        DataCell(Text(moyenne, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(pic)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Text(
              risque,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sources et Méthodologie'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Les données présentées sont basées sur des études environnementales récentes concernant la qualité de l\'air à Dakar :'),
              SizedBox(height: 8),
              Text('• Les niveaux de PM10 fluctuent selon les saisons, avec des pics élevés durant la saison sèche (novembre à mars) dus aux vents de l\'harmattan.'),
              Text('• Les concentrations annuelles dépassent souvent de 6 à 9 fois la limite de l\'OMS (20 µg/m³).'),
              Text('• La banlieue (ex: HLM, Rufisque) présente des niveaux encore plus élevés en raison de la concentration industrielle et du trafic.'),
              SizedBox(height: 8),
              Text('Note: Les valeurs exactes du graphique sont des estimations représentatives basées sur ces tendances documentées.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
