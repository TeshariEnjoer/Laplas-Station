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

        print(f"Camera initialized at ({self.x}, {self.y})")  # Отладочный вывод

    def process(self):
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:
                    self.dragging = True
                    self.last_mouse_x, self.last_mouse_y = event.pos
                    print(f"Started dragging at ({self.last_mouse_x}, {self.last_mouse_y})")

            if event.type == pygame.MOUSEBUTTONUP:
                if event.button == 1:
                    self.dragging = False
                    print("Stopped dragging")

            if event.type == pygame.MOUSEMOTION:
                if self.dragging:
                    mouse_x, mouse_y = event.pos
                    dx = mouse_x - self.last_mouse_x
                    dy = mouse_y - self.last_mouse_y
                    self.x -= dx
                    self.y -= dy
                    self.last_mouse_x, self.last_mouse_y = mouse_x, mouse_y

                    print(f"Dragging to ({self.x}, {self.y})")

        self.camera_rect.topleft = (self.x, self.y)
        self.screen.blit(self.render_surface, (0, 0), self.camera_rect)
        print(f"Camera rect top-left at ({self.camera_rect.x}, {self.camera_rect.y})")  # Отладочный вывод
