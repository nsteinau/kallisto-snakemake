def get_fq(wildcards):
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


if config["star_fusion"]:
    rule star_se:
        input:
            fq1=get_fq
        output:
            # see STAR manual for additional output files
            "star/{sample}-{unit}/Aligned.out.bam",
            "star/{sample}-{unit}/ReadsPerGene.out.tab",
            "star/{sample}-{unit}/Chimeric.out.junction"
        log:
            "logs/star/{sample}-{unit}.log"
        params:
            # path to STAR reference genome index
            index=config["ref"]["index"],
            # optional parameters
            extra=config["params"]["star"]
        threads: 24
        conda: "../envs/star.yaml"
        script: "../scripts/custom_star.py"

else:
    rule star_se:
        input:
            fq1=get_fq
        output:
            # see STAR manual for additional output files
            "star/{sample}-{unit}/Aligned.out.bam",
            "star/{sample}-{unit}/ReadsPerGene.out.tab",
        log:
            "logs/star/{sample}-{unit}.log"
        params:
            # path to STAR reference genome index
            index=config["ref"]["index"],
            # optional parameters
            extra=config["params"]["star"]
        threads: 24
        conda: "../envs/star.yaml"
        script: "../scripts/custom_star.py"
