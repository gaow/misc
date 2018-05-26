## Usage

Lift over to bed file only (slow running `liftOver`):

```
liftVCF.py -d 33617.vcf.gz -o 33617.scr3 -c susScr11ToSusScr3.over.chain.gz
```

Followed by applying to VCF file, in resume mode (fast):

```
liftVCF.py -d 33617.vcf.gz -o 33617.scr3 -c susScr11ToSusScr3.over.chain.gz -r -a | bgzip > 33617.scr3.vcf.gz
```

Or, run both in one command,

```
liftVCF.py -d 33617.vcf.gz -o 33617.scr3 -c susScr11ToSusScr3.over.chain.gz -a | bgzip > 33617.scr3.vcf.gz
```
