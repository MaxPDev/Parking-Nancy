// Configuration des Services

//* G-Ny
// URI vers l'API de G-Ny
String gnyUri = 'https://go.g-ny.org/stationnement?output=';
// Format de sortie JSON
String gnyJson = "json";
// Format de sortie GeoJSON
String gnyGeoJson = "geojson";
// Sortie des données dynamiques
String gnyHot = "hot";

//* JC Decaux
// URI vers l'API de JC Decaux
String jcdUri = "https://api.jcdecaux.com/vls/v3/stations";
// Nom du contrat (correspond à la ville)
String jcdContractName = "nancy";
// API Key JC Decaux
String jcdApiKey = "526c2bc0188fdb797a47511c029cec761757a838";

//* BAN (Base Adresse Nationale)
// URI vers l'API,de BAN
String banUriFromAddress = 'https://api-adresse.data.gouv.fr/search/?q=';
// Les recherches s'effectue depuis ce point en priorité
String banGeoPriority = '&lat=48.69078&lon=6.182468';
// Recherche depuis des coordonnées (Géolocalisation)
String banUriromCoordinates = 'https://api-adresse.data.gouv.fr/reverse/?';

//* Here
// API Key pour l'application "Parking Nancy"
String hereApiKey = "2mOBJujSGItcZ0Oo5-Pq6yMZFXHGRKpFAthFjRkT96w";