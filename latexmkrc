#!/usr/bin/env perl

$bibtex = "bibtex -min-crossrefs=9999";

add_cus_dep("vrb", "sty", 0, "pyginline");
add_cus_dep("ipvrb", "sty", 0, "pyginpar");
add_cus_dep("c", "c-pyg", 0, "cpyg");
add_cus_dep("cpp", "cpp-pyg", 0, "cpppyg");
add_cus_dep("java", "java-pyg", 0, "javapyg");
add_cus_dep("py", "py-pyg", 0, "pypyg");
add_cus_dep("s", "s-pyg", 0, "spyg");
add_cus_dep("ll", "ll-pyg", 0, "llpyg");
add_cus_dep("sh-session", "sh-session-pyg", 0, "shsessionpyg");
add_cus_dep("c-objdump", "c-objdump-pyg", 0, "cobjpyg");
add_cus_dep("cpp-objdump", "cpp-objdump-pyg", 0, "cppobjpyg");
add_cus_dep("cilk-objdump", "cilk-objdump-pyg", 0, "cilkobjpyg");
add_cus_dep("Makefile", "Makefile-pyg", 0, "makepyg");
add_cus_dep("prn", "pdf", 0, "prn2pdf");
add_cus_dep("prn", "eps", 0, "prn2eps");
add_cus_dep("eps", "pdf", 0, "eps2pdf");
add_cus_dep("fig", "pdftex", 0, "fig2pdftex");
add_cus_dep("fig", "pdftex_t", 0, "fig2pdftex_t");
add_cus_dep("gnuplot", "pdf", 0, "gnuplot2pdf"); 
add_cus_dep("pptx.pdf", "pdf", 0, "pdfcrop"); 
add_cus_dep("xlsx.pdf", "pdf", 0, "xlpdfcrop"); 

sub pyginpar {
    my $src="$_[0].ipvrb";
    my $dst="$_[0].sty";
    rdb_ensure_file($rule, $src);
    system("python ./scripts/pyginpar $src $dst");
}

sub pyginline {
    my $src="$_[0].vrb";
    my $dst="$_[0].sty";
    
    rdb_ensure_file($rule, $src);
    system("python ./scripts/pyginline -v $src $dst");
}


$PYG_FORMATTER = "cilkbook";
$PYG_FILTER = "tokenmerge";
# $PYG_LEX_AND_FORMAT_OPTIONS = "-P texcomments -P linenos -P reindent -P \"verboptions=fontsize=\\small,firstnumber=last,numbersep=9pt,samepage=true\"";
$PYG_LEX_AND_FORMAT_OPTIONS = "-P texcomments -P reindent -P verbenvironment=CodeFigVerbatim";
$PYG_FORMAT_DEFAULT_HIDDEN = "-P hidebydefault";

# $PRODUCE_RTF = 1;
# $PYG_RTF_FORMATTER = "chrtf";
# $PYG_RTF_LEX_AND_FORMAT_OPTIONS = "-P reindent -P style=cilkbookstyle";

sub cpyg {
    my $src="$_[0].c";
    my $dst="$_[0].c-pyg";
    my $rtfdst="$_[0].c-rtf";
    
    rdb_ensure_file($rule, $src);
    open (FILE, $src);
    if (grep(/(\/\*\* END HIDDEN \*\*\/)|(\/\*\* BEGIN HIDDEN \*\*\/)|(\/\/\/<<)|(\/\/\/>>)/, <FILE>)) {
        close FILE;
        system("pygmentize -l cilk -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");
        # if ($PRODUCE_RTF) {
        #     system("pygmentize -l cilk -f $PYG_RTF_FORMATTER -F $PYG_FILTER $PYG_RTF_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $rtfdst $src");
        # }

    } else {
        close FILE;
        system("pygmentize -l cilk -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
        # if ($PRODUCE_RTF) {
        #     system("pygmentize -l cilk -f $PYG_RTF_FORMATTER -F $PYG_FILTER $PYG_RTF_LEX_AND_FORMAT_OPTIONS -o $rtfdst $src");
        # }
    }
}

sub cpppyg {
    my $src="$_[0].cpp";
    my $dst="$_[0].cpp-pyg";
    my $rtfdst="$_[0].cpp-rtf";
    
    rdb_ensure_file($rule, $src);
    open (FILE, $src);
    if (grep(/(\/\/\/<<)|(\/\/\/>>)/, <FILE>)) {
        close FILE;
        system("pygmentize -l cilk -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");
        # if ($PRODUCE_RTF) {
        #     system("pygmentize -l cilk -f $PYG_RTF_FORMATTER -F $PYG_FILTER $PYG_RTF_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $rtfdst $src");
        # }

    } else {
        close FILE;
        system("pygmentize -l cilk -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
        # if ($PRODUCE_RTF) {
        #     system("pygmentize -l cilk -f $PYG_RTF_FORMATTER -F $PYG_FILTER $PYG_RTF_LEX_AND_FORMAT_OPTIONS -o $rtfdst $src");
        # }
    }
    # system("pygmentize -l cilk -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");
}

sub javapyg {
    my $src="$_[0].java";
    my $dst="$_[0].java-pyg";
    
    rdb_ensure_file($rule, $src);
    system("pygmentize -l javacb -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub pypyg {
    my $src="$_[0].py";
    my $dst="$_[0].py-pyg";
    
    rdb_ensure_file($rule, $src);
    system("pygmentize -l pythoncb -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub spyg {
    my $src="$_[0].s";
    my $dst="$_[0].s-pyg";
    
    rdb_ensure_file($rule, $src);
    open (FILE, $src);
    if (grep(/(##<<)|(##>>)/, <FILE>)) {
        close FILE;
        system("pygmentize -l gascb -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");

    } else {
        close FILE;
        system("pygmentize -l gascb -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
    }
    # system("pygmentize -l gascb -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub llpyg {
    my $src="$_[0].ll";
    my $dst="$_[0].ll-pyg";
    
    rdb_ensure_file($rule, $src);
    open (FILE, $src);
    if (grep(/(##<<)|(##>>)/, <FILE>)) {
        close FILE;
        system("pygmentize -l tapir.py -x -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");

    } else {
        close FILE;
        system("pygmentize -l tapir.py -x -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
    }
    # system("pygmentize -l llvm -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub shsessionpyg {
    my $src="$_[0].sh-session";
    my $dst="$_[0].sh-session-pyg";
    
    rdb_ensure_file($rule, $src);
    open (FILE, $src);
    if (grep(/(##<<)|(##>>)/, <FILE>)) {
        close FILE;
        system("pygmentize -l console -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");

    } else {
        close FILE;
        system("pygmentize -l console -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
    }
    # system("pygmentize -l console -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub cobjpyg {
    my $src="$_[0].c-objdump";
    my $dst="$_[0].c-objdump-pyg";
    
    rdb_ensure_file($rule, $src);
    open (FILE, $src);
    if (grep(/(\/\/\/<<)|(\/\/\/>>)|(##<<)|(##>>)/, <FILE>)) {
        close FILE;
        system("pygmentize -l cilk-objdump -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS $PYG_FORMAT_DEFAULT_HIDDEN -o $dst $src");

    } else {
        close FILE;
        system("pygmentize -l cilk-objdump -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
    }

    # system("pygmentize -l cilk-objdump -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub cppobjpyg {
    my $src="$_[0].cpp-objdump";
    my $dst="$_[0].cpp-objdump-pyg";
    
    rdb_ensure_file($rule, $src);
    system("pygmentize -l cilk-objdump -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub cilkobjpyg {
    my $src="$_[0].cilk-objdump";
    my $dst="$_[0].cilk-objdump-pyg";
    
    rdb_ensure_file($rule, $src);
    system("pygmentize -l cilk-objdump -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

sub makepyg {
    my $src="$_[0].Makefile";
    my $dst="$_[0].Makefile-pyg";
    
    rdb_ensure_file($rule, $src);
    system("pygmentize -l makefile -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
}

# sub shsessionpyg {
#     my $src="$_[0].sh-session";
#     my $dst="$_[0].sh-session-pyg";
    
#     rdb_ensure_file($rule, $src);
#     system("pygmentize -l console -f $PYG_FORMATTER -F $PYG_FILTER $PYG_LEX_AND_FORMAT_OPTIONS -o $dst $src");
# }

sub prn2pdf {
    my $src="$_[0].prn";
    my $ps="$_[0].ps";
    my $eps="$_[0].eps";
    my $dst="$_[0].pdf";

    rdb_ensure_file($rule, $src);
    # Generate ps from prn
    system("fixps -q $src -o $ps");
    # Generate eps from ps
    system("ps2epsi $ps $eps > /dev/null 2> /dev/null");
    # Generate pdf from eps
    system("epstopdf $eps --outfile=$dst > /dev/null");
    # Remove intermediate files
    system("rm $ps $eps");
}

sub prn2eps {
    my $src="$_[0].prn";
    my $ps="$_[0].ps";
    my $eps="$_[0].eps";

    rdb_ensure_file($rule, $src);
    # Generate ps from prn
    system("fixps -q $src -o $ps");
    # Generate eps from ps
    system("ps2epsi $ps $eps > /dev/null 2> /dev/null");
    # Remove intermediate files
    system("rm $ps");
}

sub eps2pdf {
    my $src="$_[0].eps";
    my $dst="$_[0].pdf";

    rdb_ensure_file($rule, $src);
    # Generate pdf from eps
    system("epstopdf $src --outfile=$dst > /dev/null");
    # Crop pdf
    system("pdfcrop $dst $dst > /dev/null");
}

sub fig2pdftex {
    my $src="$_[0].fig";
    my $rootname="$_[0]";
    my $dst="$_[0].pdftex";
    
    rdb_ensure_file($rule, $src);
    system("fig2dev -L pdftex $src $dst");
}

sub fig2pdftex_t {
    my $src="$_[0].fig";
    my $rootname="$_[0]";
    my $dst="$_[0].pdftex_t";
    
    rdb_ensure_file($rule, $src);
    system("fig2dev -L pdftex_t -p $rootname.pdftex $src $dst");
}

sub gnuplot2pdf {
    my $src="$_[0].gnuplot";
    my $eps="$_[0].eps";
    my $dst="$_[0].pdf";
    
    rdb_ensure_file($rule, $src);
    my @path = split('/', $src);
    my $prefix = join('/', @path[0..(scalar @path)-2]);
    my $src_file = @path[(scalar @path)-1];
    my $rootdir = cwd();

    # Move into the appropriate directory to get gnuplot to resolve
    # paths correctly.
    chdir($prefix) or die "$!";
    system("gnuplot $src_file") == 0 or die "gnuplot $src_file returned $!";
    chdir($rootdir) or die "$!";
    return 0;
}

sub pdfcrop {
    my $src="$_[0].pptx.pdf";
    my $dst="$_[0].pdf";

    rdb_ensure_file($rule, $src);
    system("pdfcrop $src $dst");
}

sub xlpdfcrop {
    my $src="$_[0].xlsx.pdf";
    my $dst="$_[0].pdf";

    rdb_ensure_file($rule, $src);
    system("pdfcrop $src $dst");
}
