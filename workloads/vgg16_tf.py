import tensorflow as tf
import numpy as np
from tensorflow.keras.applications import vgg16
import argparse

if __name__=="__main__":
    gpus = tf.config.list_physical_devices('GPU')
    if gpus:
        print("******************************")
        try:
            # Currently, memory growth needs to be the same across GPUs
            print(gpus)
            for gpu in gpus:
                tf.config.experimental.set_memory_growth(gpu, True)
            logical_gpus = tf.config.list_logical_devices('GPU')
            print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
            # print("---------------------------------")
        except RuntimeError as e:
            # Memory growth must be set before GPUs have been initialized
            print(e)

    parser = argparse.ArgumentParser(description ='Provide options to run total images and how many images to process at once on GPU.')
    parser.add_argument('--batch-size', action="store", dest="batch_size", default=32, type=int, help='Provide the batch size, for e.g. --batch-size 50')
    args = parser.parse_args()

    data_dir = '/home/ub-11/mitali/Small-ImageNet-Validation-Dataset-1000-Classes/ILSVRC2012_img_val_subset'
    class_names = []
    for i in range(1000):
        class_names.append(str(i))
    val_datasets = tf.keras.utils.image_dataset_from_directory(data_dir, shuffle=True, batch_size=args.batch_size, image_size = (224,224), class_names = class_names)

    AUTOTUNE = tf.data.AUTOTUNE
    # Use buffered prefetching to load images from disk without having I/O become blocking
    val_datasets = val_datasets.prefetch(buffer_size=AUTOTUNE)

    vgg_model = vgg16.VGG16(weights = 'imagenet')
    correct = 0
    total = 0
    for image_batch, label_batch in val_datasets:
        preds = vgg_model.predict(vgg16.preprocess_input(image_batch), verbose = 0)
        correct += (label_batch.numpy() == tf.argmax(preds, axis = 1).numpy()).sum()
        total += len(label_batch)
        break
    
    acc = correct/total * 100
    print('[Validation] Acc: {:.4f}%'.format(acc))