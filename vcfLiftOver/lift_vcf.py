#!/usr/bin/env python
import sys, os

def vcf2bed(fin, fout):
    from cyvcf2 import VCF
    lines = []
    num = 0
    batch = 10000
    with open(fout, 'w') as f:
        for v in VCF(fin):
            num += 1
            if num % batch == 0:
                f.writelines(lines)
                lines = []
            else:
                lines.append('chr%s\t%d\t%d\t%s\n' % (v.CHROM, v.start, v.start + 1, v.ID))
        if len(lines):
            f.writelines(lines)
    return True

LIFTED_SET = set()
UNLIFTED_SET = set()

def liftBed(fin, fout, funlifted, chain_file):
    params = dict()
    params['LIFTOVER_BIN'] = 'liftOver'
    params['OLD'] = fin
    params['CHAIN'] = chain_file
    params['NEW'] = fout
    params['UNLIFTED'] = fout + '.unlifted'
    from string import Template
    cmd = Template('$LIFTOVER_BIN $OLD $CHAIN $NEW $UNLIFTED')
    cmd = cmd.substitute(params)
    os.system(cmd)
    #record lifted/unliftd rs
    for ln in open(params['UNLIFTED']):
        if len(ln) == 0 or ln[0] == '#':continue
        UNLIFTED_SET.add(ln.strip().split()[-1])
    for ln in open(params['NEW']):
        if len(ln) == 0 or ln[0] == '#':continue
        LIFTED_SET.add(ln.strip().split()[-1])
    return True

def makesure(result, succ_msg, fail_msg = "ERROR"):
    if result:
        print('SUCC: ', succ_msg)
    else:
        print('FAIL: ', fail_msg)
        sys.exit(2)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('-d', dest='vcfFile', required = True)
    parser.add_argument('-o', dest='prefix', required = True)
    parser.add_argument('-c', dest='chainFile', required = True)
    parser.add_argument('-r', dest='resume', action='store_true')
    args = parser.parse_args()

    oldBed = args.vcfFile + '.bed.ascii'
    if not(os.path.isfile(oldBed) and args.resume):
        makesure(vcf2bed(args.vcfFile, oldBed),
                 'vcf->bed succ')

    newBed = args.prefix + '.bed.ascii'
    unlifted = args.prefix + '.unlifted'
    if not(os.path.isfile(newBed) and args.resume):
        makesure(liftBed(oldBed, newBed, unlifted, args.chainFile),
                'liftBed succ')
