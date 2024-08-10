import pygame
from objects.processing import processing
import colors

class overmap_view (processing):

    def __init__(self, screen, surface, new_x, new_y, width, height) -> None:
        super().__init__()


        self.width = width
        self.height = height


        self.dragging = False
        self.last_mouse_x = 0
        self.last_mouse_y = 0
        self.x = new_x
        self.y = new_y

        self.screen = screen
        self.render_surface = surface

        self.camera_view = pygame.Rect(self.x, self.y, self.width, self.height)
        print(f"Camera initialized at ({self.x}, {self.y})")

    def __process__(self):
        mouse_x, mouse_y = pygame.mouse.get_pos()
        mouse_buttons = pygame.mouse.get_pressed()

        if mouse_buttons[0]:
            if not self.dragging:
                # Начало перетаскивания
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

    def __update__(self):
        self.screen.fill((0, 0, 0))
        self.screen.blit(self.render_surface, (0, 0), self.camera_view)
