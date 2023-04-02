#!/bin/bash

fichier_sortie=resultat_processus.txt


afficher_menu() {
echo "1. Identifier tous les processus présents sur le système et indiquer leur propriétaire"
echo "2. Identifier uniquement les processus actifs et indiquer leur propriétaire"
echo "3. Identifier les processus appartenant à un utilisateur donné en paramètre"
echo "4. Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire"
echo "5. Identifier les processus dont le nom contient une chaîne de caractères et indiquer leur propriétaire"
echo "6. Liste des processus triés par consommation de mémoire"
echo "7. Recherche de processus selon un filtre combinant les possibilités."
echo "8. Retourner à l'interface de menu"
echo "Choisissez une option : "
}

# Fonction qui affiche le résultat de la recherche
function afficher_resultat {
    echo "Résultat de la recherche :"
    cat resultat_processus.txt
    echo ""
}

afficher_processus() {
if [ -n "$1" ]; then
ps -ef | grep $1 | grep -v grep | awk '{print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
else
ps -ef | awk '{print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
fi
}

identifier_processus_actifs() {
if [ -n "$1" ]; then
ps -ef | grep $1 | grep -v grep | awk '{if ($8 ~ /R|S/) print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
else
ps -ef | awk '{if ($8 ~ /R|S/) print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
fi
}

identifier_processus_utilisateur() {
if [ -n "$1" ]; then
ps -ef | grep $1 | grep -v grep | awk '{if ($1 == "'"$1"'") print $0}' >> "$fichier_sortie"
else
echo "Veuillez fournir un nom d'utilisateur valide." >> "$fichier_sortie"
fi
}

identifier_processus_memoire() {
ps -eo pid,ppid,cmd,%mem,%cpu,user --sort=-%mem | head | awk '{print $0 " - propriétaire: " $6}' >> "$fichier_sortie"
}

identifier_processus_nom() {
if [ -n "$1" ]; then
ps -eo pid,ppid,cmd,user --sort=user | awk '{if ($3 ~ /'"$1"'/) print $0 " - propriétaire: " $6}' >> "$fichier_sortie"
fi
}

# Fonction pour gérer la fonctionnalité supplémentaire
fonctionnalite_supplementaire() {
  ps -eo pid,%mem,command --sort=-%mem | head >> "$fichier_sortie"
}

# Fonction qui gère les filtres de script
afficher_resultat_filtre() {
       clear
       echo "Résultat de la recherche :"
       if [ -n "$1" ] && [ -n "$2" ]; then
       ps -ef | grep $nom_processus | grep $nom_utilisateur | grep -v grep | awk '{print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
       elif [ -n "$1" ]; then
       ps -ef | grep $nom_processus | grep -v grep | awk '{if ($8 ~ /R|S/) print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
       elif [ -n "$2" ]; then
       ps -ef | grep $nom_utilisateur | grep -v grep | awk '{print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
       else
       ps -ef | grep $nom_processus | grep $nom_utilisateur | grep -v grep | awk '{print $0 " - propriétaire: " $1}' >> "$fichier_sortie"
       fi
     }

# Boucle principale
while true; do
  clear
  afficher_menu
  read choix_menu

  case $choix_menu in
    1) clear
       echo "Identification de tous les processus présents sur le système et de leur propriétaire."
       afficher_processus
       afficher_resultat
       read -p "Appuyez sur une touche pour continuer.";;
    2) clear
       echo "Identification des processus actifs et de leur propriétaire."
       identifier_processus_actifs
       afficher_resultat
       read -p "Appuyez sur une touche pour continuer.";;
    3) clear
       echo "Identification des processus appartenant à un utilisateur donné."
       read -p "Entrez le nom d'utilisateur : " nom_utilisateur
       identifier_processus_utilisateur
       afficher_resultat $nom_utilisateur
       read -p "Appuyez sur une touche pour continuer.";;
    4) clear
       echo "Identification des processus consommant le plus de mémoire et de leur propriétaire."
       identifier_processus_memoire
       afficher_resultat
       read -p "Appuyez sur une touche pour continuer.";;
    5) clear
       echo "Identification des processus dont le nom contient une chaîne de caractères et de leur propriétaire."
       read -p "Entrez une chaîne de caractères : " nom_processus
       identifier_processus_nom
       afficher_resultat
       read -p "Appuyez sur une touche pour continuer.";;
    6) clear
       echo "Liste des processus triés par consommation de mémoire :"
       fonctionnalite_supplementaire
       afficher_resultat
       read -p "Appuyez sur une touche pour continuer.";;
    7) clear
       echo "Recherche de processus selon un filtre combinant les possibilités."
       read -p "Entrez le nom d'utilisateur : " nom_utilisateur
       read -p "Entrez une chaîne de caractères : " nom_processus
       afficher_resultat_filtre $nom_utilisateur $nom_processus
       afficher_resultat
       read -p "Appuyez sur une touche pour continuer.";;
    8) clear
       ./Interface.sh
       exit;;
    *) clear
       echo "Option invalide. Veuillez choisir une option valide."
       read -p "Appuyez sur une touche pour continuer.";;
  esac
done

