import globals

class processing:
    def __init__(self) -> None:
        globals.PROCESSING_OBJECTS.append(self)

    def __del__(self):
        globals.PROCESSING_OBJECTS.remove(self)

    # Update physics
    def __process__(self):
        pass

    # Update visual state
    def __update__(self):
        pass
