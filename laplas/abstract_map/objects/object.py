import pygame

class object:
    DM_datum = "datum/overmap"

    def __init__(self, x, y, width, height, icon = ""):
        self.iconpath = self.texture_path + icon
        # Draw parametrs
        self.original_texute = pygame.image.load(self.iconpath).convert_alpha()
        self.texute = self.original_texute
        self.rect = self.image.get_rect(center=(x, y))
        self.rect.width = width
        self.rect.height = height

        # Physical parametr

        # Our current velocity
        self.velocity = pygame.Vector2(0, 0)
        # A temporary acceleration that we get
        self.acceleration = pygame.Vector2(0, 0)

        self.angle = 0
        self.rotation_speed = 0


    # Applied new temporary acceleration
    def apply_force(self, force: pygame.Vector2):
        self.acceleration += force

    def apply_thrust(self, thrust):
        direction = pygame.Vector2(1, 0).rotate(self.angle)
        self.apply_force(direction * thrust)

    def apply_brake(self, brake_force):
        direction = pygame.Vector2(1, 0).rotate(self.angle)
        self.apply_force(-direction * brake_force)

    def update(self):
        self.velocity += self.acceleration
        self.rect.center += pygame.Vector2(self.velocity.x, self.velocity.y)
        self.acceleration = pygame.Vector2(0, 0)

        self.angle %= 360
        self.image = pygame.transform.rotate(self.original_texute, -self.angle)
        self.rect = self.image.get_rect(center=self.rect.center)

    def draw(self, screen):
        pygame.draw.rect(screen, self.rect)
