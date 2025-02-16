#!/bin/bash

# get the Series Name from env var
SERIES_NAME=$SERIES_NAME

SAFE_SERIES_NAME="${SERIES_NAME// /_}"  # Replace spaces with underscores
echo "Episode File Inventory:"


# Initialize JSON file
json_file="/output/${SAFE_SERIES_NAME}_episode_inventory.json"
echo -n "{\"SeriesName\":\"$SERIES_NAME\",\"Seasons\":{" > "$json_file"
temp_fragments=$(mktemp)

process_season() {
    local dir="$1"
    local season_type="$2"

    # Extract season number
    local season=$(basename "$dir" | grep -oE '[0-9]+' | sed 's/^0*//')

    # Text output headers
    if [[ "$season_type" == "special" ]]; then
        echo -e "\nSpecials:"
        json_season_key="0"
    else
        echo -e "\nSeason $season:"
        json_season_key="$season"
    fi

    # Array to store episode information
    declare -A episodes
    while IFS= read -r file; do
        # Extract episode code (sXXeYY format)
        ep_code=$(basename "$file" | grep -oiE 'S[0-9]{1,2}E[0-9]{1,2}' | tr '[:upper:]' '[:lower:]')
        episodes["$ep_code"]="$file"
    done < <(find "$dir" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) | sort -V)

    # Text output
    for ep in $(printf "%s\n" "${!episodes[@]}" | sort -V); do
        echo "Episode $ep:"
        echo "  ${episodes[$ep]}"
    done

    # Build JSON fragment
    json_fragment="\"$json_season_key\": {"
    first_ep=true
    for ep in $(printf "%s\n" "${!episodes[@]}" | sort -V); do
        [[ $first_ep == false ]] && json_fragment+=","
        # Escape special characters and clean path
        file_path=$(echo "${episodes[$ep]}" | sed 's/"/\\"/g; s/^\.\///')
        json_fragment+="\"$ep\": [\"$file_path\"]"
        first_ep=false
    done
    json_fragment+="}"

    echo "$json_fragment" >> "$temp_fragments"
}

# Process seasons
find . -type d \( -iregex ".*/season[0-9]+" -o -iregex ".*/season [0-9]+" \) | sort -V | while read -r dir; do
    process_season "$dir" "regular"
done

# Process specials
find . -type d \( -iname "season 0" -o -iname "season-specials" \) | sort -V | while read -r dir; do
    process_season "$dir" "special"
done

# Combine JSON fragments
{
    # Add seasons
    paste -sd, "$temp_fragments"
} | sed 's/,/,\n/g' >> "$json_file"

echo '}}' >> "$json_file"
rm "$temp_fragments"

echo -e "\nInventory complete."
echo "JSON output saved to $json_file"
