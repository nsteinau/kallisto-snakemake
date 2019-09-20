
rule detect_fusions:
    input:
        "star/{sample}-{unit}/Chimeric.out.junction"
    output:
        directory("fusions/{sample}-{unit}")
    params:
        index=config["ref"]["index"]
    conda:
        "../envs/meta.yaml"
    shell:
        "STAR-Fusion --genome_lib_dir {params.index} \
             -J {input} \
             --output_dir {output}"
