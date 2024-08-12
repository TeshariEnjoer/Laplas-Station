import globals

class Iprocessing:
    def __init__(self) -> None:
        globals.PROCESSING_OBJECTS.append(self)

    def __del__(self):
        globals.PROCESSING_OBJECTS.remove(self)

    # Update physics
    def __process__(self):
        pass


from objects.camera import camera
import pygame

class Ivisualised:
    def __init__(self) -> None:
        pass

    def __del__(self):
        pass

    # Update visual state
    def __update__(self, surface: pygame.Surface):
        pass

    def __draw__(self, our_rect: pygame.Rect):
        if globals.CAMERA.camera_view.contains(our_rect):
            return True
        return False
