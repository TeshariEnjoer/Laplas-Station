import pygame



class overmap:
    process = False

    def __init__(self, size_x: int, size_y: int, visual: bool) -> None:
        self.size_x = size_x
        self.size_y = size_y

        # Format "id" = obj
        self.all_object = dict()
        self.all_ships = dict()
        self.all_planets = dict()


        if(visual):
            self.init_window()


    ## Overmap functions
    def init_window():
        pygame.init()


        width, height = 800, 600
        screen = pygame.Surface((width, height))
        screen.fill(1, 1, 1)

        pygame.draw.rect(screen, (0, 0, 0), pygame.Rect(100, 100, 200, 200), 1)
        pygame.draw.circle(screen, (255, 0, 0), (400, 300), 50)

    def create_camera():
        pass

    ## Function for manipulate with objects
    def create_object():
        pass

    def remove_object():
        pass

    def adjust_speed():
        pass

    while process:
        pass
