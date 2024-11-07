# learning-FGDs-with-NLMs
Repo for "Learning Filler-Gap Dependencies with Neural Language Models: Testing Island Sensitivity in Norwegian and English"

Repo structure:

- `data`

Contains all data files: `test_items` contains item templates from which test sentences are created (stored in `test_sentences`).
`eval_results` contains experimental results - test sentences with surprisal values from each model. 
`lm` subfolder (ignored) should contain LM Wikipedia data for English and a checkpoint of the best-performing pre-trained model (download it from [colorlessgreenRNNs repo](https://github.com/facebookresearch/colorlessgreenRNNs/tree/main/data)). Norwegian data TBA. 

- `scripts`

Contains a script for creating test sentences (`expand_items.py`) from item templates provided in `experiments.json`, LSTM-specific scripts from [colorlessgreenRNNs repo](https://github.com/facebookresearch/colorlessgreenRNNs/tree/main/src/language_models) and jupyter notebooks evaluating the models on test sentences.

- `analyses`

TBA: R notebooks for plotting and stats.