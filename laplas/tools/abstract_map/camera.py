import pygame

class camera:
    def __init__(self, screen, surface, new_x, new_y) -> None:
        self.width = 800
        self.height = 600
        self.dragging = False
        self.last_mouse_x = 0
        self.last_mouse_y = 0

        self.x = new_x
        self.y = new_y

        self.screen = screen
        self.render_surface = surface
        self.camera_rect = pygame.Rect(self.x, self.y, self.width, self.height)

    def process(self):
        for event in pygame.event.get():
            if(event.type == pygame.MOUSEBUTTONDOWN):
                if(event.button == 1):
                    self.dragging = True
                    self.last_mouse_x, self.last_mouse_y = event.pos

            if(event.type == pygame.MOUSEBUTTONUP):
                if(event.button == 1):  # Левая кнопка мыши
                    self.dragging = False

            if(event.type == pygame.MOUSEMOTION):
                if(self.dragging):
                    mouse_x, mouse_y = event.pos
                    dx = self.last_mouse_x - mouse_x
                    dy = self.last_mouse_y - mouse_y
                    self.x += dx
                    self.y += dy
                    self.last_mouse_x, self.last_mouse_y = self.x, self.y

        self.camera_rect.topleft = (self.x, self.y)
        self.screen.blit(self.render_surface, (0, 0), self.camera_rect)
        pygame.display.flip()
