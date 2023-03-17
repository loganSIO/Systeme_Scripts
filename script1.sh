#!/bin/bash

# Fonction qui affiche le menu
function afficher_menu {
    echo "Menu :"
    echo "a) Afficher le répertoire courant dans lequel je me trouve"
    echo "b) Indiquez la date et l’heure du système"
    echo "c) Indiquer le nombre de fichiers présents dans le répertoire courant et leur taille (en Mo)"
    echo "d) Indiquer le nombre de sous-répertoires présents dans le répertoire courant"
    echo "e) Indiquer l’arborescence (en permettant de paramétrer une profondeur) du répertoire
courant"
    echo "f) Indiquer le poids (quantité de données) de chaque sous-répertoire du répertoire
courant"
    echo "g) Changer de répertoire courant pour poursuivre mes investigations"
    echo "h) Rechercher les fichiers plus récents qu’une date (définie en paramètre) pour le
répertoire courant"
    echo "i) Rechercher les fichiers plus récents qu’une date (définie en paramètre) présents dans
tous les sous-répertoires de l’arborescence du répertoire courant"
    echo "j) Rechercher les fichiers plus anciens qu’une date (définie en paramètre) pour le
répertoire courant"
    echo "k) Rechercher les fichiers plus anciens qu’une date (définie en paramètre) présents dans
tous les sous-répertoires de l’arborescence du répertoire courant"
    echo "l) Rechercher les fichiers de poids supérieur à une valeur indiquée présents dans le
répertoire courant"
    echo "m) Rechercher les fichiers de poids supérieur à une valeur présents dans tous les sous-
répertoires de l’arborescence du répertoire courant"
    echo "n) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans le
répertoire courant"
    echo "o) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans tous les
sous-répertoires de l’arborescence du répertoire courant"
    echo "p) Rechercher tous les fichiers d’une extension donnée (définie en paramètre) présents
dans tous les sous-répertoires de l’arborescence du répertoire courant"
    echo "q) Rechercher tous les fichiers d’une extension donnée (définie en paramètre) présents
dans le répertoire courant"
    echo "r) Rechercher tous les fichiers dont le nom contient une chaine de caractère (définie en
paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire
courant"
    echo "s) Quitter"
}

# Fonction qui affiche le résultat de la recherche
function afficher_resultat {
    echo "Résultat de la recherche :"
    cat resultat_recherche.txt
    echo ""
}

# Initialisation de la variable de recherche
recherche=""

# Tant que l'utilisateur ne quitte pas
while true; do
    # Affichage du menu
    afficher_menu

    # Lecture de l'option choisie par l'utilisateur
    read -p "Entrez votre choix : " choix

    case $choix in
        a) echo "$(date +'%d/%m/%Y %H:%M:%S') | $(pwd)" >> resultat_recherche.txt;;
        b) echo "$(date +'%d/%m/%Y %H:%M:%S') | Date et heure du système : $(date -d "now" +"%d/%m/%Y %H:%M:%S" )" >> resultat_recherche.txt ;;
        c) echo "$(date +'%d/%m/%Y %H:%M:%S') | $(ls -l | grep '^-' | awk '{sum += $5} END {printf "%d fichiers, taille totale : %.2f Mo\n", NR, sum/1024/1024}')" >> resultat_recherche.txt ;;
        d) echo "$(date +'%d/%m/%Y %H:%M:%S') | Nombre de sous répertoires présents dans le répertoire courante : $(ls -l | grep '^d' | wc -l)" >> resultat_recherche.txt ;;
        e) read -p "Entrez la profondeur de l'arborescence : " profondeur
           echo "$(date +'%d/%m/%Y %H:%M:%S') | $(tree -L "$profondeur")" >> resultat_recherche.txt ;;
        f) read -p "Entrez la taille minimale en Ko : " taille
           echo "$(date +'%d/%m/%Y %H:%M:%S') | Poids en Ko de chaque sous répertoire : $(find . -type d -size +"$taille"k -exec du -sh {} + | sort -h)" >> resultat_recherche.txt ;;
        g) echo "$(date +'%d/%m/%Y %H:%M:%S') | Vous voici désormais dans le répertoire "documents/" $(cd documents/)" >> resultat_recherche.txt ;;
        h) read -p "Entrez une date au format yyyy-mm-dd : " date
           recherche+=" -newermt $date"
           echo "$(date +'%d/%m/%Y %H:%M:%S') | Fichiers plus récents que la date : $(date +'%d/%m/%Y') : $(find . -type f $recherche)" >> resultat_recherche.txt ;;
        i) read -p "Entrez une date au format yyyy-mm-dd : " date
           recherche="-newerct $date"
	   echo "$(date +'%d/%m/%Y %H:%M:%S') | Fichiers plus récents que la date dans tous les répertoires et sous répertoires: $(date +'%d/%m/%Y') $(find . -type f $recherche)" >> resultat_recherche.txt ;;
	j) read -p "Entrez une date au format yyyy-mm-dd : " date
	   recherche+=" -oldermt $date"
	   echo "$(date +'%d/%m/%Y %H:%M:%S') | Fichiers plus anciens que la date : $(date +'%d/%m/%Y') : $(find . -type f $recherche)" >> resultat_recherche.txt ;;
	k) read -p "Entrez une date au format yyyy-mm-dd : " date
	   recherche=" -olderct $date"
	   echo "$(date +'%d/%m/%Y %H:%M:%S') | Fichiers plus anciens que la date dans tous les répertoires et sous répertoires: $(find . -type f $recherche)" >> resultat_recherche.txt ;;
	l) read -p "Entrez la taille minimale en octets : " taille
	   echo "$(date +'%d/%m/%Y %H:%M:%S') | $(find . -type f -size +"$taille"c)" >> resultat_recherche.txt ;;
	m) read -p "Entrez la taille minimale en Mo : " taille
	   echo "$(date +'%d/%m/%Y %H:%M:%S') | $(find . -type f -size +"$taille"M)" >> resultat_recherche.txt ;;
	n) read -p "Entrez la taille maximale en octets : " taille
	   find . -type f -size -"$taille"c >> resultat_recherche.txt ;;
	o) read -p "Entrez la taille maximale en Mo : " taille
	   find . -type f -size -"$taille"M >> resultat_recherche.txt ;;
	p) read -p "Entrez l'extension recherchée (sans le point) : " extension
	   find . -type f -name ".$extension" >> resultat_recherche.txt ;;
	q) read -p "Entrez l'extension recherchée (sans le point) : " extension
	   find . -maxdepth 1 -type f -name ".$extension" >> resultat_recherche.txt ;;
	r) read -p "Entrez une chaîne de caractères : " chaine
	   grep -r "$chaine" . >> resultat_recherche.txt ;;
    s) break ;;
    *) echo "Option invalide" ;;
esac

# Affichage du résultat de la recherche
afficher_resultat

# Demande à l'utilisateur s'il souhaite continuer la recherche
read -p "Voulez-vous continuer la recherche (o/n) ? " continuer
case $continuer in
    n|N) break ;;
    *) continue ;;
esac
done

echo "Fin de la recherche"

