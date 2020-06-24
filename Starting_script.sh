#! /usr/bin/bash
# Script de démarrage du serveur Fedora
# Lancé à chaque redémarrage du serveur, il créée un nouveau screen et y lance McMyAdmin (qui a son tour lance le serveur minecraft)
screen -S Minecraft -dm bash -c "/home/snyssen/Scripts/Launch_McMyAdmin_script.sh"
screen -S GitBucket -dm java -jar /home/snyssen/gitbucket.war --port=8090
screen -S Terraria -dm bash -c "/home/snyssen/Scripts/Launch_Terraria.sh"