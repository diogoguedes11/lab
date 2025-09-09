from google.cloud import vision


def detect_labels(image_path: str):
     client = vision.ImageAnnotatorClient()
     file_uri = image_path
     external_url_prefix = ['gs://','https://','http://']
     if external_url_prefix in image_path:
          image = vision.Image()
          image.source.image_uri = file_uri
          # Performs label detection on the image file
          response = client.label_detection(image=image)
          labels = response.label_annotations
          # print(response,image)
     print("Labels:")
     for label in labels:
          print(label.description)

     return labels