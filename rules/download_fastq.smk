
rule get_fastq:
    output:
        "{sample}-{unit}.fastq.gz"
    threads: 24
    shell:
        """
        prefetch -o {wildcards.unit}.sra {wildcards.unit}
        parallel-fastq-dump -t {threads} --gzip -s {wildcards.unit}
        mv {wildcards.unit}.fastq.gz -T {output}
        """
