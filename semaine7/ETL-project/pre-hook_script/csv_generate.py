# convert data_management notebook into script.py
# todo add unit tests
import csv
from pathlib import Path
import re
import os


def convert_date_format(date_str):
    match = re.match(r'(\d{2})/(\d{2})/(\d{4})', date_str)
    if match:
        day, month, year = match.groups()
        return f'{year}-{month}-{day}'
    return date_str


def main(input_file, output_file):
    # Read the CSV file and store rows
    with open(input_file, mode='r', newline='',encoding="utf8") as infile:
        reader = csv.DictReader(infile)
        rows = list(reader)

    # Remove rows with missing data (None or empty strings) and drop duplicates
    unique_rows = []
    seen = set()
    for row in rows:
        if all(row.values()) and tuple(row.items()) not in seen:
            unique_rows.append(row)
            seen.add(tuple(row.items()))

    # Correct wrong format date in 'order_date' and 'ship_date' columns
    for row in unique_rows:
        for col in ['order_date', 'ship_date']:
            row[col] = convert_date_format(row[col])

    # Correct typo by ensuring 'quantity' is positive
    for row in unique_rows:
        row['quantity'] = str(int(abs(float(row['quantity']))))

    # Write the cleaned data to a new CSV file
    with open(output_file, mode='w', newline='') as outfile:
        fieldnames = unique_rows[0].keys()
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(unique_rows)


if __name__ == "__main__":
    input_file = os.getenv('INPUT_FILE', Path('../data/superstorerawdata.csv'))
    output_file = os.getenv('OUTPUT_FILE', Path('../data/superstorerawdata_cleaned.csv'))
    main(input_file, output_file)

