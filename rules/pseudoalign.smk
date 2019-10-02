
rule kallisto_quant:
    input:
        "{sample}.fastq.gz"
    output:
        'kallisto_quant/{sample}/abundance.tsv'
    params:
        index = config["ref"]["index"],
        outdir = 'kallisto_quant/{sample}',
        extra = ""
    threads: 32
    log:
        "logs/kallisto_quant_{sample}.log"
    shell:
        """
        kallisto quant -i {params.index} --single -l 200 -s 30 -t {threads} -o {params.outdir} {input} ||
        touch {output}
        """
