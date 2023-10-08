#!/bin/bash

repositories=(
    "https://github.com/DyatkoGleb/noticer_web.git"
    "https://github.com/DyatkoGleb/noticer_api.git"
    "https://github.com/DyatkoGleb/noticer_bot.git"
    "https://github.com/DyatkoGleb/noticer_queue.git"
)
manifest_dir="k8s_manifests"

for repo in "${repositories[@]}"
do
    repo_name=$(basename $repo .git)

    git clone $repo

    cd $repo_name
    
    if [ "$repo_name" == "noticer_api" ] 
    then
        cp .env.example .env
        cp ./app/.env.example ./app/.env
    fi

    mkdir $manifest_dir
    
    kompose convert -o $manifest_dir
    
    cd ..
done

echo "Now you should fill env files, after that can run start_project.sh"