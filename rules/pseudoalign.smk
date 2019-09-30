
rule kallisto_quant:
    input:
        "tempfastqs/{sample}/{sample}.fastq.gz"
    output:
        directory('kallisto_quant/{sample}')
    params:
        index = config["ref"]["index"],
        extra = ""
    log:
        "logs/kallisto_quant_{sample}.log"
    shell:
        """
        kallisto quant -i {params.index} --single -l 200 -s 30 -t {threads} -o {output} {input} ||
        touch {output}
        """
