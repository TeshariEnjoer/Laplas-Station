import pygame
from objects.object import object
from objects.object import spawn_object, remove_object
from pygame.locals import *
import colors
import config
from objects.processing import Iprocessing, Ivisualised
from objects.camera import camera
from objects.gravitational import spawn_gsource
import globals

camera_width, camera_height = 800, 600

class overmap (Iprocessing, Ivisualised):
    def __init__(self, size_x: int, size_y: int, visual: bool) -> None:
        Ivisualised.__init__(self)
        Iprocessing.__init__(self)
        # A map full size
        self.size_x = size_x
        self.size_y = size_y

        # Format "id" = obj
        self.all_objects = dict()
        self.all_ships = dict()
        self.all_planets = dict()

        if(not self.create_map()):
            print("Map creation failed")
        self.camera = camera
        self.map_holder = pygame.Surface

        self.screen = pygame.display.set_mode((camera_width, camera_height))
        if(globals.VISUALISED):
            self.camera = camera(self.screen, 5000, 5000, 800, 600)
    ## Overmap functions

    # Actually creates a non physical map, ans setups a cordinates system
    def create_map(self):
        self.map_holder = pygame.Surface((self.size_x, self.size_y))
        self.map_holder.fill(colors.BLACK)

        spawn_gsource("Planet", "001", self, 5500, 5500, 128, 128, "assets/planet.png", 50, 600, 400)
        new_obj = self.create_object("Ship", "01", 5100, 5100, "assets/ship.png", 32, 32)
        new_obj.set_mass(10)
        new_obj.set_rotation(25)
        new_obj.apply_thrust(15)
        return True

    ## Function for manipulate with objects
    def create_object(self, name, id, x, y, path, width, height):
        try:
            new_obj = spawn_object(name, id, self, x, y, width, height, path)
            self.all_objects[id] = new_obj
            return new_obj
        except:
            return False

    def create_ship():
        pass

    def destroy_object(self):
        pass

    def get_summary(self, id) -> str:
        object = self.all_object[id]
        return object.get_summary()


    def __process__(self):
        pass

    def __update__(self, surface: pygame.Surface):
        return super().__update__(surface)
