from flask import Flask, request
import pygame
import overmap

SUCESS = "sucess"
FAILED = "failed"
ERROR = "error"
ACESS_DANIED = "Acess to map denied due wrong key!"
VISUAL = True

app = Flask(__name__)

acess_key = None
map = None
process = False

if __name__ == '__main__':
    app.run(debug=True, port= 5000)

def check_acess(key):
    if(key == acess_key):
        return True
    return False

# Unpack raw args amd return string dictionary where ([key] = [value])
def unpack_data(args):
    data = args.split(",")
    result = dict()
    for arg in data:
        for varibbles in arg:
            varrible, vallue = arg.split("=")
            result[varrible] = vallue
    return result

# Sets up a new acess key for map args = new_key
@app.route('/set_key', methods=['GET', 'POST'])
def set_key(args):
    print(f"Request method: {args}")
    if(acess_key):
        return "ABSTRACT MAP ERROR: ATTEMPT REPLACE EXISTED ACESS KEY"

    for arg in args:
        if(type(arg) == str):
            key = arg
    if(not key):
        return "ABSTRACT MAP ERROR: ATTEMPT SET HHTP KEY WITH KEY UNEXISTED STRING"
    acess_key = key
    return SUCESS

# Resets existed key of the map, args must be key
@app.route('reset_key', methods=['GET'])
def reset_key(args):
    for arg in args:
        if(type(arg) == str):
            if(check_acess(arg)):
                acess_key = None
                return SUCESS
    return FAILED

@app.route('/init_map', methods=['GET'])
def init_map(args):
    data = unpack_data(args)
    key = ""
    map_size_x = 1
    map_size_y = 1

    for data_key in data:
        if(data_key == "key"):
            key = data[data_key]
        if(data_key == "size_x"):
            map_size_x = data[data_key]
        if(data_key == "size_y"):
            map_size_y = data[data_key]
    if(not check_acess(key)):
        return ACESS_DANIED

    global map
    map = overmap(map_size_x, map_size_x)

    global process
    process = True

@app.route('/create_obj', methods=['GET'])
def create_obj(id: str, args):
    pass

@app.route('/move_obj', methods=['GET'])
def move_obj(id, new_position):
    pass

while(process):
        map.process()
