from google.cloud import pubsub_v1
import os
publisher = pubsub_v1.PublisherClient()
topic = os.environ.get("PUBSUB_TOPIC")

data = b'{"name": "Diogo"}'
future = publisher.publish(topic,data)
future.result()