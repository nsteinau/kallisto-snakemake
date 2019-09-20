
rule make_samples:
    input:
        config["sra_table"]
    output:
        "samples.tsv"
        "units.tsv"
    script:
        "../scripts/make_samples.R"



rule get_fastq:
    input:
        lamda wildcards: wildcards.unit
    output:
        "{sample}-{unit}.fastq.gz"
    threads: 24
    shell:
        """
        prefetch -o {wildcards.sample}-{wildcards.unit}.sra {input}
        parallel-fastq-dump -t {threads} --gzip -O ./{output}
        """
