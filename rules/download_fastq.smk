
rule get_fastq:
    output:
        temp("{sample}-{unit}.fastq.gz"),
        "star/{sample}-{unit}/Aligned.out.bam",
        "star/{sample}-{unit}/ReadsPerGene.out.tab"


    threads: 24
    shell:
        """
        prefetch -o {wildcards.unit}.sra {wildcards.unit}
        parallel-fastq-dump -t {threads} --gzip -s {wildcards.unit}
        mv {wildcards.unit}.fastq.gz -T {output[0]}
        echo 'successful FASTQ download!' ||
        touch {output[1]}
        touch {output[2]}
        echo 'unsuccessful FASTQ download: skipping this sample'
        """
