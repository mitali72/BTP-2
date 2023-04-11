import argparse
from transformers import AutoTokenizer, DataCollatorWithPadding, AutoModelWithLMHead
import torch
import argparse
from datasets import load_dataset
import random
import time

def preprocess_function(examples):
    return tokenizer(examples["text"], truncation=True)

def load_data():
    imdb = load_dataset("imdb")
    tokenized_imdb = imdb["test"].map(preprocess_function, batched=True)
    return tokenized_imdb

LABEL_DICT = {"negative":0,"positive": 1}

if __name__=="__main__":

    parser = argparse.ArgumentParser(description ='Provide options to run total videos and how many videos to process at once on GPU.')
    parser.add_argument('--batch-size', action="store", dest="batch_size", default=False, type=int, help='Provide the batch size, for e.g. --batch-size 50')
    args = parser.parse_args()

    device = torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu")
    batch_size = args.batch_size

    tokenizer = AutoTokenizer.from_pretrained("mrm8488/t5-base-finetuned-imdb-sentiment")
    data_collator = DataCollatorWithPadding(tokenizer=tokenizer)

    tokenized_imdb = load_data()
    model = AutoModelWithLMHead.from_pretrained("mrm8488/t5-base-finetuned-imdb-sentiment")
    model = model.to(device=device)
    test_labels = torch.Tensor(tokenized_imdb["label"]).to(device)
    # total_reviews = test_labels.size(dim = 0)
    total_reviews = 1000
    correct_pred= 0

    start = time.time()
    with torch.no_grad():
        for i in range(0,total_reviews , batch_size):
            try:
                batch_tokens = tokenized_imdb[i:min(i+batch_size, total_reviews)]
                batch_tokens = {key: batch_tokens[key] for key in ["input_ids"]}
                batch_tokens = data_collator(batch_tokens)
                batch_tokens = batch_tokens.to(device)

                output = model.generate(input_ids=batch_tokens["input_ids"],max_length=2)
                # print([tokenizer.decode(ids) for ids in output[:0]])
                # print([tokenizer.decode(ids) for ids in output[:,1]])
                pred_labels = torch.Tensor([LABEL_DICT[tokenizer.decode(ids)] for ids in output[:,1]]).to(device)
                correct_pred += (test_labels[i:min(i+batch_size, total_reviews)] == pred_labels).sum()
                
            except RuntimeError as e:
                print(e)
                break
    
    end = time.time()
    print(f'Time taken to classify text, in a batch of {batch_size} together, for a total number of reviews being {total_reviews} is {end-start}')
    print(f"Accuracy = {(correct_pred/total_reviews)*100}%")
