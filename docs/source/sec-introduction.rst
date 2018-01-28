Introduction
============

Thanks
------

I first created ``latexindent.pl`` to help me format chapter files in a
big project. After I blogged about it on the TeX stack exchange
:raw-latex:`\cite{cmhblog}` I received some positive feedback and
follow-up feature requests. A big thank you to Harish Kumar
:raw-latex:`\cite{harish}` who helped to develop and test the initial
versions of the script.

The ``YAML``-based interface of ``latexindent.pl`` was inspired by the
wonderful ``arara`` tool; any similarities are deliberate, and I hope
that it is perceived as the compliment that it is. Thank you to Paulo
Cereda and the team for releasing this awesome tool; I initially worried
that I was going to have to make a GUI for ``latexindent.pl``, but the
release of ``arara`` has meant there is no need.

There have been several contributors to the project so far (and
hopefully more in the future!); thank you very much to the people
detailed in for their valued contributions, and thank you to those who
report bugs and request features at
:raw-latex:`\cite{latexindent-home}`.

License
-------

``latexindent.pl`` is free and open source, and it always will be; it is
released under the GNU General Public License v3.0.

Before you start using it on any important files, bear in mind that
``latexindent.pl`` has the option to overwrite your ``.tex`` files. It
will always make at least one backup (you can choose how many it makes,
see ) but you should still be careful when using it. The script has been
tested on many files, but there are some known limitations (see
[sec:knownlimitations]). You, the user, are responsible for ensuring
that you maintain backups of your files before running
``latexindent.pl`` on them. I think it is important at this stage to
restate an important part of the license here:

    *This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.*

There is certainly no malicious intent in releasing this script, and I
do hope that it works as you expect it to; if it does not, please first
of all make sure that you have the correct settings, and then feel free
to let me know at :raw-latex:`\cite{latexindent-home}` with a complete
minimum working example as I would like to improve the code as much as
possible.

Before you try the script on anything important (like your thesis), test
it out on the sample files in the ``test-case`` directory
:raw-latex:`\cite{latexindent-home}`.

*If you have used any version 2.\* of ``latexindent.pl``, there are a
few changes to the interface; see and the comments throughout this
document for details*.

About this documentation
------------------------

As you read through this documentation, you will see many listings; in
this version of the documentation, there are a total of . This may seem
a lot, but I deem it necessary in presenting the various different
options of ``latexindent.pl`` and the associated output that they are
capable of producing.

The different listings are presented using different styles:

.4

.4 This type of listing is a ``.tex`` file.

.4
\*../defaultSettings.yaml[width=.8,before=,yaml-TCB]``fileExtensionPreference``\ lst:fileExtensionPreference-demo

.4 This type of listing is a ``.yaml`` file; when you see line numbers
given (as here) it means that the snippet is taken directly from
``defaultSettings.yaml``, discussed in detail in .

.55
\*../defaultSettings.yaml[MLB-TCB,width=.85,before=]``modifyLineBreaks``\ lst:modifylinebreaks-demo

.4 This type of listing is a ``.yaml`` file, but it will only be
relevant when the ``-m`` switch is active; see for more details.

You will occasionally see dates shown in the margin (for example, next
to this paragraph!) which detail the date of the version in which the
feature was implemented; the ‘N’ stands for ‘new as of the date shown’
and ‘U’ stands for ‘updated as of the date shown’. If you see , it means
that the feature is either new (N) or updated (U) as of the release of
the current version; if you see attached to a listing, then it means
that listing is new (N) or updated (U) as of the current version. If you
have not read this document before (and even if you have!), then you can
ignore every occurrence of the ; they are simply there to highlight new
and updated features. The new and updated features in this documentation
() are on the following pages:

Quick start
-----------

If you’d like to get started with ``latexindent.pl`` then simply type

::

    latexindent.pl myfile.tex
        

from the command line. If you receive an error message such as that
given in [lst:poss-errors], then you need to install the missing perl
modules.

::

    {Possible error messages}{lst:poss-errors}
    Can't locate File/HomeDir.pm in @INC (@INC contains: /Library/Perl/5.12/darwin-thread-multi-2level /Library/Perl/5.12 /Network/Library/Perl/5.12/darwin-thread-multi-2level /Network/Library/Perl/5.12 /Library/Perl/Updates/5.12.4/darwin-thread-multi-2level /Library/Perl/Updates/5.12.4 /System/Library/Perl/5.12/darwin-thread-multi-2level /System/Library/Perl/5.12 /System/Library/Perl/Extras/5.12/darwin-thread-multi-2level /System/Library/Perl/Extras/5.12 .) at helloworld.pl line 10.
    BEGIN failed--compilation aborted at helloworld.pl line 10.

``latexindent.pl`` ships with a script to help with this process; if you
run the following script, you should be prompted to install the
appropriate modules.

::

    perl latexindent-module-installer.pl
        

You might also like to see
https://stackoverflow.com/questions/19590042/error-cant-locate-file-homedir-pm-in-inc,
for example, as well as .
