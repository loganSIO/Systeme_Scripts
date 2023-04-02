#!/bin/bash

# Fonction pour identifier les services disponibles sur le système
function list_services() {
    echo "Services disponibles :"
    systemctl list-unit-files | grep service | awk '{print $1}' | sed 's/\.service//'
}

# Fonction pour identifier les services actifs sur le système
function list_active_services() {
    echo "Services actifs :"
    systemctl list-units --type=service | grep running | awk '{print $1}' | sed 's/\.service//'
}

# Fonction pour identifier le statut d'un service dont le nom contient une chaine de caractères
function status_service() {
    read -p "Entrez le nom du service : " service_name
    systemctl status $service_name.service
}

# Fonction pour proposer une fonctionnalité supplémentaire
function custom_function() {
    echo "Afficher la description d'un service"
    read -p "Entrez le nom du service : " service_name
    systemctl show -p Description $service_name.service | awk -F'=' '{print $2}'
}

# Menu principal
while true; do
    clear
    echo "Que voulez-vous faire ?"
    echo "1. Identifier les services disponibles sur le système"
    echo "2. Identifier les services actifs sur le système"
    echo "3. Identifier le statut d'un service"
    echo "4. Afficher la description d'un service"
    echo "5. Quitter"
    read -p "Entrez votre choix : " choice

    case $choice in
        1)
            list_services
            read -p "Appuyez sur une touche pour revenir au menu principal" -n1
            ;;
        2)
            list_active_services
            read -p "Appuyez sur une touche pour revenir au menu principal" -n1
            ;;
        3)
            status_service
            read -p "Appuyez sur une touche pour revenir au menu principal" -n1
            ;;
        4)
            custom_function
            read -p "Appuyez sur une touche pour revenir au menu principal" -n1
            ;;
        5)
            exit 0
            ;;
        *)
            echo "Choix invalide"
            read -p "Appuyez sur une touche pour revenir au menu principal" -n1
            ;;
    esac

    # Effacer l'écran et réafficher le menu toutes les 30 secondes
    clear
    sleep 30
done

