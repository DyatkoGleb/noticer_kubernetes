#!/bin/bash

repositories=(
    "https://github.com/DyatkoGleb/noticer_web.git"
    "https://github.com/DyatkoGleb/noticer_api.git"
    "https://github.com/DyatkoGleb/noticer_bot.git"
    "https://github.com/DyatkoGleb/noticer_queue.git"
)
manifest_dir="k8s_manifests"

# Fill variables value in manifest file from value from .env.example
fill_env_values_in_manifest_file() {
    local env_file="$1"
    local manifest_file="$2"

    while IFS='=' read -r key value; do
        if [[ ! -z $key && ! -z $value ]]; then
            sed -i "/- name: $key/a\ \ \ \ \ \ \ \ \ \  \  \ value: $value" $manifest_file
        fi
    done < <(grep -v '^$' $env_file)
}

# Apply all manifests in each service dir
aplly_manifests() {
    current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    for dir in "$current_dir"/*/; do
        cd $dir

        if [ ! -d "$manifest_dir" ]; then
            continue
        fi
        
        for file in "$manifest_dir"/*.yaml; do
            echo $file
            kubectl apply -f "$file"
        done

        cd ..
    done
}

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

    fill_env_values_in_manifest_file ".env.example" "$manifest_dir/mysql-deployment.yaml"
    
    cd ..
done

aplly_manifests