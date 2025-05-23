import tensorflow as tf
import tensorflow_hub as hub

# Load pre-trained model from TF Hub
model_url = "https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2"
hub_module = hub.load(model_url)

# Create a concrete function that generates embeddings
@tf.function
def get_style_embedding(image):
    # Preprocess image
    image = tf.cast(image, tf.float32)
    image = image / 255.0
    image = tf.image.resize(image, [256, 256])
    image = tf.expand_dims(image, 0)
    
    # Get style embedding
    style_embedding = hub_module.signatures['style_embedding'](image)
    return style_embedding

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_concrete_functions(
    [get_style_embedding.get_concrete_function(
        tf.TensorSpec(shape=[1, 256, 256, 3], dtype=tf.float32)
    )]
)

tflite_model = converter.convert()

# Save the TFLite model
with open('assets/models/style_prediction.tflite', 'wb') as f:
    f.write(tflite_model) 