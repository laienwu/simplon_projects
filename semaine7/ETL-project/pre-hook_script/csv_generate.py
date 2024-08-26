# convert data_management notebook into script.py
# todo add unit tests
import pandas as pd
from pathlib import Path
from collections import defaultdict
import re
import os

COLUMN_TYPES = defaultdict(pd.StringDtype,
                           sales='float',
                           quantity='float',
                           discount='float',
                           profit='float',
                           )
def convert_date_format(date_str):
    match = re.match(r'(\d{2})/(\d{2})/(\d{4})', date_str)
    if match:
        day, month, year = match.groups()
        return f'{year}-{month}-{day}'
    return date_str
def main(input_file: Path, output_file :Path) -> None:
    # load, drop nan , drop duplicates
    df = pd.read_csv(input_file).dropna().drop_duplicates()

    # correct wrong format date
    for col in ['order_date', 'ship_date']:
        df[col] = df[col].apply(convert_date_format)

    # correct typo (could drop)
    df['quantity'] = df['quantity'].abs()

    # save to new csv
    df.to_csv(output_file, index=False)

if __name__ == "__main__":
    input_file=os.getenv('INPUT_FILE')
    output_file=os.getenv('OUTPUT_FILE')
    main(input_file, output_file)
    os.chmod(output_file,0o777)