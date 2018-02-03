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

    foreach my $fileName ("sec-introduction.tex", "sec-demonstration.tex"){
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
        $body =~ s/\\cmhlistingsfromfile\[/\\cmhlistingsfromfilefour\[/mg;

        # total listings
        $body =~ s/\\totallstlistings/$crossReferences{totalListings}/s;

        # cross references
        #$body =~ s/\\[vVcC]ref\{(.*?)\}/$crossReferences{$1}/xsg;
        #$body =~ s/\\crefrange\{(.*?)\}\{(.*?)\}/$crossReferences{$1} -- $crossReferences{$2}/sg;
        $body =~ s/\\[vVcC]ref\{(.*?)\}/:numref:\\texttt\{$1\}/xsg;
        $body =~ s/\\crefrange\{(.*?)\}\{(.*?)\}/:numref:\\texttt\{$1\} -- :numref:\\texttt\{$2\}/sg;

        # line numbers for defaulSettings
        for (@namesAndOffsets){
            my $firstLine = ${$_}{firstLine}; 
            my $lastLine = $firstLine + ${$_}{numberOfLines}; 
            $body =~ s/\[style\h*=\h*${$_}{name}\h*\]/\{$firstLine\}\{$lastLine\}/s;
        }

        # output the file
        open(OUTPUTFILE,">",$fileName);
        print OUTPUTFILE $body;
        close(OUTPUTFILE);
    }

    system('./pandoc-tex-files.sh');
    system("git checkout sec*.tex");
}
exit; 
