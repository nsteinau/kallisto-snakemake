
rule get_fastq:
    output:
        temp("tempfastqs/{sample}/{sample}.fastq.gz")
    shell:
        """
        (prefetch -o {wildcards.sample}.sra {wildcards.sample} &&
        parallel-fastq-dump -t {threads} --gzip -s {wildcards.sample} &&
        mkdir tempfastqs &&
        mkdir tempfastqs/{wildcards.sample} &&
        mv {wildcards.sample}.fastq.gz {output} &&
        echo 'successful FASTQ download!') ||
        (touch {output} &&
        echo 'unsuccessful FASTQ download: skipping this sample')
        """
