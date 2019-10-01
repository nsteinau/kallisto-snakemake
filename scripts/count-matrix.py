
# Remove empty count tables from input


input_files = {sample:f for sample,f in zip(snakemake.params['samples'],snakemake.input['files']) if pd.read_table(f,index_col=0).sum(level='est_counts')>0}
est_counts = [pd.read_table(f, index_col=0, usecols=[0,3]) for f in values(input_files)]
tpm = [pd.read_table(f, index_col=0, usecols=[0,4]) for f in values(input_files)]

for t, sample in zip(est_counts, keys(input_files)):
    t.columns = [sample]
for t, sample in zip(tpm, keys(input_files)):
    t.columns = [sample]

est_counts = pd.concat(est_counts, axis=1)
est_counts.index.name = "transcript"
tpm = pd.concat(tpm, axis=1)
tpm.index.name = "transcript"
# collapse technical replicates

est_counts.to_csv(snakemake.output[0], sep="\t")
tpm.to_csv(snakemake.output[1], sep="\t")
