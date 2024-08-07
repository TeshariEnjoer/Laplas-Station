from flask import Flask, request
import pygame

app = Flask(__name__)
class map:
    def __init__(self, size_x: int, size_y: int) -> None:
        self.size_x = size_x
        self.size_y = size_y

        # Format "id" = obj
        self.all_object = dict()
        self.all_ships = dict()
        self.all_planets = dict()

        pygame.init()
        width, height = 800, 600
        screen = pygame.Surface((width, height))
        screen.fill(1, 1, 1)
        pygame.draw.rect(screen, (0, 0, 0), pygame.Rect(100, 100, 200, 200), 1)
        pygame.draw.circle(screen, (255, 0, 0), (400, 300), 50)

    def create_object():
        pass

@app.route('/init_map', methods=['GET'])
def init_map(args):
    pass

@app.route('/create_obj', methods=['GET'])
def create_obj(id: str, args):
    pass

@app.route('/move_obj', methods=['GET'])
def move_obj(id, new_position):
    pass
