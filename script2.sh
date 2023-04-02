#!/bin/bash

fichier_sortie=resultat_processus.txt


afficher_menu() {
echo "1. Identifier tous les processus présents sur le système et indiquer leur propriétaire"
echo "2. Identifier uniquement les processus actifs et indiquer leur propriétaire"
echo "3. Identifier les processus appartenant à un utilisateur donné en paramètre"
echo "4. Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire"
echo "5. Identifier les processus dont le nom contient une chaîne de caractères et indiquer leur propriétaire"
echo "6. Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n'écrase pas les résultats de la recherche précédente"
echo "7. Fonctionnalité supplémentaire"
echo "8. Quitter"
echo "Choisissez une option : "
}

afficher_processus() {
if [ -n "$1" ]; then
ps -ef | grep $1 | grep -v grep | awk '{print $0 " - propriétaire: " $1}' > "$fichier_sortie"
else
ps -ef | awk '{print $0 " - propriétaire: " $1}' > "$fichier_sortie"
fi
}

identifier_processus_actifs() {
if [ -n "$1" ]; then
ps -ef | grep $1 | grep -v grep | awk '{if ($8 ~ /R|S/) print $0 " - propriétaire: " $1}' > "$fichier_sortie"
else
ps -ef | awk '{if ($8 ~ /R|S/) print $0 " - propriétaire: " $1}' > "$fichier_sortie"
fi
}

identifier_processus_utilisateur() {
if [ -n "$1" ]; then
ps -ef | grep $1 | grep -v grep | awk '{if ($1 == "'"$1"'") print $0}' > "$fichier_sortie"
else
echo "Veuillez fournir un nom d'utilisateur valide." > "$fichier_sortie"
fi
}

identifier_processus_memoire() {
ps -eo pid,ppid,cmd,%mem,%cpu,user --sort=-%mem | head | awk '{print $0 " - propriétaire: " $6}' > "$fichier_sortie"
}

identifier_processus_nom() {
if [ -n "$1" ]; then
ps -eo pid,ppid,cmd,user --sort=user | awk '{if ($3 ~ /'"$1"'/) print $0 " - propriétaire: " $6}' > "$fichier_sortie"
fi
}

# Fonction pour produire un fichier de sortie avec le résultat de la recherche effectuée
produire_fichier_sortie() {
  local date_actuelle=$(date +"%Y-%m-%d_%H-%M-%S")
  local nom_fichier_resultat="resultat_processus_$date_actuelle.txt"
  if [ -n "$1" ]; then
    ps -eo pid,ppid,cmd,user --sort=user | awk '{if ($3 ~ /'"$1"'/) print $0 " - propriétaire: " $6}' > "$nom_fichier_resultat"
  else
    ps -ef | awk '{print $0 " - propriétaire: " $1}' > "$nom_fichier_resultat"
  fi
  echo "Le fichier de sortie '$nom_fichier_resultat' a été généré avec succès."
}

# Fonction pour gérer la fonctionnalité supplémentaire
fonctionnalite_supplementaire() {
  echo "Fonctionnalité supplémentaire : à implémenter"
  # TODO : Implémenter la fonctionnalité supplémentaire
  read -p "Appuyez sur une touche pour continuer."
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
       read -p "Appuyez sur une touche pour continuer.";;
    2) clear
       echo "Identification des processus actifs et de leur propriétaire."
       identifier_processus_actifs
       read -p "Appuyez sur une touche pour continuer.";;
    3) clear
       echo "Identification des processus appartenant à un utilisateur donné."
       read -p "Entrez le nom d'utilisateur : " nom_utilisateur
       identifier_processus_utilisateur $nom_utilisateur
       read -p "Appuyez sur une touche pour continuer.";;
    4) clear
       echo "Identification des processus consommant le plus de mémoire et de leur propriétaire."
       identifier_processus_memoire
       read -p "Appuyez sur une touche pour continuer.";;
    5) clear
       echo "Identification des processus dont le nom contient une chaîne de caractères et de leur propriétaire."
       read -p "Entrez une chaîne de caractères : " nom_processus
       identifier_processus_nom $nom_processus
       read -p "Appuyez sur une touche pour continuer.";;
    6) clear
       echo "Production d'un fichier de sortie contenant le résultat de la recherche effectuée."
       read -p "Entrez une chaîne de caractères : " nom_processus
       produire_fichier_sortie $nom_processus
       read -p "Appuyez sur une touche pour continuer.";;
    7) clear
       fonctionnalite_supplementaire;;
    8) clear
       echo "Merci d'avoir utilisé ce script. À bientôt !"
       exit;;
    *) clear
       echo "Option invalide. Veuillez choisir une option valide."
       read -p "Appuyez sur une touche pour continuer.";;
  esac
done

