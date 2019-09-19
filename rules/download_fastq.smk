for sra in $(cat SRA/SRR_Acc_List.txt); do prefetch -O ./fastq $sra; done

def get_sra(wildcards):
    if config["trimming"]["skip"]:
        # no trimming, use raw reads
        return units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    else:
        # yes trimming, use trimmed data
        if not is_single_end(**wildcards):
            # paired-end sample
            return expand("trimmed/{sample}-{unit}.{group}.fastq.gz",
                          group=[1, 2], **wildcards)
        # single end sample
        return "trimmed/{sample}-{unit}.fastq.gz".format(**wildcards)


rule make_samples:
    input:
        config["sra_table"]
    output:
        samples="samples.tsv"
        units="units.tsv"
    script:
        "../scripts/make_samples.R"



rule get_fastq:
    input:

    output:
        "{sample}-{unit}.fastq.gz"
