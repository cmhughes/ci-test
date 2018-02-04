 .. _sec:defuseloc:

defaultSettings.yaml
====================

``latexindent.pl`` loads its settings from ``defaultSettings.yaml``. The
idea is to separate the behaviour of the script from the internal
working – this is very similar to the way that we separate content from
form when writing our documents in LaTeX.

If you look in ``defaultSettings.yaml`` you’ll find the switches that
govern the behaviour of ``latexindent.pl``. If you’re not sure where
``defaultSettings.yaml`` resides on your computer, don’t worry as
``indent.log`` will tell you where to find it. ``defaultSettings.yaml``
is commented, but here is a description of what each switch is designed
to do. The default value is given in each case; whenever you see
*integer* in *this* section, assume that it must be greater than or
equal to ``0`` unless otherwise stated.

``fileExtensionPreference``: *fields*

``latexindent.pl`` can be called to act on a file without specifying the
file extension. For example we can call

::

    latexindent.pl myfile

in

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``fileExtensionPreference`` 
 	:name: lst:fileExtensionPreference
 	:lines: 38-42
 	:linenos:
 	:lineno-start: 38

which case the script will look for ``myfile`` with the extensions
specified in ``fileExtensionPreference`` in their numeric order. If no
match is found, the script will exit. As with all of the fields, you
should change and/or add to this as necessary.

Calling ``latexindent.pl myfile`` with the (default) settings specified
in :numref:`lst:fileExtensionPreference` means that the script will
first look for ``myfile.tex``, then ``myfile.sty``, ``myfile.cls``, and
finally ``myfile.bib`` in order [1]_.

``backupExtension``: *extension name*

If you call ``latexindent.pl`` with the ``-w`` switch (to overwrite
``myfile.tex``) then it will create a backup file before doing any
indentation; the default extension is ``.bak``, so, for example,
``myfile.bak0`` would be created when calling
``latexindent.pl myfile.tex`` for the first time.

By default, every time you subsequently call ``latexindent.pl`` with the
``-w`` to act upon ``myfile.tex``, it will create successive back up
files: ``myfile.bak1``, ``myfile.bak2``, etc.

``onlyOneBackUp``: *integer*

 .. _page:onlyonebackup:

If you don’t want a backup for every time that you call
``latexindent.pl`` (so you don’t want ``myfile.bak1``, ``myfile.bak2``,
etc) and you simply want ``myfile.bak`` (or whatever you chose
``backupExtension`` to be) then change ``onlyOneBackUp`` to ``1``; the
default value of ``onlyOneBackUp`` is ``0``.

``maxNumberOfBackUps``: *integer*

Some users may only want a finite number of backup files, say at most
:math:`3`, in which case, they can change this switch. The smallest
value of ``maxNumberOfBackUps`` is :math:`0` which will *not* prevent
backup files being made; in this case, the behaviour will be dictated
entirely by ``onlyOneBackUp``. The default value of
``maxNumberOfBackUps`` is ``0``.

``cycleThroughBackUps``: *integer*

Some users may wish to cycle through backup files, by deleting the
oldest backup file and keeping only the most recent; for example, with
``maxNumberOfBackUps: 4``, and ``cycleThroughBackUps`` set to ``1`` then
the ``copy`` procedure given below would be obeyed.

::

    copy myfile.bak1 to myfile.bak0
    copy myfile.bak2 to myfile.bak1
    copy myfile.bak3 to myfile.bak2
    copy myfile.bak4 to myfile.bak3
        

The default value of ``cycleThroughBackUps`` is ``0``.

``logFilePreferences``: *fields*

``latexindent.pl`` writes information to ``indent.log``, some of which
can be customized by changing ``logFilePreferences``; see
:numref:`lst:logFilePreferences`. If you load your own user settings
(see :numref:`sec:indentconfig`) then ``latexindent.pl`` will detail
them in ``indent.log``; you can choose not to have the details logged by
switching ``showEveryYamlRead`` to ``0``. Once all of your settings have
been loaded, you can see the amalgamated settings in the log file by
switching ``showAmalgamatedSettings`` to ``1``, if you wish.

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``logFilePreferences`` 
 	:name: lst:logFilePreferences
 	:lines: 79-89
 	:linenos:
 	:lineno-start: 79

When either of the ``trace`` modes (see ) are active, you will receive
detailed information in ``indent.log``. You can specify character
strings to appear before and after the notification of a found code
block using, respectively, ``showDecorationStartCodeBlockTrace`` and
``showDecorationFinishCodeBlockTrace``. A demonstration is given in
:numref:`app:logfile-demo`.

The log file will end with the characters given in ``endLogFileWith``,
and will report the ``GitHub`` address of ``latexindent.pl`` to the log
file if ``showGitHubInfoFooter`` is set to ``1``.

``latexindent.pl`` uses the ``log4perl`` module (“Log4perl Perl Module”
2017) to handle the creation of the logfile. You can specify the layout
of the information given in the logfile using any of the ``Log Layouts``
detailed at (“Log4perl Perl Module” 2017).

``verbatimEnvironments``: *fields*

A field that contains a list of environments that you would like left
completely alone – no indentation will be performed on environments that
you have specified in this field, see
:numref:`lst:verbatimEnvironments`.

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``verbatimEnvironments`` 
 	:name: lst:verbatimEnvironments
 	:lines: 93-96
 	:linenos:
 	:lineno-start: 93

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``verbatimCommands`` 
 	:name: lst:verbatimCommands
 	:lines: 99-101
 	:linenos:
 	:lineno-start: 99

Note that if you put an environment in ``verbatimEnvironments`` and in
other fields such as ``lookForAlignDelims`` or ``noAdditionalIndent``
then ``latexindent.pl`` will *always* prioritize
``verbatimEnvironments``.

``verbatimCommands``: *fields*

A field that contains a list of commands that are verbatim commands, for
example ``\lstinline``; any commands populated in this field are
protected from line breaking routines (only relevant if the ``-m`` is
active, see :numref:`sec:modifylinebreaks`).

``noIndentBlock``: *fields*

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``noIndentBlock`` 
 	:name: lst:noIndentBlock
 	:lines: 107-109
 	:linenos:
 	:lineno-start: 107

If you have a block of code that you don’t want ``latexindent.pl`` to
touch (even if it is *not* a verbatim-like environment) then you can
wrap it in an environment from ``noIndentBlock``; you can use any name
you like for this, provided you populate it as demonstrate in
:numref:`lst:noIndentBlock`.

Of course, you don’t want to have to specify these as null environments
in your code, so you use them with a comment symbol, ``%``, followed by
as many spaces (possibly none) as you like; see
:numref:`lst:noIndentBlockdemo` for example.

.. code-block:: latex
   :caption: ``noIndentBlock`` demonstration 
   :name: lst:noIndentBlockdemo

    %(*@@*) \begin{noindent}
            this code
                    won't
         be touched
                        by
                 latexindent.pl!
    %(*@@*)\end{noindent}
        

``removeTrailingWhitespace``: *fields*

 .. _yaml:removeTrailingWhitespace:

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: removeTrailingWhitespace 
 	:name: lst:removeTrailingWhitespace
 	:lines: 112-114
 	:linenos:
 	:lineno-start: 112

.. code-block:: latex
   :caption: removeTrailingWhitespace (alt) 
   :name: lst:removeTrailingWhitespace-alt

    removeTrailingWhitespace: 1

Trailing white space can be removed both *before* and *after* processing
the document, as detailed in :numref:`lst:removeTrailingWhitespace`;
each of the fields can take the values ``0`` or ``1``. See
:numref:`lst:removeTWS-before` and :numref:`lst:env-mlb5-modAll` and
:numref:`lst:env-mlb5-modAll-remove-WS` for before and after results.
Thanks to Voßkuhle (2013) for providing this feature.

You can specify ``removeTrailingWhitespace`` simply as ``0`` or ``1``,
if you wish; in this case, ``latexindent.pl`` will set both
``beforeProcessing`` and ``afterProcessing`` to the value you specify;
see :numref:`lst:removeTrailingWhitespace-alt`.
``fileContentsEnvironments``: *field*

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``fileContentsEnvironments`` 
 	:name: lst:fileContentsEnvironments
 	:lines: 118-120
 	:linenos:
 	:lineno-start: 118

Before ``latexindent.pl`` determines the difference between preamble (if
any) and the main document, it first searches for any of the
environments specified in ``fileContentsEnvironments``, see
:numref:`lst:fileContentsEnvironments`. The behaviour of
``latexindent.pl`` on these environments is determined by their location
(preamble or not), and the value ``indentPreamble``, discussed next.

``indentPreamble``: *0\|1*

The preamble of a document can sometimes contain some trickier code for
``latexindent.pl`` to operate upon. By default, ``latexindent.pl`` won’t
try to operate on the preamble (as ``indentPreamble`` is set to ``0``,
by default), but if you’d like ``latexindent.pl`` to try then change
``indentPreamble`` to ``1``.

``lookForPreamble``: *fields*

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: lookForPreamble 
 	:name: lst:lookForPreamble
 	:lines: 126-130
 	:linenos:
 	:lineno-start: 126

Not all files contain preamble; for example, ``sty``, ``cls`` and
``bib`` files typically do *not*. Referencing
:numref:`lst:lookForPreamble`, if you set, for example, ``.tex`` to
``0``, then regardless of the setting of the value of
``indentPreamble``, preamble will not be assumed when operating upon
``.tex`` files. ``preambleCommandsBeforeEnvironments``: *0\|1*

Assuming that ``latexindent.pl`` is asked to operate upon the preamble
of a document, when this switch is set to ``0`` then environment code
blocks will be sought first, and then command code blocks. When this
switch is set to ``1``, commands will be sought first. The example that
first motivated this switch contained the code given in
:numref:`lst:motivatepreambleCommandsBeforeEnvironments`.

.. code-block:: latex
   :caption: Motivating ``preambleCommandsBeforeEnvironments`` 
   :name: lst:motivatepreambleCommandsBeforeEnvironments

    ...
    preheadhook={\begin{mdframed}[style=myframedstyle]},
    postfoothook=\end{mdframed},
    ...

``defaultIndent``: *horizontal space*

This is the default indentation (``\t`` means a tab, and is the default
value) used in the absence of other details for the command or
environment we are working with; see ``indentRules`` in
:numref:`sec:noadd-indent-rules` for more details.

If you’re interested in experimenting with ``latexindent.pl`` then you
can *remove* all indentation by setting ``defaultIndent: ``.

``lookForAlignDelims``: *fields*

 .. _yaml:lookforaligndelims:

.. code-block:: latex
   :caption: ``lookForAlignDelims`` (basic) 
   :name: lst:aligndelims:basic

    lookForAlignDelims:
       tabular: 1
       tabularx: 1
       longtable: 1
       array: 1
       matrix: 1
       ...
        

This contains a list of environments and/or commands that are operated
upon in a special way by ``latexindent.pl`` (see
:numref:`lst:aligndelims:basic`). In fact, the fields in
``lookForAlignDelims`` can actually take two different forms: the
*basic* version is shown in :numref:`lst:aligndelims:basic` and the
*advanced* version in :numref:`lst:aligndelims:advanced`; we will
discuss each in turn.

The environments specified in this field will be operated on in a
special way by ``latexindent.pl``. In particular, it will try and align
each column by its alignment tabs. It does have some limitations
(discussed further in :numref:`sec:knownlimitations`), but in many
cases it will produce results such as those in
:numref:`lst:tabularbefore:basic` and
:numref:`lst:tabularafter:basic`.

If you find that ``latexindent.pl`` does not perform satisfactorily on
such environments then you can set the relevant key to ``0``, for
example ``tabular: 0``; alternatively, if you just want to ignore
*specific* instances of the environment, you could wrap them in
something from ``noIndentBlock`` (see :numref:`lst:noIndentBlock`).

 .. literalinclude:: demonstrations/tabular1.tex
 	:caption: ``tabular1.tex`` 
 	:name: lst:tabularbefore:basic

 .. literalinclude:: demonstrations/tabular1-default.tex
 	:caption: ``tabular1.tex`` default output 
 	:name: lst:tabularafter:basic

If, for example, you wish to remove the alignment of the ``\\`` within a
delimiter-aligned block, then the advanced form of
``lookForAlignDelims`` shown in :numref:`lst:aligndelims:advanced` is
for you.

 .. literalinclude:: demonstrations/tabular.yaml
 	:caption: ``tabular.yaml`` 
 	:name: lst:aligndelims:advanced

Note that you can use a mixture of the basic and advanced form: in
:numref:`lst:aligndelims:advanced` ``tabular`` and ``tabularx`` are
advanced and ``longtable`` is basic. When using the advanced form, each
field should receive at least 1 sub-field, and *can* (but does not have
to) receive any of the following fields:

-  ``delims``: binary switch (0 or 1) equivalent to simply specifying,
   for example, ``tabular: 1`` in the basic version shown in
   :numref:`lst:aligndelims:basic`. If ``delims`` is set to ``0`` then
   the align at ampersand routine will not be called for this code block
   (default: 1);

-  ``alignDoubleBackSlash``: binary switch (0 or 1) to determine if
   ``\\`` should be aligned (default: 1);

-  ``spacesBeforeDoubleBackSlash``: optionally, \*update to
   spacesBeforeDoubleBackSlash in ampersand alignment specifies the
   number (integer :math:`\geq` 0) of spaces to be inserted before
   ``\\`` (default: 1). [2]_

-  ``multiColumnGrouping``: binary switch (0 or 1) that details if
   ``latexindent.pl`` should group columns above and below a
   ``\multicolumn`` command (default: 0);

-  ``alignRowsWithoutMaxDelims``: binary switch (0 or 1) that details if
   rows that do not contain the maximum number of delimeters should be
   formatted so as to have the ampersands aligned (default: 1);

-  ``spacesBeforeAmpersand``: optionally specifies the number (integer
   :math:`\geq` 0) of spaces to be placed *before* ampersands (default:
   1);

-  ``spacesAfterAmpersand``: optionally specifies the number (integer
   :math:`\geq` 0) of spaces to be placed *After* ampersands (default:
   1);

-  ``justification``: optionally specifies the justification of each
   cell as either *left* or *right* (default: left).

We will explore each of these features using the file ``tabular2.tex``
in :numref:`lst:tabular2` (which contains a ``\multicolumn`` command),
and the YAML files in :numref:`lst:tabular2YAML` –
:numref:`lst:tabular8YAML`.

 .. literalinclude:: demonstrations/tabular2.tex
 	:caption: ``tabular2.tex`` 
 	:name: lst:tabular2

 .. literalinclude:: demonstrations/tabular2.yaml
 	:caption: ``tabular2.yaml`` 
 	:name: lst:tabular2YAML

 .. literalinclude:: demonstrations/tabular3.yaml
 	:caption: ``tabular3.yaml`` 
 	:name: lst:tabular3YAML

 .. literalinclude:: demonstrations/tabular4.yaml
 	:caption: ``tabular4.yaml`` 
 	:name: lst:tabular4YAML

 .. literalinclude:: demonstrations/tabular5.yaml
 	:caption: ``tabular5.yaml`` 
 	:name: lst:tabular5YAML

 .. literalinclude:: demonstrations/tabular6.yaml
 	:caption: ``tabular6.yaml`` 
 	:name: lst:tabular6YAML

 .. literalinclude:: demonstrations/tabular7.yaml
 	:caption: ``tabular7.yaml`` 
 	:name: lst:tabular7YAML

 .. literalinclude:: demonstrations/tabular8.yaml
 	:caption: ``tabular8.yaml`` 
 	:name: lst:tabular8YAML

On running the commands

::

    latexindent.pl tabular2.tex 
    latexindent.pl tabular2.tex -l tabular2.yaml
    latexindent.pl tabular2.tex -l tabular3.yaml
    latexindent.pl tabular2.tex -l tabular2.yaml,tabular4.yaml
    latexindent.pl tabular2.tex -l tabular2.yaml,tabular5.yaml
    latexindent.pl tabular2.tex -l tabular2.yaml,tabular6.yaml
    latexindent.pl tabular2.tex -l tabular2.yaml,tabular7.yaml
    latexindent.pl tabular2.tex -l tabular2.yaml,tabular8.yaml
            

we obtain the respective outputs given in
:numref:`lst:tabular2-default` – :numref:`lst:tabular2-mod8`.

 .. literalinclude:: demonstrations/tabular2-default.tex
 	:caption: ``tabular2.tex`` default output 
 	:name: lst:tabular2-default
 .. literalinclude:: demonstrations/tabular2-mod2.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular2YAML` 
 	:name: lst:tabular2-mod2
 .. literalinclude:: demonstrations/tabular2-mod3.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular3YAML` 
 	:name: lst:tabular2-mod3
 .. literalinclude:: demonstrations/tabular2-mod4.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular2YAML` and :numref:`lst:tabular4YAML` 
 	:name: lst:tabular2-mod4
 .. literalinclude:: demonstrations/tabular2-mod5.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular2YAML` and :numref:`lst:tabular5YAML` 
 	:name: lst:tabular2-mod5
 .. literalinclude:: demonstrations/tabular2-mod6.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular2YAML` and :numref:`lst:tabular6YAML` 
 	:name: lst:tabular2-mod6
 .. literalinclude:: demonstrations/tabular2-mod7.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular2YAML` and :numref:`lst:tabular7YAML` 
 	:name: lst:tabular2-mod7
 .. literalinclude:: demonstrations/tabular2-mod8.tex
 	:caption: ``tabular2.tex`` using :numref:`lst:tabular2YAML` and :numref:`lst:tabular8YAML` 
 	:name: lst:tabular2-mod8

Notice in particular:

-  in both :numref:`lst:tabular2-default` and
   :numref:`lst:tabular2-mod2` all rows have been aligned at the
   ampersand, even those that do not contain the maximum number of
   ampersands (3 ampersands, in this case);

-  in :numref:`lst:tabular2-default` the columns have been aligned at
   the ampersand;

-  in :numref:`lst:tabular2-mod2` the ``\multicolumn`` command has
   grouped the :math:`2` columns beneath *and* above it, because
   ``multiColumnGrouping`` is set to :math:`1` in
   :numref:`lst:tabular2YAML`;

-  in :numref:`lst:tabular2-mod3` rows 3 and 6 have *not* been aligned
   at the ampersand, because ``alignRowsWithoutMaxDelims`` has been to
   set to :math:`0` in :numref:`lst:tabular3YAML`; however, the ``\\``
   *have* still been aligned;

-  in :numref:`lst:tabular2-mod4` the columns beneath and above the
   ``\multicolumn`` commands have been grouped (because
   ``multiColumnGrouping`` is set to :math:`1`), and there are at least
   :math:`4` spaces *before* each aligned ampersand because
   ``spacesBeforeAmpersand`` is set to :math:`4`;

-  in :numref:`lst:tabular2-mod5` the columns beneath and above the
   ``\multicolumn`` commands have been grouped (because
   ``multiColumnGrouping`` is set to :math:`1`), and there are at least
   :math:`4` spaces *after* each aligned ampersand because
   ``spacesAfterAmpersand`` is set to :math:`4`;

-  in :numref:`lst:tabular2-mod6` the ``\\`` have *not* been aligned,
   because ``alignDoubleBackSlash`` is set to ``0``, otherwise the
   output is the same as :numref:`lst:tabular2-mod2`;

-  in :numref:`lst:tabular2-mod7` the ``\\`` *have* been aligned, and
   because ``spacesBeforeDoubleBackSlash`` is set to ``0``, there are no
   spaces ahead of them; the output is otherwise the same as
   :numref:`lst:tabular2-mod2`.

-  in :numref:`lst:tabular2-mod8` the cells have been
   *right*-justified; note that cells above and below the ``\multicol``
   statements have still been group correctly, because of the settings
   in :numref:`lst:tabular2YAML`.

As of Version 3.0, the alignment routine works on mandatory and optional
arguments within commands, and also within ‘special’ code blocks (see
``specialBeginEnd`` on ); for example, assuming that you have a command
called ``\matrix`` and that it is populated within
``lookForAlignDelims`` (which it is, by default), and that you run the
command

::

    latexindent.pl matrix1.tex 
        

then the before-and-after results shown in :numref:`lst:matrixbefore`
and :numref:`lst:matrixafter` are achievable by default.

 .. literalinclude:: demonstrations/matrix1.tex
 	:caption: ``matrix1.tex`` 
 	:name: lst:matrixbefore

 .. literalinclude:: demonstrations/matrix1-default.tex
 	:caption: ``matrix1.tex`` default output 
 	:name: lst:matrixafter

If you have blocks of code that you wish to align at the & character
that are *not* wrapped in, for example, ``\begin{tabular}``
…\ ``\end{tabular}``, then you can use the mark up illustrated in
:numref:`lst:alignmentmarkup`; the default output is shown in
:numref:`lst:alignmentmarkup-default`. Note that the ``%*`` must be
next to each other, but that there can be any number of spaces (possibly
none) between the ``*`` and ``\begin{tabular}``; note also that you may
use any environment name that you have specified in
``lookForAlignDelims``.

 .. literalinclude:: demonstrations/align-block.tex
 	:caption: ``align-block.tex`` 
 	:name: lst:alignmentmarkup

 .. literalinclude:: demonstrations/align-block-default.tex
 	:caption: ``align-block.tex`` default output 
 	:name: lst:alignmentmarkup-default

With reference to :numref:`tab:code-blocks` and the, yet undiscussed,
fields of ``noAdditionalIndent`` and ``indentRules`` (see
:numref:`sec:noadd-indent-rules`), these comment-marked blocks are
considered ``environments``.

``indentAfterItems``: *fields*

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``indentAfterItems`` 
 	:name: lst:indentafteritems
 	:lines: 183-187
 	:linenos:
 	:lineno-start: 183

The environment names specified in ``indentAfterItems`` tell
``latexindent.pl`` to look for ``\item`` commands; if these switches are
set to ``1`` then indentation will be performed so as indent the code
after each ``item``. A demonstration is given in
:numref:`lst:itemsbefore` and :numref:`lst:itemsafter`

 .. literalinclude:: demonstrations/items1.tex
 	:caption: ``items1.tex`` 
 	:name: lst:itemsbefore

 .. literalinclude:: demonstrations/items1-default.tex
 	:caption: ``items1.tex`` default output 
 	:name: lst:itemsafter

``itemNames``: *fields*

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``itemNames`` 
 	:name: lst:itemNames
 	:lines: 193-195
 	:linenos:
 	:lineno-start: 193

| If you have your own ``item`` commands (perhaps you prefer to use
  ``myitem``, for example) then you can put populate them in
  ``itemNames``. For example, users of the ``exam`` document class might
  like to add ``parts`` to ``indentAfterItems`` and ``part`` to
  ``itemNames`` to their user settings (see :numref:`sec:indentconfig`
  for details of how to configure user settings, and
  :numref:`lst:mysettings`
| in particular

 .. _page:examsettings:

.)

``specialBeginEnd``: *fields*

 .. _yaml:specialBeginEnd:

The fields specified \*specialBeginEnd in ``specialBeginEnd`` are, in
their default state, focused on math mode begin and end statements, but
there is no requirement for this to be the case;
:numref:`lst:specialBeginEnd` shows the default settings of
``specialBeginEnd``.

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``specialBeginEnd`` 
 	:name: lst:specialBeginEnd
 	:lines: 199-212
 	:linenos:
 	:lineno-start: 199

The field ``displayMath`` represents ``\[...\]``, ``inlineMath``
represents ``$...$`` and ``displayMathTex`` represents ``$$...$$``. You
can, of course, rename these in your own YAML files (see
:numref:`sec:localsettings`); indeed, you might like to set up your
own special begin and end statements.

A demonstration of the before-and-after results are shown in
:numref:`lst:specialbefore` and :numref:`lst:specialafter`.

 .. literalinclude:: demonstrations/special1.tex
 	:caption: ``special1.tex`` before 
 	:name: lst:specialbefore

 .. literalinclude:: demonstrations/special1-default.tex
 	:caption: ``special1.tex`` default output 
 	:name: lst:specialafter

For each field, ``lookForThis`` is set to ``1`` by default, which means
that ``latexindent.pl`` will look for this pattern; you can tell
``latexindent.pl`` not to look for the pattern, by setting
``lookForThis`` to ``0``.

There are examples in which it is advantageous to search for
``specialBeginEnd`` fields *before* searching for commands, and the
``specialBeforeCommand`` switch controls this behaviour. For example,
consider the file shown in :numref:`lst:specialLRbefore`.

 .. literalinclude:: demonstrations/specialLR.tex
 	:caption: ``specialLR.tex`` 
 	:name: lst:specialLRbefore

Now consider the YAML files shown in
:numref:`lst:specialsLeftRight-yaml` and
:numref:`lst:specialBeforeCommand-yaml`

 .. literalinclude:: demonstrations/specialsLeftRight.yaml
 	:caption: ``specialsLeftRight.yaml`` 
 	:name: lst:specialsLeftRight-yaml

 .. literalinclude:: demonstrations/specialBeforeCommand.yaml
 	:caption: ``specialBeforeCommand.yaml`` 
 	:name: lst:specialBeforeCommand-yaml

Upon running the following commands

::

    latexindent.pl specialLR.tex -l=specialsLeftRight.yaml      
    latexindent.pl specialLR.tex -l=specialsLeftRight.yaml,specialBeforeCommand.yaml      
        

we receive the respective outputs in
:numref:`lst:specialLR-comm-first-tex` and
:numref:`lst:specialLR-special-first-tex`.

 .. literalinclude:: demonstrations/specialLR-comm-first.tex
 	:caption: ``specialLR.tex`` using :numref:`lst:specialsLeftRight-yaml` 
 	:name: lst:specialLR-comm-first-tex

 .. literalinclude:: demonstrations/specialLR-special-first.tex
 	:caption: ``specialLR.tex`` using :numref:`lst:specialsLeftRight-yaml` and :numref:`lst:specialBeforeCommand-yaml` 
 	:name: lst:specialLR-special-first-tex

Notice that in:

-  :numref:`lst:specialLR-comm-first-tex` the ``\left`` has been
   treated as a *command*, with one optional argument;

-  :numref:`lst:specialLR-special-first-tex` the ``specialBeginEnd``
   pattern in :numref:`lst:specialsLeftRight-yaml` has been obeyed
   because :numref:`lst:specialBeforeCommand-yaml` specifies that the
   ``specialBeginEnd`` should be sought *before* commands.

``indentAfterHeadings``: *fields*

 .. literalinclude:: ../defaultSettings.yaml
 	:caption: ``indentAfterHeadings`` 
 	:name: lst:indentAfterHeadings
 	:lines: 222-231
 	:linenos:
 	:lineno-start: 222

This field enables the user to specify indentation rules that take
effect after heading commands such as ``\part``, ``\chapter``,
``\section``, ``\subsection*``, or indeed any user-specified command
written in this field. [3]_

| The default settings do *not* place indentation after a heading, but
  you can easily switch them on by changing
| ``indentAfterThisHeading: 0`` to
| ``indentAfterThisHeading: 1``. The ``level`` field tells
  ``latexindent.pl`` the hierarchy of the heading structure in your
  document. You might, for example, like to have both ``section`` and
  ``subsection`` set with ``level: 3`` because you do not want the
  indentation to go too deep.

You can add any of your own custom heading commands to this field,
specifying the ``level`` as appropriate. You can also specify your own
indentation in ``indentRules`` (see :numref:`sec:noadd-indent-rules`);
you will find the default ``indentRules`` contains ``chapter: " "``
which tells ``latexindent.pl`` simply to use a space character after
headings (once ``indent`` is set to ``1`` for ``chapter``).

For example, assuming that you have the code in
:numref:`lst:headings1yaml` saved into ``headings1.yaml``, and that
you have the text from :numref:`lst:headings1` saved into
``headings1.tex``.

 .. literalinclude:: demonstrations/headings1.yaml
 	:caption: ``headings1.yaml`` 
 	:name: lst:headings1yaml

 .. literalinclude:: demonstrations/headings1.tex
 	:caption: ``headings1.tex`` 
 	:name: lst:headings1

If you run the command

::

    latexindent.pl headings1.tex -l=headings1.yaml

then you should receive the output given in
:numref:`lst:headings1-mod1`.

 .. literalinclude:: demonstrations/headings1-mod1.tex
 	:caption: ``headings1.tex`` using :numref:`lst:headings1yaml` 
 	:name: lst:headings1-mod1

 .. literalinclude:: demonstrations/headings1-mod2.tex
 	:caption: ``headings1.tex`` second modification 
 	:name: lst:headings1-mod2

Now say that you modify the ``YAML`` from :numref:`lst:headings1yaml`
so that the ``paragraph`` ``level`` is ``1``; after running

::

    latexindent.pl headings1.tex -l=headings1.yaml

you should receive the code given in :numref:`lst:headings1-mod2`;
notice that the ``paragraph`` and ``subsection`` are at the same
indentation level.

``maximumIndentation``: *horizontal space*

You can control the maximum indentation given to your file by specifying
the ``maximumIndentation`` field as horizontal space (but *not*
including tabs). This feature uses the ``Text::Tabs`` module (“Text:Tabs
Perl Module” 2017), and is *off* by default.

For example, consider the example shown in :numref:`lst:mult-nested`
together with the default output shown in
:numref:`lst:mult-nested-default`.

 .. literalinclude:: demonstrations/mult-nested.tex
 	:caption: ``mult-nested.tex`` 
 	:name: lst:mult-nested

 .. literalinclude:: demonstrations/mult-nested-default.tex
 	:caption: ``mult-nested.tex`` default output 
 	:name: lst:mult-nested-default

Now say that, for example, you have the ``max-indentation1.yaml`` from
:numref:`lst:max-indentation1yaml` and that you run the following
command:

::

    latexindent.pl mult-nested.tex -l=max-indentation1
        

You should receive the output shown in
:numref:`lst:mult-nested-max-ind1`.

 .. literalinclude:: demonstrations/max-indentation1.yaml
 	:caption: ``max-indentation1.yaml`` 
 	:name: lst:max-indentation1yaml

 .. literalinclude:: demonstrations/mult-nested-max-ind1.tex
 	:caption: ``mult-nested.tex`` using :numref:`lst:max-indentation1yaml` 
 	:name: lst:mult-nested-max-ind1

Comparing the output in :numref:`lst:mult-nested-default` and
:numref:`lst:mult-nested-max-ind1` we notice that the (default) tabs
of indentation have been replaced by a single space.

In general, when using the ``maximumIndentation`` feature, any leading
tabs will be replaced by equivalent spaces except, of course, those
found in ``verbatimEnvironments`` (see
:numref:`lst:verbatimEnvironments`) or ``noIndentBlock`` (see
:numref:`lst:noIndentBlock`).

 .. _subsubsec:code-blocks:

The code blocks known ``latexindent.pl``
----------------------------------------

As of Version 3.0, ``latexindent.pl`` processes documents using code
blocks; each of these are shown in :numref:`tab:code-blocks`.

 .. _tab:code-blocks:

m.3@

m.4@

m.2

| Code block & characters allowed in name & example
| environments & ``a-zA-Z@\*0-9_\\`` &

::

    \begin{myenv}
    body of myenv
    \end{myenv}
      

| 
| optionalArguments & *inherits* name from parent (e.g environment name)
  &

::

      

| 
| mandatoryArguments & *inherits* name from parent (e.g environment
  name) &

::

    {
    mand arg text
    }
      

| 
| commands & ``+a-zA-Z@\*0-9_\:`` &
  ``\mycommand``\ :math:`\langle`\ *arguments\ :math:`\rangle`
  keyEqualsValuesBracesBrackets & ``a-zA-Z@\*0-9_\/.\h\{\}:\#-`` &
  ``my key/.style=``\ :math:`\langle`\ *arguments\ :math:`\rangle`
  namedGroupingBracesBrackets & ``a-zA-Z@\*><`` &
  ``in``\ :math:`\langle`\ *arguments\ :math:`\rangle`
  UnNamedGroupingBracesBrackets & *No name!* & ``{`` or ``[`` or ``,``
  or ``&`` or ``)`` or ``(`` or ``$`` followed by
  :math:`\langle`\ *arguments\ :math:`\rangle`
  ifElseFi & ``@a-zA-Z`` but must begin with either ``\if`` of ``\@if``
  &****

::

    \ifnum...
    ...
    \else
    ...
    \fi
      

| 
| items & User specified, see :numref:`lst:indentafteritems` and
  :numref:`lst:itemNames` &

::

    \begin{enumerate}
      \item ...
    \end{enumerate}
      

| 
| specialBeginEnd & User specified, see :numref:`lst:specialBeginEnd`
  &

::

    \[
      ...
    \]
      

| 
| afterHeading & User specified, see :numref:`lst:indentAfterHeadings`
  &

::

    \chapter{title}
      ...
    \section{title}
      

| 
| filecontents & User specified, see
  :numref:`lst:fileContentsEnvironments` &

::

    \begin{filecontents}
    ...
    \end{filecontents}
      

| 

We will refer to these code blocks in what follows.

.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   <div id="ref-log4perl">

“Log4perl Perl Module.” 2017. Accessed September 24.
http://search.cpan.org/~mschilli/Log-Log4perl-1.49/lib/Log/Log4perl.pm.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-texttabs">

“Text:Tabs Perl Module.” 2017. Accessed July 6.
http://search.cpan.org/~muir/Text-Tabs+Wrap-2013.0523/lib.old/Text/Tabs.pm.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-vosskuhle">

Voßkuhle, Michel. 2013. “Remove Trailing White Space.” November 10.
https://github.com/cmhughes/latexindent.pl/pull/12.

.. raw:: html

   </div>

.. raw:: html

   </div>

.. [1]
   Throughout this manual, listings shown with line numbers represent
   code taken directly from ``defaultSettings.yaml``.

.. [2]
   Previously this only activated if ``alignDoubleBackSlash`` was set to
   ``0``.

.. [3]
   There is a slight difference in interface for this field when
   comparing Version 2.2 to Version 3.0; see :numref:`app:differences`
   for details.
