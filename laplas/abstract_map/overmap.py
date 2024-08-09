import pygame
from objects import object
from objects import camera


camera_width, camera_height = 800, 600

class overmap:
    def __init__(self, size_x: int, size_y: int, visual: bool) -> None:
        # A map full size
        self.size_x = size_x
        self.size_y = size_y


        self.all_object = list()
        # Format "id" = obj
        self.all_ships = dict()
        # Format "id" = obj
        self.all_planets = dict()

        self.screen = pygame.display.set_mode((camera_width, camera_height))
        self.create_map()
        self.create_camera()

        self.clock = pygame.time.Clock()
        pygame.display.set_caption("Large Map with Coordinate System")
        self.camera = camera

    ## Overmap functions

    # Actually creates a non physical map, ans setups a cordinates system
    def create_map(self):
        self.map_holder = pygame.Surface((self.size_x, self.size_y))
        self.map_holder.fill((25, 25, 25))


    def create_camera(self):
        camera_x, camera_y = 1, 1
#        self.camera = camera(self.map_holder, self.screen, camera_x, camera_y)

    ## Function for manipulate with objects
    def create_object(self, obj, args):
        pass

    def remove_object(self):
        pass

    def adjust_speed(self):
        pass

    def process(self):
#        self.camera.process(self.camera)
        self.clock.tick(60)

        if(not self.all_object.__len__()):
            return
        for obj in self.all_object:
            obj.process()


def process_map(state: bool):
    while(state):
        overmap.process()
