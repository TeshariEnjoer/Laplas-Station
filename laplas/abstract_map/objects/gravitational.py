from objects.object import IgravitationWell, object
import globals
from pygame.locals import *
import math
import pygame

class grivitational_oject (object, IgravitationWell):
    def __init__(self, name, id, map, x, y, width, height, iconpath="assets/obj.png"):
        object.__init__(self, name, id, map, x, y, width, height, iconpath)
        IgravitationWell.__init__(self)

        self.G = 1
        self.gravitation_radius = 500
        self.critical_orbit = 200
        self.static = True

    def set_gravitaion_forces(self, new_g, new_gradius, critical):
        self.G = new_g
        self.gravitation_radius = new_gradius
        self.critical_orbit = critical

    def __process__(self):
        super().__process__()
        self.__gravityCapture__()
        if(not self.orbiting_objects.__len__):
            return

        for obj in self.orbiting_objects:
            self.set_stable_orbit(obj)

    def set_stable_orbit(self, obj: object):
        dx = obj.rect.centerx - self.rect.centerx
        dy = obj.rect.centery - self.rect.centery
        distance = math.sqrt(dx**2 + dy**2)

        if distance < self.rect.width:
            return

        velocity_magnitude = math.sqrt(self.G * self.mass / distance)

        if distance <= self.critical_orbit:
            angle = math.atan2(dy, dx)
            velocity_x = -velocity_magnitude * math.sin(angle)
            velocity_y = velocity_magnitude * math.cos(angle)

            obj.apply_force(pygame.math.Vector2(velocity_x, velocity_y))

        elif self.can_escape(obj):
            # Apply acceleration towards the gravitational source
            direction = pygame.math.Vector2(-dx, -dy).normalize()
            acceleration = self.G / obj.mass
            obj.apply_force(direction * acceleration)
            obj.gsource = None #Escaping from us with addictional speed from gravitational manevr

    def can_escape(self, object : object) -> bool:
        if(globals.get_speed(object) > self.G):
            return True
        return False

    def __gravityCapture__(self):
        for obj in self.map.all_objects:
            obj = self.map.all_objects[obj]
            if globals.get_distance(self, obj) >= self.gravitation_radius or obj.static:
                continue
            if obj.mass >= 10 and (not self.can_escape(obj)):
                self.orbiting_objects.append(obj)
                obj.set_gravity_source(self, self.G)


def spawn_gsource(name: str,
                  id: int,
                  map,
                  new_x: int, new_y: int,
                  width: int, height: int,
                  iconpath, G, radius, critical):
    new_obj = grivitational_oject(name, id, map, new_x, new_y, width, height, iconpath)
    new_obj.set_gravitaion_forces(G, radius, critical)
    return new_obj
