
rule get_fastq:
    output:
        temp("{sample}-{unit}.fastq.gz")


    threads: 24
    shell:
        """
        (prefetch -o {wildcards.unit}.sra {wildcards.unit} &&
        parallel-fastq-dump -t {threads} --gzip -s {wildcards.unit} &&
        mv {wildcards.unit}.fastq.gz -T {output[0]} &&
        echo 'successful FASTQ download!') ||
        (touch {output[0]} &&
        mkdir star/{wildcards.sample}-{wildcards.unit} &&
        touch star/{wildcards.sample}-{wildcards.unit}/Aligned.out.bam &&
        touch star/{wildcards.sample}-{wildcards.unit}/ReadsPerGene.out.tab &&
        echo 'unsuccessful FASTQ download: skipping this sample')
        """
