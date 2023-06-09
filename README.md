## Auteur
- ELALAOUI Hasnaa - Étudiante en Master2 MIAGE Intense à l'Université Côte d'Azur

## Présentation du projet
MIAGED est un projet réalisé dans un cadre éducatif, représentant une application de vente de vêtements en ligne (sur le modèle Vinted). 
Les fonctionnalités implémentées représentent la version MVP (Produit Minimum Viable) demandée.
Des fonctionnalités ont été ajoutées à ce MVP, elles seront marquées par un (+) dans le chapitre 'Fonctionnalités implémentées'. 

## Technologies utilisées
L'application a été réalisée en utilisant deux technologies : 
- Flutter pour l'interface et les appels à l'api
- Firebase pour la base de données

## Lancement du projet
Une fois le projet récupéré, lancer dans le terminal la commande : ``` flutter run ```  
Celle-ci importera les dépendances requises.      
Ensuite, il faut choisir Chrome comme device d'éxecution car étant sur MacOS, je n'ai pas pu faire le test sur un émulateur Androïd. 

## Connexion à l'interface
Vous pouvez vous connecter sous un des deux utilisateurs suivants (les deux possédant les mêmes droits):
- Utilisateur 1 :
    - Nom d'utilisateur : **miollan**
    - Mot de passe : **miollan**
- Utilisateur 2 :
    - Nom d'utilisateur : **admin**
    - Mot de passe : **admin**

## Fonctionnalités implémentées
L'application se présente ainsi : 
L'utilisateur arrive sur une page de Login, il entre ses identifiants puis une fenêtre de chargement s'affiche (+). Une fois connecté, il est dirigé vers la page d'accueil possédant la liste des vêtements mis en vente. Cette liste peut être filtrée par catégorie (Pantalon, Chemise, Chaussures, etc.) et également par prix (+), respectivement grâce aux tabulations en haut de page et au slider disponible dans une popup, accessible depuis le bouton en bas à droite de la page .     
Chaque élément de la liste est cliquable afin d'en découvrir les détails tels que le titre, la taille, le prix ou encore l'image et ainsi pouvoir l'ajouter à son panier.     
Chaque article ne peut être ajouté qu'une fois au panier, un message est affiché à l'utilisateur en cas de tentative d'ajout multiple (+).
De plus, l'utilisateur peut consulter son panier, recensant les articles sélectionnés ainsi qu'un prix total. Il peut également supprimer un article s'il le souhaite grâce à l'icône poubelle.    
Enfin, l'utilisateur peut consulter le détail de son profil et modifier ses informations excepté les login et mot de passe, valider ces informations modifiées et/ou se déconnecter.   
## Architecture du projet
Tous les fichiers contenant les fonctionnalités implémentées sont dans le dossier 'lib'. 
Ce dernier est composé d'un fichier 'main.dart' pour lancer l'application ainsi que de 3 dossiers : 
- api : ensemble des différentes méthodespermettant de récupérer les données dans la base Firestore ainsi que le fichier de configuration
- models : regroupant les différentes classes utilisées pour le mapping des données de la base
- views : ensemble des pages et widgets affichés à l'utilisateur 

## Sources utilisées
La principale source que j'ai pu utiliser lors de la réalisation de ce projet est la documentation Flutter : https://docs.flutter.dev/    
Pour les appels à la base de données j'ai suivi le tutoriel Firebase : https://firebase.google.com/docs/flutter/setup?platform=web&hl=fr    
Enfin, pour la résolution des bugs je me suis inspirée des réponses données sur le site Stack Overflow : https://stackoverflow.com/    
D'autres librairies ont été utilisées, notamment : 
- FlutterToast : https://pub.dev/packages/fluttertoast
- SharedPreferences : https://pub.dev/packages/shared_preferences

