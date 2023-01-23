import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_riverpod_showcase/intervention.dart';

class InterventionApi {
  final token =
      'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJFdWRSeWludDluUFZROGp2OFV1LTJpaHhScHlfYmJaMC1OdE9CSkRDd08wIn0.eyJleHAiOjE3MDQ5NjgxMjAsImlhdCI6MTY3MzQzMjEyMCwianRpIjoiYzQ4ODVhZjUtZDBkMS00OGVmLTlhZDgtZTkzNjljMzhjZWY4IiwiaXNzIjoiaHR0cHM6Ly9icmlkZ2UuYmlzcy5ocjo4NDQzL2F1dGgvcmVhbG1zL2ZpcmVmaWdodGVycyIsImF1ZCI6WyJmaXJlZmlnaHRlcnMubG9jYWwiLCJkdmQtc2VzdmV0c2tpX2tyYWxqZXZlYyIsImFjY291bnQiXSwic3ViIjoiZTM4YWZkNWUtMTRjZC00NzU0LThkOWMtYWQ1Nzc2MmI2YWU2IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiZmlyZWZpZ2h0ZXJzLm1vYmlsZSIsInNlc3Npb25fc3RhdGUiOiI2YmNmNTc5NC1jN2Y5LTRhODUtYWYzMC0xMGQyMWZmNzg4ZjQiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbImRlZmF1bHQtcm9sZXMtZmlyZWZpZ2h0ZXJzIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImZpcmVmaWdodGVycy5sb2NhbCI6eyJyb2xlcyI6WyJDQVBUQUlOX1JPTEUiXX0sImR2ZC1zZXN2ZXRza2lfa3JhbGpldmVjIjp7InJvbGVzIjpbImNvbW1hbmRlciJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyBwcm9maWxlIGVtYWlsIiwic2lkIjoiNmJjZjU3OTQtYzdmOS00YTg1LWFmMzAtMTBkMjFmZjc4OGY0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiRmlsaXAgS2lzaWMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJma2lzaWMiLCJnaXZlbl9uYW1lIjoiRmlsaXAiLCJmYW1pbHlfbmFtZSI6Iktpc2ljIiwiZW1haWwiOiJmaWxpcC5raXNpY0BiaXNzLmhyIn0.FVltzEpIp7B62zo4t5fS904LkTkoIqPqBIKZPnlUHHpQ6FHOl2bxoChEyTT7-qAxKqzyHN82C9j2gymgKT8QJ5JKK9mDzj_nFvpaQnvahPJDfAHLt2AMuRayGRD-11kxkBMmD5kTTKr4S9hc_RobhJjuNNS-z99R1Za2SPvTLiJEnSWoobnk17L1onPXUIhFZwhOQASKA7frKgAIF0t3rRRV0ifOC2Q19qLQKTPnswcLHMI4yPcr8yc7KoWYlQndJHWE5ogZF6IP-H4WRp9YGV_70oOeAqOGd_knqobd5VOMyg-rSbzhzgtX-UJegf2HntH2-MKE6n4WJ2Jc9Hv54w';
  final String apiUrl = 'https://bridge.biss.hr:8090/api/v1/interventions/list?active=true';

  Future<List<Intervention>> getInterventions() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((interventionJson) => Intervention.fromJson(interventionJson)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> toggleFavorite(final bool isFavorite) async => await Future.delayed(const Duration(seconds: 1));
}
