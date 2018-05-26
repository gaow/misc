#!/usr/bin/env python3
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
                # 1-based to 0-based
                lines.append('chr%s\t%d\t%d\t%s\t0\t+\n' % (v.CHROM, v.start, v.start + 1, v.ID))
        if len(lines):
            f.writelines(lines)
    return True

LIFTED_SET = dict()
UNLIFTED_SET = dict()

def liftBed(fin, fout, funlifted, chain_file, resume):
    params = dict()
    params['LIFTOVER_BIN'] = 'liftOver'
    params['OLD'] = fin
    params['CHAIN'] = chain_file
    params['NEW'] = fout
    params['UNLIFTED'] = fout + '.unlifted'
    from string import Template
    cmd = Template('$LIFTOVER_BIN $OLD $CHAIN $NEW $UNLIFTED')
    cmd = cmd.substitute(params)
    if not(os.path.isfile(fout) and resume):
        os.system(cmd)
    # record lifted/unliftd ID and strand
    for ln in open(params['NEW']):
        if len(ln) == 0 or ln[0] == '#':continue
        x = ln.strip().split()
        LIFTED_SET[x[3]] = (x[0][3:], x[2], x[-1])
    return True

def reverse_complement(x):
    reverse_complement_map = str.maketrans('ATGC', 'TACG')
    return x.translate(reverse_complement_map)

def liftVCF(fin):
    import gzip
    with gzip.open(fin, 'rt') as f:
        for line in f:
            if line.startswith('#'):
                print(line.strip())
            else:
                record = line.strip().split('\t')
                try:
                    new_cord = LIFTED_SET[record[2]]
                    flip = new_cord[-1] == '+'
                    ref = record[3] if flip else reverse_complement(record[3])
                    alt = record[4] if flip else reverse_complement(record[4])
                    print ('\t'.join([new_cord[0], new_cord[1], record[2], ref, alt] + record[5:]))
                except KeyError:
                    pass

def makesure(result, succ_msg, fail_msg = "ERROR"):
    if result:
        sys.stderr.write('SUCC: ' + succ_msg + '\n')
    else:
        sys.stderr.write('FAIL: ' + fail_msg + '\n')
        sys.exit(2)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('-d', dest='vcfFile', required = True)
    parser.add_argument('-o', dest='prefix', required = True)
    parser.add_argument('-c', dest='chainFile', required = True)
    parser.add_argument('-r', dest='resume', action='store_true')
    parser.add_argument('-a', dest='apply', action='store_true')
    args = parser.parse_args()

    oldBed = args.vcfFile + '.bed.ascii'
    newBed = args.prefix + '.bed.ascii'
    unlifted = args.prefix + '.unlifted'

    if not ((os.path.isfile(oldBed) or os.path.isfile(newBed)) and args.resume):
        makesure(vcf2bed(args.vcfFile, oldBed),
                 'vcf->bed succ')

    makesure(liftBed(oldBed, newBed, unlifted, args.chainFile, args.resume),
             'liftBed succ')

    if args.apply:
        makesure(liftVCF(args.vcfFile),
                 'liftVCF succ')
