# learning-FGDs-with-NLMs

Repo for "Learning Filler-Gap Dependencies with Neural Language Models: Testing Island Sensitivity in Norwegian and English"

Repo structure:

- `data`

Contains all data files: `test_items` contains item templates from which test sentences are created (stored in `test_sentences`).
`results` contains experimental results - test sentences with surprisal values from each model. 
`lm` subfolder (ignored for now) contains Wikipedia and model data for English and Norwegian LSTMs. For English, the data and a checkpoint for the best-performing pre-trained model can be downloaded from the [colorlessgreenRNNs repo](https://github.com/facebookresearch/colorlessgreenRNNs/tree/main/data)). Norwegian data and model will be added soon. 

- `scripts`

Contains a script for creating test sentences (`expand_items.py`) from item templates provided in `experiments.json`, LSTM-specific scripts from [colorlessgreenRNNs repo](https://github.com/facebookresearch/colorlessgreenRNNs/tree/main/src/language_models) and jupyter notebooks evaluating the models on test sentences (= getting the surprisal values).

- `analyses`

TBU with R notebooks for plotting and stats.