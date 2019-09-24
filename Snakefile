import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.1.2")


##### load config and sample sheets #####

configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, schema="schemas/samples.schema.yaml")

units = pd.read_table(config["units"], dtype=str).set_index(["sample", "unit"], drop=False)
units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])  # enforce str in index
validate(units, schema="schemas/units.schema.yaml")


##### target rules #####

rule all:
    input:
        expand("star/{sample}-{unit}/Aligned.out.bam",zip,
        sample=units.index.get_level_values(0), unit=units.index.get_level_values(1)),
        expand("star/{sample}-{unit}/ReadsPerGene.out.tab",zip,
        sample=units.index.get_level_values(0), unit=units.index.get_level_values(1)),
        "counts/all.tsv"


##### setup singularity #####

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"


##### setup report #####

report: "report/workflow.rst"

ruleorder: cutadapt > get_fastq > star_se

##### load rules #####
include: "rules/common.smk"
include: "rules/trim.smk"
include: "rules/align.smk"
include: "rules/qc.smk"
include: "rules/detect_fusions.smk"
include: "rules/download_fastq.smk"
include: "rules/diffexp.smk"
