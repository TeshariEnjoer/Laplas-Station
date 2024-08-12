import pygame
import os
from objects.processing import Iprocessing, Ivisualised
import math

class object (Iprocessing, Ivisualised, pygame.sprite.Sprite):
    MINIMUM_SPEED = 0.5
    MAXIMUM_SPEED = 5

    def __init__(self, name, id, map, x, y, width, height, iconpath = "assets/obj.png"):
        Iprocessing.__init__(self)
        Ivisualised.__init__(self)
        pygame.sprite.Sprite.__init__(self)

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

        # Should we process physics parametrs
        self.static = False
        # Once how many ticks this object is allowed to move
        self.movement_colldown = 60
        self.movement_tick = 0
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
        self.image = pygame.transform.scale(self.original_texture, (self.rect.width, self.rect.height))

    def set_DMdatum(self, datum: str):
        self.DM_datum = datum

    def get_summary(self) -> str:
        summary += ""
        summary += f"id={self.id},"
        summary += f"name={self.name},"
        summary += f"x={self.x},"
        summary += f"y={self.y},"
        summary += f"angle={self.angle}"
        summary += f"rotatation={self.rotation_speed}"
        return summary

    def set_color(self, color):
        self.image.fill(color)

    # Sets new gravitation source
    def set_gravity_source(self, gsource, gforce):
        self.gsource = gsource
        self.gforce = gforce

    def set_mass(self, new_mass):
        if new_mass <= 0:
            self.mass = 1
            return
        self.mass = new_mass

    def apply_force(self, force: pygame.Vector2):
        self.acceleration += force / self.mass


    def apply_thrust(self, thrust):
        direction = pygame.Vector2(1, 0).rotate(self.angle)
        self.apply_force(direction * thrust)


    def apply_brake(self, brake_force):
        direction = pygame.Vector2(1, 0).rotate(self.angle)
        self.apply_force(-direction * brake_force)

    def set_rotation(self, force):
        self.angle += force

    def rotate(self, force):
        self.rotation_speed += force

    def limit_velocity(self):
        if self.velocity.length() > self.MAXIMUM_SPEED:
            self.velocity.scale_to_length(self.MAXIMUM_SPEED)

    def draw_id(self, surface):
        text = f"{self.name}: {self.id} "
        text += f"X: {self.x}, Y:{self.y}"
        text_surface = self.font.render(text, True, (255, 255, 255))
        text_rect = text_surface.get_rect(center=(self.rect.centerx, self.rect.bottom + 10))
        surface.blit(text_surface, text_rect)

    def __process__(self):
        if self.static:
            return

        while self.movement_tick < self.movement_colldown:
            self.movement_tick += 1

        if self.gsource:
            distance = pygame.Vector2(self.gsource.rect.center) - pygame.Vector2(self.rect.center)
            distance_length = distance.length()
            if distance_length > 0:
                gravitational_force = self.gforce * self.mass / (distance_length ** 2)
                gravitational_acceleration = gravitational_force * distance.normalize()
                self.apply_force(gravitational_acceleration)

        if(self.rotation_speed):
            self.angle += self.rotation_speed

        angle_radians = math.radians(self.angle)
        acceleration_rotated = pygame.Vector2(self.acceleration.x * math.cos(angle_radians) - self.acceleration.y * math.sin(angle_radians),
                                               self.acceleration.x * math.sin(angle_radians) + self.acceleration.y * math.cos(angle_radians))
        self.velocity += acceleration_rotated
        self.acceleration = pygame.Vector2(0, 0)

        self.angle %= 360
        self.image = pygame.transform.rotate(self.original_texture, -self.angle)
        self.rect = self.image.get_rect(center=self.rect.center)

        self.limit_velocity()

        self.x = self.rect.x
        self.y = self.rect.y
        # Actually move
        self.rect.move_ip(self.velocity)
        self.movement_tick = 0

    def __update__(self, surface: pygame.Surface):
        if super().__draw__(self.rect):
            self.draw_id(surface)
            surface.blit(self.image, self.rect)

def spawn_object(name: str, id: int, map, new_x: int, new_y: int, width: int, height: int, iconpath):
    new_obj = object(name, id, map, new_x, new_y, width, height, iconpath)
    return new_obj

def remove_object(obj: object):
    obj.destroy()


class IgravitationWell:
    def __init__(self) -> None:
        self.G = 1
        self.gravitation_radius = 0
        self.orbiting_objects = list()
        pass

    def __gravityCapture__(self):
        pass

    def set_stable_orbit(self, object):
        pass

    def can_escape(self, object):
        pass
