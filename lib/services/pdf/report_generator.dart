import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:solarpro/domain/entities/appliance.dart';
import 'package:solarpro/engine/load_analyzer.dart';
import 'package:solarpro/engine/inverter_sizer.dart';
import 'package:solarpro/engine/battery_sizer.dart';
import 'package:solarpro/engine/solar_sizer.dart';

class ReportGenerator {
  static Future<Uint8List> generateProposal({
    required String projectName,
    required List<Appliance> appliances,
    required LoadAnalysisResult loadResult,
    required InverterSizingResult invResult,
    required BatterySizingResult batResult,
    required SolarSizingResult solResult,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(projectName),
          pw.SizedBox(height: 30),
          _buildExecutiveSummary(invResult, batResult, solResult),
          pw.SizedBox(height: 30),
          _buildLoadAnalysis(appliances, loadResult),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String projectName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Inverter Engineering Pro', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
        pw.SizedBox(height: 4),
        pw.Text('Off-Grid Solar & Inverter System Proposal', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
        pw.SizedBox(height: 20),
        pw.Text('Project Name: $projectName', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Text('Date Generated: ${DateTime.now().toString().split(' ')[0]}', style: const pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 10),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _buildExecutiveSummary(
    InverterSizingResult invResult,
    BatterySizingResult batResult,
    SolarSizingResult solResult,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Executive Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Recommended System Configuration:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Bullet(text: 'Inverter: ${invResult.recommendedInverterWatts}W (${invResult.systemVoltage}V DC)'),
        pw.Bullet(text: 'Battery Bank: ${batResult.totalBatteries}x Batteries (Wired as ${batResult.batteriesInSeries}S${batResult.stringsInParallel}P)'),
        pw.Bullet(text: 'Solar Array: ${solResult.numberOfPanels} Panels Required'),
      ],
    );
  }

  static pw.Widget _buildLoadAnalysis(List<Appliance> appliances, LoadAnalysisResult loadResult) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Load Analysis Breakdown', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ['Appliance', 'Qty', 'Watts', 'Hrs/day', 'Wh/day'],
          data: appliances.map((app) => [
            app.name,
            app.quantity.toString(),
            app.runningWatts.toStringAsFixed(0),
            app.dailyHours.toString(),
            app.dailyEnergyWh.toStringAsFixed(0),
          ]).toList(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          cellAlignment: pw.Alignment.centerRight,
          cellAlignments: {0: pw.Alignment.centerLeft},
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Total Running Load: ${loadResult.totalRunningWatts.toStringAsFixed(0)} W', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Total Daily Energy: ${loadResult.dailyEnergyKwh.toStringAsFixed(2)} kWh', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        )
      ],
    );
  }
}