#!/bin/bash

# Fonction qui affiche le menu
function afficher_menu {
    echo "Menu :"
    echo "a) pwd"
    echo "b) date"
    echo "c) Afficher la taille totale des fichiers"
    echo "d) Afficher le nombre de dossiers"
    echo "e) Afficher l'arborescence de l'ensemble des fichiers et dossiers"
    echo "f) Afficher la taille des dossiers"
    echo "g) Se déplacer dans le dossier 'documents'"
    echo "h) Rechercher les fichiers modifiés depuis une date donnée"
    echo "i) Rechercher les fichiers créés depuis une date donnée"
    echo "j) Rechercher les fichiers modifiés avant une date donnée"
    echo "k) Rechercher les fichiers créés avant une date donnée"
    echo "l) Rechercher les fichiers d'une taille minimale donnée"
    echo "m) Rechercher les fichiers d'une taille minimale donnée (en Mo)"
    echo "n) Rechercher les fichiers d'une taille maximale donnée"
    echo "o) Rechercher les fichiers d'une taille maximale donnée (en Mo)"
    echo "p) Rechercher les fichiers avec une extension donnée"
    echo "q) Rechercher les fichiers dans le dossier courant avec une extension donnée"
    echo "r) Rechercher les fichiers contenant une chaîne de caractères"
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
        a) pwd >> resultat_recherche.txt ;;
        b) date >> resultat_recherche.txt ;;
        c) ls -l | grep '^-' | awk '{sum += $5} END {printf "%d fichiers, taille totale : %.2f Mo\n", NR, sum/1024/1024}' >> resultat_recherche.txt ;;
        d) ls -l | grep '^d' | wc -l >> resultat_recherche.txt ;;
        e) read -p "Entrez la profondeur de l'arborescence : " profondeur
           tree -L "$profondeur" >> resultat_recherche.txt ;;
        f) read -p "Entrez la taille minimale en Ko : " taille
           find . -type d -size +"$taille"k -exec du -sh {} + | sort -h >> resultat_recherche.txt ;;
        g) cd documents >> resultat_recherche.txt ;;
        h) read -p "Entrez une date au format yyyy-mm-dd : " date
           recherche+=" -newermt $date"
           find . -type f $recherche >> resultat_recherche.txt ;;
        i) read -p "Entrez une date au format yyyy-mm-dd : " date
           recherche+="-newerct $date"
	   find . -type f $recherche >> resultat_recherche.txt ;;
	j) read -p "Entrez une date au format yyyy-mm-dd : " date
	   recherche+=" -oldermt $date"
	   find . -type f $recherche >> resultat_recherche.txt ;;
	k) read -p "Entrez une date au format yyyy-mm-dd : " date
	   recherche+=" -olderct $date"
	   find . -type f $recherche >> resultat_recherche.txt ;;
	l) read -p "Entrez la taille minimale en octets : " taille
	   find . -type f -size +"$taille"c >> resultat_recherche.txt ;;
	m) read -p "Entrez la taille minimale en Mo : " taille
	   find . -type f -size +"$taille"M >> resultat_recherche.txt ;;
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

