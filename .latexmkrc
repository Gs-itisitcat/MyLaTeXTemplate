#!/usr/bin/env perl

# LaTeX
$latex = 'uplatex -synctex=1 -halt-on-error -file-line-error %O %S';
$max_repeat = 5;

# BibTeX
$bibtex = 'upbibtex %O %S';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';

# index
$makeindex = 'mendex %O -o %D %S';

# subroutine to replace "、"(0x3001) and "。"(0x3002) to "，"(0xff0c) and "．"(0xff0e) while type-setting
sub replacing_dvipdf {
    my ($basename, @args) = @_;
    print "replacing_dvipdf: called with: $basename @args\n";

    print "replacing_dvipdf: converting DVI to text\n";
    system('dvispc', '-a', "$basename.dvi", "$basename.dvi.txt");

    print "replacing_dvipdf: replacing punctuation marks\n";
    open(FROM, "<", "$basename.dvi.txt") or die "Cannot open $basename.dvi.txt: $!";
    open(TO, ">", "$basename.txt") or die "Cannot open $basename.txt: $!";
    while (<FROM>) {
        s/0x3001/0xff0c/g;
        s/0x3002/0xff0e/g;
        print TO;
    }
    close(FROM);
    close(TO);
    # what the above code does is equivalent to the following command:
    # system('sed', '-i', '-e', 's/0x3001/0xff0c/g', '-e', 's/0x3002/0xff0e/g', "$basename.txt");
    rdb_add_generated("$basename.dvi.txt", "$basename.txt");
    print "replacing_dvipdf: converting text to DVI\n";
    system('dvispc', '-x', "$basename.txt", "$basename.dvi");
    print "replacing_dvipdf: converting DVI to PDF\n";
    return system('dvipdfmx', @args);
}
push @generated_exts, "%R.txt", "%R.dvi.txt";

# DVI / PDF
# replacing punctuation marks type-set
$dvipdf = "internal replacing_dvipdf %B %O -o %D %S";
# normal type-set
# $dvipdf = 'dvipdfmx %O -o %D %S';

$pdf_mode = 3;

# preview
$pvc_view_file_via_temporary = 0;
if ($^O eq 'linux') {
    $dvi_previewer = "xdg-open %S";
    $pdf_previewer = "xdg-open %S";
} elsif ($^O eq 'darwin') {
    $dvi_previewer = "open %S";
    $pdf_previewer = "open %S";
} else {
    $dvi_previewer = "start %S";
    $pdf_previewer = "start %S";
}

$do_cd = 1;

# clean up
$clean_ext = "%R.aux %R.bbl %R.blg %R.idx %R.ind %R.lof %R.lot %R.out %R.toc %R.acn %R.acr %R.alg %R.glg %R.glo %R.gls %R.fls %R.log %R.fdb_latexmk %R.snm %R.synctex(busy) %R.synctex.gz(busy) %R.nav %R.vrb %R.dvi";
$clean_full_ext = "%R.aux %R.bbl %R.blg %R.idx %R.ind %R.lof %R.lot %R.out %R.toc %R.acn %R.acr %R.alg %R.glg %R.glo %R.gls %R.fls %R.log %R.fdb_latexmk %R.snm %R.synctex(busy) %R.synctex.gz(busy) %R.nav %R.vrb %R.dvi %R.synctex.gz";
