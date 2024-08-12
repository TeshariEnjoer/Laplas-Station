import math

VISUALISED_OBJECTS = list()
PROCESSING_OBJECTS = list()

VISUALISED = True
CAMERA = any

def get_distance(first_object, second_object):
    return math.sqrt((first_object.x - second_object.x) ** 2 + (first_object.y - second_object.y) ** 2)

def get_speed(object):
    return round(math.sqrt(object.velocity.x ** 2 + object.velocity.y ** 2), 1)
