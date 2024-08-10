import pygame
import os
from objects.processing import processing

class object (processing):
    def __init__(self, name, id, map, x, y, width, height, iconpath = "assets/obj.png"):
        super().__init__()

        self.name = name
        self.id = id
        self.DM_datum = "datum/overmap"
        self.iconpath = iconpath
        # Draw params:

        self.rect = pygame.Rect(x, y, width, height)
        self.original_texture = any
        self.load_texture()

        # Positional params:

        self.x = x
        self.y = y
        self.map = map

        print(f"Created new object {self.name}, with id {self.id}, with icon {self.iconpath}, on {self.x}: {self.y}")
        # Physical params:

        # Our current velocity.
        self.velocity = pygame.Vector2(0, 0)
        # A temporary acceleration that we get.
        self.acceleration = pygame.Vector2(0, 0)
        # A gravitational object that affects us. E.t.c Planet, star, blackhole
        self.gsource = None
        self.gforce = None
        # Our mass, effects on gravity forcess
        self.mass = 1
        # Our angle of inclination, relative to it will be set velocity.
        self.angle = 0
        # The speed at which we're spinning.  Positive values are rotation to the right, negative values are rotation to the left.
        self.rotation_speed = 0

        self.font = pygame.font.SysFont(None, 12)

    def destroy(self):
        del self.original_texture
        del self.image
        del self.rect
        del self

    def load_texture(self):
        current_directory = os.path.dirname(os.path.abspath(__file__))
        parent = os.path.dirname(current_directory)

        final_path = os.path.join(parent, self.iconpath)
        final_path = final_path.replace("\\", "/")

        self.image = pygame.image.load(final_path)
        self.original_texture = self.image.copy()

    def set_color(self, color):
        self.image.fill(color)

    # Sets new gravitation source
    def set_gravity_source(self, gsource, gforce):
        self.gsource = gsource
        self.gforce = gforce


    def apply_force(self, force: pygame.Vector2):
        self.acceleration += force / self.mass


    def apply_thrust(self, thrust):
        direction = pygame.Vector2(1, 0).rotate(self.angle)
        self.apply_force(direction * thrust)


    def apply_brake(self, brake_force):
        direction = pygame.Vector2(1, 0).rotate(self.angle)
        self.apply_force(-direction * brake_force)

    def rotate(self, force):
        pass

    def set_rotation(self, force):
        pass

    def draw_id(self):
        text = f"{self.name}: {self.id} "
        text += f"X: {self.x}, Y:{self.y}"
        text_surface = self.font.render(text, True, (255, 255, 255))
        text_rect = text_surface.get_rect(center=(self.rect.centerx, self.rect.bottom + 10))
        self.map.blit(text_surface, text_rect)

    def __process__(self):
        if self.gsource:
            distance = pygame.Vector2(self.gsource.rect.center) - pygame.Vector2(self.rect.center)
            distance_length = distance.length()
            if distance_length > 0:
                gravitational_force = self.gforce * self.mass / (distance_length ** 2)
                gravitational_acceleration = gravitational_force * distance.normalize()
                self.apply_force(gravitational_acceleration)


        self.velocity += self.acceleration
        self.rect.center += self.velocity
        self.acceleration = pygame.Vector2(0, 0)

        self.angle %= 360
        self.image = pygame.transform.rotate(self.original_texture, -self.angle)
        self.rect = self.image.get_rect(center=self.rect.center)

        self.x = self.velocity.x
        self.y = self.velocity.y
        # Actually move
        self.rect.move_ip(self.velocity)

    def __update__(self):
        self.draw_id()
        self.map.blit(self.image, (self.x, self.y))

def spawn_object(name: str, id: int, map: pygame.surface, new_x: int, new_y: int, width: int, height: int, iconpath):
    new_obj = object(name, id, map, new_x, new_y, width, height, iconpath)
    return new_obj

def remove_object(obj: object):
    obj.destroy()
