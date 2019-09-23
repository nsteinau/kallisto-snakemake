import os
from snakemake.shell import shell

extra = snakemake.params.get("extra", "")
log = snakemake.log_fmt_shell(stdout=True, stderr=True)

fq1 = snakemake.input.get("fq1")
fq1 = str(fq1)
# assert fq1 is not None, "input-> fq1 is a required input parameter"
# fq1 = [snakemake.input.fq1] if isinstance(snakemake.input.fq1, str) else snakemake.input.fq1
# fq2 =  snakemake.input.get("fq2")
# if fq2:
#     fq2 = [snakemake.input.fq2] if isinstance(snakemake.input.fq2, str) else snakemake.input.fq2
#     assert len(fq1) == len(fq2), "input-> equal number of files required for fq1 and fq2"
# input_str_fq1 = fq
# input_str_fq2 = ",".join(fq2) if fq2 is not None else ""
# input_str =  " ".join([input_str_fq1, input_str_fq2])

if fq1.endswith(".gz"):
    readcmd = "--readFilesCommand zcat"
else:
    readcmd = ""

if snakemake.config["star_fusion"]:
    commands = extra
else:
    commands = "--genomeLoad LoadAndKeep"

outprefix = os.path.dirname(snakemake.output[0]) + "/"
GTF = "--sjdbGTFfile {}".format(snakemake.config["ref"]["annotation"])

shell(
    "STAR "
    "--quantMode GeneCounts "
    "--outSAMtype BAM Unsorted "
    "--runMode alignReads "
    "{commands} "
    "--runThreadN {snakemake.threads} "
    "--genomeDir {snakemake.params.index} "
    "--readFilesIn {fq1} "
    "{readcmd} "
    "--outFileNamePrefix {outprefix} "
    "--outStd Log "
    "{log}")
