import torch
import torch.nn as nn
import torchvision.transforms as transforms
from urllib.request import urlretrieve
import json
import PIL
from torchvision.models import resnet50, ResNet50_Weights
import os
from torchvision import datasets
import argparse
import time
import torchvision

class Normalize(nn.Module) :
    def __init__(self, mean, std) :
        super(Normalize, self).__init__()
        self.register_buffer('mean', torch.Tensor(mean))
        self.register_buffer('std', torch.Tensor(std))
        
    def forward(self, input):
        mean = self.mean.reshape(1, 3, 1, 1)
        std = self.std.reshape(1, 3, 1, 1)
        return (input - mean) / std

def image_loader(path):
    image = PIL.Image.open(path)
    image = preprocess(image).unsqueeze(0)
    return image.to(device, torch.float)

def validate(model):

    # criterion = nn.CrossEntropyLoss()
    model.eval().to(device)
    # start_time = time.time()

    with torch.no_grad():
        # running_loss = 0.
        running_corrects = 0

        for i, (inputs, basic_labels) in enumerate(val_dataloader):
            inputs = inputs.to(device)
            labels = torch.zeros_like(basic_labels).to(device)
            for j in range(labels.shape[0]):
                labels[j] = int(class_names[basic_labels[j]])
            labels = labels.to(device)

            outputs = model(inputs)
            _, preds = torch.max(outputs, 1)
            # loss = criterion(outputs, labels)

            # running_loss += loss.item() * inputs.size(0)
            running_corrects += torch.sum(preds == labels.data)

        # epoch_loss = running_loss / len(val_datasets)
        epoch_acc = running_corrects / len(val_datasets) * 100.
        print('[Validation] Acc: {:.4f}%'.format(epoch_acc))
        
if __name__=="__main__":
    parser = argparse.ArgumentParser(description ='Provide options to run total images and how many images to process at once on GPU.')
    parser.add_argument('--batch-size', action="store", dest="batch_size", default=32, type=int, help='Provide the batch size, for e.g. --batch-size 50')
    args = parser.parse_args()

    use_cuda = True
    device = torch.device("cuda" if use_cuda else "cpu")

    # with open('Small-ImageNet-Validation-Dataset-1000-Classes/imagenet.json') as f:
    #     imagenet_labels = json.load(f)


    weights = ResNet50_Weights.DEFAULT
    model = resnet50(weights=weights)
    model.eval().to(device)
    preprocess = weights.transforms()
    # Load validation dataset

    data_dir = '/home/ub-11/mitali/Small-ImageNet-Validation-Dataset-1000-Classes/ILSVRC2012_img_val_subset'

    val_datasets = datasets.ImageFolder(os.path.join(data_dir), preprocess)
    val_dataloader = torch.utils.data.DataLoader(val_datasets, batch_size=args.batch_size, shuffle=True, num_workers=4)
    print('Validation dataset size:', len(val_datasets))

    class_names = val_datasets.classes
    print('The number of classes:', len(class_names))

    validate(model)
    
   