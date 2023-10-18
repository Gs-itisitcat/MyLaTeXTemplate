#!/usr/bin/env perl

# LaTeX
$latex = 'uplatex -synctex=1 -halt-on-error -file-line-error %O %S';
# When use platex instead of uplatex LaTeX
# $latex = 'uplatex -synctex=1 -halt-on-error -file-line-error %O %S';
$max_repeat = 5;

# BibTeX
$bibtex = 'upbibtex %O %S';
# When use platex instead of uplatex
# $bibtex = 'upbibtex %O %S';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';

# index
$makeindex = 'mendex %O -o %D %S';

# DVI / PDF
# $dvipdf = 'dvipdfmx %O -o %D %S';
# dvipdf with replacing "、" and "。" to "，" and "．"
$dvipdf = '"dvispc %O -a %B.dvi %B.txt && sed -i -e s/0x3001/0xff0c/ -e s/0x3002/0xff0e/ %B.txt && dvispc %O -x %O %B.txt %B.dvi && dvipdfmx %O -o %D %S"';

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

# clean up
$clean_ext = "%R.aux %R.bbl %R.blg %R.idx %R.ind %R.lof %R.lot %R.out %R.toc %R.acn %R.acr %R.alg %R.glg %R.glo %R.gls %R.fls %R.log %R.fdb_latexmk %R.snm %R.synctex(busy) %R.synctex.gz(busy) %R.nav %R.vrb %R.dvi %R.txt";
$clean_full_ext = "%R.aux %R.bbl %R.blg %R.idx %R.ind %R.lof %R.lot %R.out %R.toc %R.acn %R.acr %R.alg %R.glg %R.glo %R.gls %R.fls %R.log %R.fdb_latexmk %R.snm %R.synctex(busy) %R.synctex.gz(busy) %R.nav %R.vrb %R.dvi %R.synctex.gz %R.txt";
