#!/usr/bin/env perl
# a helper script to make the subsitutions for line numbers 
# from defaultSettings.yaml in documentation/latexindent.tex
use strict;
use warnings;
use Getopt::Long;

my $readTheDocsMode = 0;

GetOptions (
    "readthedocs|r"=>\$readTheDocsMode,
);

# store the names of each field
my @namesAndOffsets = (
                        {name=>"fileExtensionPreference",numberOfLines=>4},
                        {name=>"logFilePreferences",numberOfLines=>10},
                        {name=>"verbatimEnvironments",numberOfLines=>3},
                        {name=>"verbatimCommands",numberOfLines=>2},
                        {name=>"noIndentBlock",numberOfLines=>2},
                        {name=>"removeTrailingWhitespace",numberOfLines=>2},
                        {name=>"fileContentsEnvironments",numberOfLines=>2},
                        {name=>"lookForPreamble",numberOfLines=>4},
                        {name=>"indentAfterItems",numberOfLines=>4},
                        {name=>"itemNames",numberOfLines=>2},
                        {name=>"specialBeginEnd",numberOfLines=>13,mustBeAtBeginning=>1},
                        {name=>"indentAfterHeadings",numberOfLines=>9},
                        {name=>"noAdditionalIndentGlobalEnv",numberOfLines=>1,special=>"noAdditionalIndentGlobal"},
                        {name=>"noAdditionalIndentGlobal",numberOfLines=>12},
                        {name=>"indentRulesGlobalEnv",numberOfLines=>1,special=>"indentRulesGlobal"},
                        {name=>"indentRulesGlobal",numberOfLines=>12},
                        {name=>"commandCodeBlocks",numberOfLines=>10},
                        {name=>"modifylinebreaks",numberOfLines=>2,special=>"modifyLineBreaks"},
                        {name=>"textWrapOptions",numberOfLines=>1},
                        {name=>"textWrapOptionsAll",numberOfLines=>2,special=>"textWrapOptions"},
                        {name=>"removeParagraphLineBreaks",numberOfLines=>12},
                        {name=>"paragraphsStopAt",numberOfLines=>8},
                        {name=>"oneSentencePerLine",numberOfLines=>21},
                        {name=>"sentencesFollow",numberOfLines=>8},
                        {name=>"sentencesBeginWith",numberOfLines=>3},
                        {name=>"sentencesEndWith",numberOfLines=>5},
                        {name=>"modifylinebreaksEnv",numberOfLines=>9,special=>"environments"},
                      );

# loop through defaultSettings.yaml and count the lines as we go through
my $lineCounter = 1;
open(MAINFILE,"../defaultSettings.yaml");
while(<MAINFILE>){
    # loop through the names and search for a match
    foreach my $thing (@namesAndOffsets){
      my $name = (defined ${$thing}{special} ? ${$thing}{special} : ${$thing}{name} ); 
      my $beginning = (${$thing}{mustBeAtBeginning}? qr/^/ : qr/\h*/);
      ${$thing}{firstLine} = $lineCounter if $_=~m/$beginning$name:/;
    }
    $lineCounter++;
  }
close(MAINFILE);

# store the file
my @lines;
if(!$readTheDocsMode){
    open(MAINFILE,"../documentation/latexindent.tex");
    push(@lines,$_) while(<MAINFILE>);
    close(MAINFILE);
    my $documentationFile = join("",@lines);
    
    # make the substitutions
    for (@namesAndOffsets){
        my $firstLine = ${$_}{firstLine}; 
        my $lastLine = $firstLine + ${$_}{numberOfLines}; 
        $documentationFile =~ s/\h*\\lstdefinestyle\{${$_}{name}\}\{\h*\R*
                                	\h*style=yaml-LST,\h*\R*
                                	\h*firstnumber=\d+,linerange=\{\d+-\d+\},\h*\R*
                                	\h*numbers=left,?\h*\R*
                                \h*\}
                              /\\lstdefinestyle\{${$_}{name}\}\{
                                	style=yaml-LST,
                                	firstnumber=$firstLine,linerange=\{$firstLine-$lastLine\},
                                	numbers=left,
                                \}/xs;
    }
    
    # overwrite the original file
    open(OUTPUTFILE,">","../documentation/latexindent.tex");
    print OUTPUTFILE $documentationFile;
    close(OUTPUTFILE);
    
    # and operate upon it with latexindent.pl
    system('latexindent.pl -w -s -m -l ../documentation/latexindent.tex');
} else {

    # read informatino from latexindent.aux
    open(MAINFILE, "latexindent.aux") or die "Could not open input file, latexindent.aux";
    push(@lines,$_) while(<MAINFILE>);
    close(MAINFILE);

    my %crossReferences;
    foreach (@lines){
        if($_ =~ m/\\newlabel\{(.*?)\}(.*?)$/s){
            my $name = $1;
            my $value = $2;
            if($name !~ m/\@/s){
                $value =~ s/\}\{\}\}//s;
                $value =~ s/.*\{//s;
                if($value =~ m/lstlisting\.(\d+)/){
                    $value = "Listing ".$1;
                } elsif ($value =~ m/appendix\.([a-zA-Z]+)/){
                    $value = "Appendix ".$1;
                } elsif ($value =~ m/section\.(.+)/){
                    $value = "Section ".$1;
                } elsif ($value =~ m/subsection\.(.+)/){
                    $value = "Subsection ".$1;
                } elsif ($value =~ m/table\.(.+)/){
                    $value = "Table ".$1;
                }
                $crossReferences{$name} = $value;
            }
        } elsif ($_ =~ m/\\totalcount\@set\{lstlisting\}\{(\d+)\}/ ) {
            $crossReferences{totalListings} = $1;
        }
    }

    foreach my $fileName ("sec-introduction.tex", 
                          "sec-demonstration.tex", 
                          "sec-how-to-use.tex", 
                          "sec-indent-config-and-settings.tex",
                          "sec-default-user-local.tex",){
        @lines = q();
        # read the file
        open(MAINFILE, $fileName) or die "Could not open input file, $fileName";
        push(@lines,$_) while(<MAINFILE>);
        close(MAINFILE);
        my $body = join("",@lines);

        # make the substitutions
        $body =~ s/\\begin\{minipage\}\{.*?\}//sg;
        $body =~ s/\\end\{minipage\}.*$//mg;
        $body =~ s/\\hfill.*$//mg;
        $body =~ s/\\cmhlistingsfromfile(.*)\*/\\cmhlistingsfromfile$1/mg;
        $body =~ s/\\cmhlistingsfromfile(.*?\})\[.*?\]/\\cmhlistingsfromfile$1/mg;
        $body =~ s/\\cmhlistingsfromfile\*?\[style=yaml-LST\]\*?/\\cmhlistingsfromfile/mg;
        $body =~ s/\\cmhlistingsfromfile\*?\[\]\*?/\\cmhlistingsfromfile/mg;
        $body =~ s/\\cmhlistingsfromfile\*?\[showtabs=true\]\*?/\\cmhlistingsfromfile/mg;
        $body =~ s/\\cmhlistingsfromfile\*?\[showspaces=true\]\*?/\\cmhlistingsfromfile/mg;
        $body =~ s/\\cmhlistingsfromfile\*?\[/\\cmhlistingsfromfilefour\[/mg;
        $body =~ s/\}\[\h*width=.*?\]\{/\}\{/sg;
        $body =~ s/\}\[\h*yaml-TCB.*?\]\{/\}\{/sg;

        $body =~ s/\\begin\{wrapfigure\}.*$//mg;
        $body =~ s/\\end\{wrapfigure\}.*$//mg;

        # total listings
        $body =~ s/\\totallstlistings/$crossReferences{totalListings}/s;

        # cross references
        $body =~ s/\\[vVcC]ref\{(.*?)\}/
                # check for ,
                my $internal = $1;
                my $returnValue = q();
                if($internal =~ m|,|s){
                    my @refs = split(',',$internal);
                    foreach my $reference (@refs){
                        $returnValue .= ($returnValue eq ''?q():' and ').":numref:\\texttt\{$reference\}";
                    }
                } else {
                    $returnValue = ":numref:\\texttt\{$internal\}";
                };
                $returnValue;
                /exsg;
        $body =~ s/\\crefrange\{(.*?)\}\{(.*?)\}/:numref:\\texttt\{$1\} -- :numref:\\texttt\{$2\}/sg;

        # verbatim-like environments
        $body =~ s/(\\begin\{commandshell\}(?:                       # cluster-only (), don't capture 
                    (?!                   # don't include \begin in the body
                        (?:\\begin)       # cluster-only (), don't capture
                    ).                    # any character, but not \\begin
                )*?\\end\{commandshell\})(?:\R|\h)*(\\label\{.*?\})/$2\n\n$1/xsg;
        $body =~ s/\\begin\{commandshell\}/\\begin\{verbatim\}/sg;
        $body =~ s/\\end\{commandshell\}/\\end\{verbatim\}/sg;
        $body =~ s/\\begin\{cmhlistings\}/\\begin\{verbatim\}/sg;
        $body =~ s/\\end\{cmhlistings\}/\\end\{verbatim\}/sg;
        $body =~ s/\\begin\{yaml\}/\\begin\{verbatim\}/sg;
        $body =~ s/\\end\{yaml\}/\\end\{verbatim\}/sg;

        # flagbox switch
        $body =~ s/\\flagbox/\\texttt/sg;

        # yaml title
        $body =~ s/\\yamltitle\{(.*?)\}\*?\{(.*?)\}/\\texttt\{$1\}: \\textit\{$2\}\n\n/sg;

        # labels
        #
        # move the labels ahead of section, subsection, subsubsection
        $body =~ s/(\\section\{.*?\}\h*)(\\label\{.*?\})/$2$1/mg;
        $body =~ s/(\\subsection\{.*?\}\h*)(\\label\{.*?\})/$2$1/mg;
        $body =~ s/(\\subsubsection\{.*?\}\h*)(\\label\{.*?\})/$2$1/mg;

        # move figure label before \\begin{figure}
        $body =~ s/(\\begin\{figure.*?)(\\label\{.*?\})/$2\n\n$1/s;

        # 
        $body =~ s/(\\label\{.*?\})/\n\n$1\n\n/sg;
        $body =~ s/\\label/\\cmhlabel/sg;

        # figure
        $body =~ s/\\input\{figure-schematic\}/\\includegraphics\{figure-schematic.png\}/s;

        # line numbers for defaulSettings
        for (@namesAndOffsets){
            my $firstLine = ${$_}{firstLine}; 
            my $lastLine = $firstLine + ${$_}{numberOfLines}; 
            $body =~ s/\*?\[style\h*=\h*${$_}{name}\h*,?\]\*?/\{$firstLine\}\{$lastLine\}/sg;
        }

        # can't have back to back verbatim
        $body =~ s/(\\end\{verbatim\}(?:\h|\R)*)(\\cmhlistings.*?)$((?:\h|\R)*[a-zA-Z]+\h)/$1\n\n$3\n\n$2\n\n/smg; 

        # output the file
        open(OUTPUTFILE,">",$fileName);
        print OUTPUTFILE $body;
        close(OUTPUTFILE);
    }

    system('./pandoc-tex-files.sh');
    system("git checkout sec*.tex");
}
exit; 
