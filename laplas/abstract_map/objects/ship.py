from objects.object import object

class ship (object):
    def __init__(self, name, id, map, x, y, width, height, iconpath="assets/obj.png"):
        super().__init__(name, id, map, x, y, width, height, iconpath)

    def set_rotation(self, force):
        self.angle += force

    def rotate(self, force):
        self.rotation_speed += force
