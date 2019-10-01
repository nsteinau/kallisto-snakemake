
samples = pd.read_table(config["accessions"], header=None,names=["accessions"],index_col=False).loc([:,'accessions']).tolist()

rule count_matrix:
    input:
        files=expand('kallisto_quant/{samps}/abundance.tsv',samps=samples),
    output:
        "counts/counts.tsv",
        "counts/tpm.tsv"
    params:
        samples = samples
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/count-matrix.py"
