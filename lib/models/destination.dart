enum VibeType {
  beach,
  mountain,
  city,
  nature,
  culture,
}

class Destination {
  final String id;
  final String name;
  final String country;
  final String imageUrl;
  final String description;
  final VibeType vibe;
  final double rating;

  // New fields from external APIs
  final String capital;
  final int population;
  final String flagUrl;
  final String temp;
  final String weather;

  Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.description,
    required this.vibe,
    required this.rating,
    this.capital = '',
    this.population = 0,
    this.flagUrl = '',
    this.temp = '--',
    this.weather = '--',
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://picsum.photos/400/300',
      description: json['description'] ?? '',
      vibe: _parseVibe(json['vibe']),
      rating: (json['rating'] ?? 0.0).toDouble(),
      capital: json['capital'] ?? '',
      population: json['population'] ?? 0,
      flagUrl: json['flagUrl'] ?? '',
      temp: json['temp'] ?? '--',
      weather: json['weather'] ?? '--',
    );
  }

  Destination copyWith({
    String? id,
    String? name,
    String? country,
    String? imageUrl,
    String? description,
    VibeType? vibe,
    double? rating,
    String? capital,
    int? population,
    String? flagUrl,
    String? temp,
    String? weather,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      vibe: vibe ?? this.vibe,
      rating: rating ?? this.rating,
      capital: capital ?? this.capital,
      population: population ?? this.population,
      flagUrl: flagUrl ?? this.flagUrl,
      temp: temp ?? this.temp,
      weather: weather ?? this.weather,
    );
  }

  static VibeType _parseVibe(String? vibe) {
    switch (vibe?.toLowerCase()) {
      case 'beach': return VibeType.beach;
      case 'mountain': return VibeType.mountain;
      case 'city': return VibeType.city;
      case 'nature': return VibeType.nature;
      case 'culture': return VibeType.culture;
      default: return VibeType.nature;
    }
  }
}
