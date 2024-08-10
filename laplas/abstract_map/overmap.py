import pygame
from objects.object import object
from objects.object import spawn_object, remove_object
from pygame.locals import *
import colors
import config
from objects.processing import processing
from objects.camera import overmap_view

camera_width, camera_height = 800, 600

class overmap (processing):
    def __init__(self, size_x: int, size_y: int, visual: bool) -> None:
        super().__init__()
        # A map full size
        self.size_x = size_x
        self.size_y = size_y


        self.all_object = list()
        # Format "id" = obj
        self.all_ships = dict()
        # Format "id" = obj
        self.all_planets = dict()

        self.screen = pygame.display.set_mode((camera_width, camera_height))
        if(not self.create_map()):
            print("Map creation failed")
        self.camera = overmap_view

    ## Overmap functions

    # Actually creates a non physical map, ans setups a cordinates system
    def create_map(self):
        self.map_holder = pygame.Surface((self.size_x, self.size_y))
        self.map_holder.fill(colors.BLACK)

        self.camera = overmap_view(self.screen, self.map_holder, 5000, 5000, 800, 600)
        obj = spawn_object("Test object", "1", self.map_holder, 5000, 5000, 32, 32, "assets/object.png")
        obj.apply_force(pygame.Vector2(1, 0))
        return True

    ## Function for manipulate with objects
    def create_object(self, name, id, x, y, path):
        spawn_object("Test object", "1", self.map_holder, 5000, 5000, 32, 32, "assets/object.png")


    def destroy_object(self):
        pass

    def __process__(self):
        pass

    def __update__(self):
        pass
