import threading
import pygame
from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse
import io
import config

SUCCESS = "success"
FAILED = "failed"
ERROR = "error"
ACCESS_DENIED = "Access to map denied due the wrong key!"
VISUAL = True

from overmap import overmap

# Important globals
acess_key = None
map_instance = overmap
process = True
httpd = HTTPServer

def check_access(key):
    global acess_key

    if not acess_key:
        acess_key = key
        print(f'New access key for overmap applied: {acess_key}')

    if key == acess_key:
        return True
    return False

def get_param(params, name, default=''):
    return params.get(name, [default])[0]

def handle_ping(query):
    return SUCCESS, 200

def handle_set_key(query):
    global acess_key
    key = urllib.parse.parse_qs(query).get('key', [''])[0].strip()
    if acess_key:
        return 'ABSTRACT MAP ERROR: ATTEMPT REPLACE EXISTED ACCESS KEY', 400
    if not key:
        return 'ABSTRACT MAP ERROR: ATTEMPT SET HTTP KEY WITH UNEXISTED STRING', 400
    acess_key = key
    print(f'New access key for overmap applied: {acess_key}')
    return SUCCESS, 200

def handle_reset_key(query):
    global acess_key

    key = urllib.parse.parse_qs(query).get('key', [''])[0].strip()
    if key == acess_key:
        acess_key = None
        return SUCCESS, 200
    return FAILED, 400

def handle_init_map(query):
    global map_instance
    params = urllib.parse.parse_qs(query)
    key = params.get('key', [''])[0]
    size_x = int(params.get('size_x', ['1'])[0])
    size_y = int(params.get('size_y', ['1'])[0])
    if key != acess_key:
        return ACCESS_DENIED, 403
    map_instance = overmap(size_x, size_y, VISUAL)
    return SUCCESS, 200

def handle_create_obj(query):
    global map_instance

    if not map_instance:
        return 'Trying spawn object while no active map instance', 400

    print(f"{query}")
    params = urllib.parse.parse_qs(query)
    print(f"{params}")
    name = get_param(params, 'name', 'undefined')
    print(name)
    id = get_param(params, 'id', '0')
    print(id)
    new_x = int(get_param(params, 'x', 1000))
    print(new_x)
    new_y = int(get_param(params, 'y', 1000))
    width = int(get_param(params, 'width', 32))
    height = int(get_param(params, 'height', 32))
    class_type = get_param(params, 'class_type', 'object')
    texture_path = get_param(params, 'texture_path', 'assets/object.png')

    if class_type == 'object' or not class_type:
        try:
            map_instance.create_object(
                name=name,
                id=id,
                x=new_x,
                y=new_y,
                path=texture_path,
                width=width,
                height=height,
            )
        finally:
            print(f'Trying to spawn object with data: {name}, {id}, {new_x}, {new_y}, {width}, {height}, {class_type}, {texture_path}')
            return f'Failed to spawn new object: {name} - {id}', 403
    if class_type == 'grivitational_oject' :
        pass


def handle_object_movement(query):
    params = urllib.parse.parse_qs(query)
    global map_instance
    id = get_param(params, 'id', '')
    obj = map_instance.all_objects[id]
    if(not obj):
        return f'Trying get object with unexisted id, {id}', 400
    move_type = get_param(params, 'move_type', '')
    new_value = get_param(params, 'value', '')
    return_value = ''

    if(move_type == 'thrust'):
        obj.apply_thrust(new_value)
        return f'{obj.speed}', 200

    elif(move_type == 'set_rotation'):
        obj.set_rotation(new_value)
        return f'{obj.angle}', 200

    elif(move_type == 'apply_rotation'):
        obj.rotate(new_value)
        return f'{obj.rotation_speed}', 200

    elif(move_type == 'brake'):
        obj.apply_brake(new_value)
        return f'{obj.speed}', 200

    return f'Get ivalid move_type, while trying move object with id {obj.id}', 400

def handle_sync(query):
    params = urllib.parse.parse_qs(query)
    if(not check_access(get_param(params, 'key', ''))):
        return ACCESS_DENIED, 403
    global map_instance
    id = get_param(params, 'id', '')
    obj = map_instance.all_objects[id]
    if(not obj):
        return f'Trying get object with unexisted id, {id}', 400

    data = ''
    data += f'speed = {obj.speed}'
    data += f'angle = {obj.angle}'
    data += f'rotation_speed = {obj.rotation_speed}'
    data += f'x = {obj.x}'
    data += f'y = {obj.y}'
    return data, 200


ROUTES = {
    '/': {
        'GET': handle_ping,
        'POST': handle_ping
    },
    '/set_key': {
        'GET': handle_set_key,
        'POST': handle_set_key
    },
    '/reset_key': {
        'GET': handle_reset_key,
        'POST': handle_reset_key
    },
    '/init_map': {
        'GET': handle_init_map,
        'POST': handle_init_map
    },
    '/create_obj': {
        'GET': handle_create_obj,
        'POST': handle_create_obj
    },
    '/move_obj': {
        'GET': handle_object_movement,
        'POST': handle_object_movement
    }
}

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.handle_request(self.path, self.command, self.rfile, self.headers)

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode()
        self.handle_request(self.path, 'POST', io.StringIO(post_data), self.headers)

    def handle_request(self, path, method, data_source, headers):
        parsed_path = urllib.parse.urlparse(path)
        route = ROUTES.get(parsed_path.path)
        if route:
            handler = route.get(method)
            if handler:
                if method == 'POST':
                    query = data_source.getvalue()
                else:
                    query = parsed_path.query

                response, status_code = handler(query)
                self.send_response(status_code)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(response.encode())
                return

        self.send_response(404)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Function not found!')

def run_http_server():
    global httpd
    server_address = ("127.0.0.1", 5000)
    print(f"Running on: http://{server_address[0]}:{server_address[1]}/")
    httpd = HTTPServer(server_address, RequestHandler)

    print("Starting HTTP server")
    httpd.serve_forever()

import globals
import os
import ctypes

def game_loop():
    print("Initializing overmap")
    global process
#    ctypes.windll.user32.ShowWindow(ctypes.windll.kernel32.GetConsoleWindow(), 0)
#    os.environ['SDL_VIDEODRIVER'] = 'dummy'
    pygame.init()
    pygame.font.init()
    global map_instance

    clock = pygame.time.Clock()
    map_instance = overmap(5000, 5000, True)
    pygame.display.set_caption("Overmap")
    print("Initialization complete")

    while process:
        clock.tick(config.FPS)

        # First get input
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                process = False
                pygame.quit()
                break

        # Main processing loop
        for obj in globals.PROCESSING_OBJECTS:
            obj.__process__() # Updating physics, controls and e.t.c
        if(globals.VISUALISED):
            globals.CAMERA.draw()
            globals.CAMERA.__process__()

        pygame.display.flip()
        pygame.time.wait(10)

    pygame.exit()

if __name__ == '__main__':
    game_thread = threading.Thread(target=game_loop)
    game_thread.start()

    run_http_server()
