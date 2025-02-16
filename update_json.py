import json
import os

path_prefix = os.getenv("WORSE_PATH_PREFIX")

def merge_worse_data(better_json, worse_json):
    # Carregar os JSONs
    better_data = json.loads(better_json)
    worse_data = json.loads(worse_json)
    
    series_name = worse_data["SeriesName"]
    worse_seasons = worse_data["Seasons"]
    
    if series_name in better_data:
        for season, episodes in worse_seasons.items():
            if season not in better_data[series_name]:
                better_data[series_name][season] = {}
            
            for episode, paths in episodes.items():
                if episode not in better_data[series_name][season]:
                    better_data[series_name][season][episode] = {"better": {}, "worse": {}}
                
                better_data[series_name][season][episode]["worse"] = {"path": path_prefix + paths[0]} 
    
    return json.dumps(better_data, indent=4)

# Ler os arquivos
def load_file(filename):
    with open(os.path.join("/data", filename), "r", encoding="utf-8") as file:
        return file.read()

# Salvar os dados atualizados
def save_file(filename, data):
    with open(os.path.join("/data", filename), "w", encoding="utf-8") as file:
        file.write(data)

# Arquivos
better_json = load_file("data.txt")
worse_json = load_file("worsedata.txt")

updated_json = merge_worse_data(better_json, worse_json)
save_file("data.txt", updated_json)

print("Arquivo atualizado com sucesso!")
