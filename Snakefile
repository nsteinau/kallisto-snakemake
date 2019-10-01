import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.1.2")


##### load config and sample sheets #####

configfile: "config.yaml"


samples = pd.read_table(config["accessions"], header=None,names=["accessions"],index_col=False)


##### target rules #####

rule all:
    input:
        expand("kallisto_quant/{sample}",sample=samples['accessions'].tolist()),
        "counts/counts.tsv",
        "counts/tpm.tsv"


##### setup singularity #####

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"


##### setup report #####

report: "report/workflow.rst"


##### load rules #####
#include: "rules/common.smk"
#include: "rules/trim.smk"
include: "rules/pseudoalign.smk"
#include: "rules/qc.smk"
#include: "rules/detect_fusions.smk"
include: "rules/download_fastq.smk"
include: "rules/combine_counts.smk"
