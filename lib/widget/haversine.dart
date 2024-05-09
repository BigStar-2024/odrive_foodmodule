import 'dart:math';

class Haversine {
  static const double earthRadius =
      6371.0; // Rayon moyen de la Terre en kilomètres

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  static num haversine(double theta) {
    return pow(sin(theta / 2), 2);
  }

  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    // Convertir les degrés en radians
    lat1 = degreesToRadians(lat1);
    lon1 = degreesToRadians(lon1);
    lat2 = degreesToRadians(lat2);
    lon2 = degreesToRadians(lon2);

    // Calculer les différences de coordonnées
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    // Appliquer la formule haversine
    double a = haversine(dLat) + cos(lat1) * cos(lat2) * haversine(dLon);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculer la distance en kilomètres
    double distance = earthRadius * c;

    return distance;
  }
}
