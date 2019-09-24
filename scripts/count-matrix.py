import pandas as pd
import os
def get_column(strandedness):
    if pd.isnull(strandedness) or strandedness == "none":
        return 1 #non stranded protocol
    elif strandedness == "yes":
        return 2 #3rd column
    elif strandedness == "reverse":
        return 3 #4th column, usually for Illumina truseq
    else:
        raise ValueError(("'strandedness' column should be empty or have the "
                          "value 'none', 'yes' or 'reverse', instead has the "
                          "value {}").format(repr(strandedness)))

# Remove empty count tables from input

def is_non_zero_file(fpath):
    return os.path.isfile(fpath) and os.path.getsize(fpath) > 0
input_files = [f for f in snakemake.input if is_non_zero_file(f)]

counts = [pd.read_table(f, index_col=0, usecols=[0, get_column(strandedness)],
          header=None, skiprows=4)
          for f, strandedness in zip(input_files, snakemake.params.strand)]

for t, sample in zip(counts, snakemake.params.samples):
    t.columns = [sample]

matrix = pd.concat(counts, axis=1)
matrix.index.name = "gene"
# collapse technical replicates
matrix = matrix.groupby(matrix.columns, axis=1).sum()
matrix.to_csv(snakemake.output[0], sep="\t")
