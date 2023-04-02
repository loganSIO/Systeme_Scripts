#!/bin/bash

echo "Bienvenue sur le menu principal."

while true; do
    echo "1. Script 1 : Explorateurde fichiers"
    echo "2. Script 2 : Explorateurde processus"
    echo "3. Script 3 : Explorateurde services"
    echo "q. Quitter"

    read -p "Veuillez sélectionner une option (1-3) ou tapez 'q' pour quitter :" choice

    case $choice in
        1)
            # Exécuter le script 1
            ./script1.sh
            ;;
        2)
            # Exécuter le script 2
            ./script2.sh
            ;;
        3)
            # Exécuter le script 3
            ./script3.sh
            ;;
        q)
            # Quitter le menu principal
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Choix invalide. Veuillez sélectionner une option valide."
            ;;
    esac
done

