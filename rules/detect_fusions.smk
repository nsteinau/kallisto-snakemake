
rule detect_fusions:
    input:
        "star/{sample}-{unit}/Chimeric.out.junction"
    output:
        directory("fusions/{sample}-{unit}")
    params:
        index=config["ref"]["fusion_index"]
    conda:
        "../envs/starfusion.yaml"
    shell:
        "STAR-Fusion --genome_lib_dir {params.index} \
             -J {input} \
             --CPU {threads} \
             --output_dir {output}"
