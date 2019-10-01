
rule get_fastq:
    output:
        temp("{sample}.fastq.gz")
    threads: 32
    shell:
        """
        (prefetch -o {wildcards.sample}.sra {wildcards.sample} &&
        parallel-fastq-dump -t {threads} --gzip -s {wildcards.sample} -O . &&
        mv {wildcards.sample}.fastq.gz {output} &&
        echo 'successful FASTQ download!') ||
        (touch {output} &&
        echo 'unsuccessful FASTQ download: skipping this sample')
        """
