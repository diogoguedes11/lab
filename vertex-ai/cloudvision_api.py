from google.cloud import vision


def detect_labels(image_path):
     client = vision.ImageAnnotatorClient()
     file_uri = "./image.png"
     
     image = vision.Image()
     image.source.image_uri = file_uri