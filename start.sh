#!/bin/bash

repositories=(
    "https://github.com/DyatkoGleb/noticer_web.git"
    "https://github.com/DyatkoGleb/noticer_api.git"
    "https://github.com/DyatkoGleb/noticer_bot.git"
    "https://github.com/DyatkoGleb/noticer_queue.git"
)

for repo in "${repositories[@]}"
do
    repo_name=$(basename $repo .git)

    git clone $repo

    cd $repo_name

    # Создать манифесты на основе docker-compose 
    
    cd ..
done