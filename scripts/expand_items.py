import pandas as pd
import json

end_condition_included = False
autocaps = False

def expand_items(df, conditions):
    """Create output df with all item sentences (num(items)*num(conditions)) in a long format."""
    output_df = pd.DataFrame(long_format(df, conditions))
    output_df.columns = ['sent_index', 'word_index', 'word', 'region', 'condition']
    return output_df


def long_format(df, conditions):
    """Expand one item by creating n item sentences corresponding to different conditions."""
    for condition in conditions:
        for sent_index, row in df.iterrows():
            word_index = 0
            for region in conditions[condition]:
                for word in row[region].split():
                    if autocaps and word_index == 0:
                        word = word.title()
                    yield sent_index, word_index, word, region, condition
                    word_index += 1
            if not end_condition_included:
                yield sent_index, word_index + 1, ".", "end", condition
                yield sent_index, word_index + 2, "<eos>", "end", condition


def main():
    # JSON file with experimental conditions specified for each lang-dep combination
    # Total of 4 exp, with 3 lang-dep combinations in each
    with open('experiments.json') as json_data:
        exps = json.load(json_data)

    for k, v in exps.items():
        # k is the name of an experiment
        # v is a dict specifying conditions
        # Conditions differ by experiment
        input_fn = '../data/test_items/' + k + '_items.csv'
        output_fn = '../data/test_sentences/' + k + '.csv'
        input_df = pd.read_csv(input_fn, encoding='utf-8-sig', delimiter=';')
        output_df = expand_items(input_df, v)
        output_df.to_csv(output_fn, encoding='utf-8-sig')


if __name__ == "__main__":
    main()