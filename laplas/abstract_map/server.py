import threading
import pygame
from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse
import io
import config

SUCCESS = "success"
FAILED = "failed"
ERROR = "error"
ACCESS_DENIED = "Access to map denied due to wrong key!"
VISUAL = True

from overmap import overmap

# Important globals
acess_key = None
map_instance = overmap
process = True
httpd = HTTPServer

def check_access(key):
    global acess_key
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
        return FAILED, 400

    params = urllib.parse.parse_qs(query)
    key = get_param(params, 'key', '')

    if not check_access(key):
        return ACCESS_DENIED, 403

    name = get_param(params, 'name', 'undefined')
    id = get_param(params, 'id', '0')
    new_x = int(get_param(params, 'x', 1000))
    new_y = int(get_param(params, 'y', 1000))
    width = int(get_param(params, 'width', 32))
    height = int(get_param(params, 'height', 32))
    class_type = get_param(params, 'class_type', 'object')
    texture_path = get_param(params, 'texture_path', 'assets/object.png')
    if class_type == 'object' or not class_type or class_type == '':
        result = map_instance.create_object(
            name=name,
            id=id,
            x=new_x,
            y=new_y,
            path=texture_path,
            width=width,
            height=height,
        )
        return result, 200
    if class_type == 'grivitational_oject' :
        pass

    return result, 200

def handle_move_obj(query):
    return 'OBJECT MOVEMENT PLACEHOLDER', 200

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
        'GET': handle_move_obj,
        'POST': handle_move_obj
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

def game_loop():
    print("Initializing overmap")
    global process
    pygame.init()
    pygame.font.init()

    clock = pygame.time.Clock()
    map_instance = overmap(50000, 50000, True)
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
