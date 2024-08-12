import pygame
import globals
from objects.processing import Iprocessing
from globals import PROCESSING_OBJECTS


class camera (Iprocessing):
    def __init__(self, screen, new_x, new_y, width, height) -> None:
        self.width = width
        self.height = height


        self.dragging = False
        self.last_mouse_x = 0
        self.last_mouse_y = 0
        self.zoom_level = 1.0
        self.x = new_x
        self.y = new_y

        self.screen = screen

        self.camera_view = pygame.Rect(self.x, self.y, self.width, self.height)
        print(f"Camera initialized at ({self.x}, {self.y})")
        globals.CAMERA = self


    def __process__(self):
        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_buttons = pygame.mouse.get_pressed()
        events = pygame.event.get()

        if mouse_buttons[0]:
            if not self.dragging:
                self.dragging = True
                self.last_mouse_x = mouse_x
                self.last_mouse_y = mouse_y
            else:
                dx = mouse_x - self.last_mouse_x
                dy = mouse_y - self.last_mouse_y

                self.camera_view.x -= dx
                self.camera_view.y -= dy

                self.last_mouse_x = mouse_x
                self.last_mouse_y = mouse_y
        else:
            self.dragging = False

    def draw(self):
        self.screen.fill((0, 0, 0))
        rendered_surface = pygame.Surface((self.camera_view.x + self.width, self.camera_view.y + self.height))
        for obj in globals.PROCESSING_OBJECTS:
            obj.__update__(rendered_surface)
        self.screen.blit(rendered_surface, (0, 0), self.camera_view)
        del rendered_surface
