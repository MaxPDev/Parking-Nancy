# Nancy Stationnement App

Application permettant d'informer en temps réel les disponibilités des parkings de Nancy sur une carte.  
Propose également un afficage des station de location de vélo.

## Services

L'application utilise les services de [G-Ny](https://go.g-ny.org/stationnement?output=map&caller=g-ny) pour récupérer les données des parkings et de [JCdecaux](https://developer.jcdecaux.com/#/opendata/vls?page=getstarted) pour ceux des stations de location vélo vélOstan'lib.

## Framework et Langage :

* Flutter 3.0.5
* Dart 2.17.6

## Installation

### FVM
[Flutter Version Manager](https://fvm.app/docs/getting_started/installation) est conseillé pour gérer les mises à jour de version flutter, ou les rétrogradations de version,  au sein du projet.

### Flutter
Installer [Flutter](https://docs.flutter.dev/get-started/install) pour votre plateforme.

### Démarrer

Obtenir la liste des devices disponible  
`flutter devices`

Lancer l'exécution de l'application, avec fvm s'il est actif  
`fvm flutter run`      
 
ou sans fvm  
`flutter run`     

ou sur un device spécifique  
`flutter run --launch <id-device>`


## Workflow

[Gitflow](https://danielkummer.github.io/git-flow-cheatsheet/index.fr_FR.html) est utilisé pour ce projet :

- La branche *master* est reservé pour les version en production.
- Le travail principal se fait dans la branch *develop*.

- Chaque fonctionnalité est réalisée dans une branche *feature*, puis merge dans *develop*.
- Les branches *release* préparent une mise en production depuis *develop*.vers *master*.
- La branche *hotfix* concerne les correctifs de la version en production.
