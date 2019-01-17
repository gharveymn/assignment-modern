\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{assignment-modern}[2018/09/19 v0.2 A class for making modern-style assignments]

% Passes class options to the underlying article class
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}

% Remove the numbers from all the headings (\section, \subsection, etc.)
\setcounter{secnumdepth}{-1}

% To modify the heading styles more thoroughly use the titlesec package
%\RequirePackage{titlesec}

% Adjust the title page design
% NOTE: This is the default LaTeX title page -- free free to make it look like whatever you want.
% TODO: Add company name and logo somewhere in here.
\newcommand{\maketitlepage}{%
	\null\vfil
	\vskip 60\p@
	\begin{center}%
		{\LARGE \@title \par}\vskip 3em{%
			\large%
			\lineskip .75em%
			\begin{tabular}[t]{c}%
				\@author%
			\end{tabular}\par%
		}%
		\vskip 1.5em%
		{\large \@date \par}%       % Set date in \large size.
	\end{center}\par%
	\@thanks%
	\vfil\null%
	\end{titlepage}%
}

\renewcommand\maketitle{%
	\begin{titlepage}%
	\let\footnotesize\small%
	\let\footnoterule\relax%
	\let \footnote \thanks%
	\maketitlepage%
	\setcounter{footnote}{0}%
	\global\let\thanks\relax
	\global\let\maketitle\relax
	\global\let\@thanks\@empty
	\global\let\@author\@empty
	\global\let\@date\@empty
	\global\let\@title\@empty
	\global\let\title\relax
	\global\let\author\relax
	\global\let\date\relax
	\global\let\and\relax
}

% redefine the subsection command (from latex.ltx)
\def\@ssect#1#2#3#4#5{%
	\@tempskipa #3\relax%
	\ifdim \@tempskipa>\z@%
	\begingroup #4{%
		\@hangfrom{\hskip #1}%
		\interlinepenalty \@M \colorbox[rgb]{0,0,0}{\kern0.15em\textcolor{white}{#5}\kern0.15em}\@@par%
	}%
	\endgroup%
	\else%
	\def\@svsechd{#4{\hskip #1\relax #5}}%
	\fi%
	\@xsect{#3}%
}

% redefine the paragraph command (from article.cls)
\renewcommand\paragraph{%
	\@startsection{paragraph}{4}{\z@}%
	{\z@}%
	{-1em}%
	{\normalfont\normalsize\bfseries}%
}
  
\newif\if@insolution
\@insolutionfalse

\newif\if@prob	       %problem if true
\@probtrue

\newif\if@example	  %example if true
\@exampletrue
 
\newcommand{\problemtitle}[3][]{%
	\noindent%
	\textcolor{darkgray}{%
		\raisebox{0.25ex}{#2}%
	}%
	\nobreakspace{%
		\sffamily\textbf{%
			#3%
			\def\temp{#1}\ifx\temp\empty%
			{}
			\else%
			{ (#1)}%
			\fi
		}%
	}%
}

\newcommand{\solutionendline}{%
	\vskip 0.025in \hfill\makebox[0pt][c]{$\rule{150pt}{0.42pt}$}\makebox[27.60374pt][r]{}
}

\newenvironment{ProblemEnv}[1][]{%
	\vspace{\parskip}%
	\leftskip=0pt%
	\rightskip=0pt%
	\if@prob%
		\if@example%
			\problemtitle[#1]{$\blacktriangleright$}{Example}%
		\else%
			\problemtitle[#1]{$\blacktriangleright$}{Problem}%
		\fi%
	\else%
		\problemtitle[#1]{$\blacktriangleleft$}{Solution}%
	\fi%
	\MakeFramed{\advance\hsize-\width}%
	\ignorespaces%
}{%
	\if@prob\else{%
		\noindent%
		\solutionendline%
	}%
	\fi%
	\unskip%
	\endMakeFramed%
}%

\newif\if@framedsolutions
\@framedsolutionstrue
% If the user said \unframedsolutions, then both
% \if@framedsolutions and \if@shadedsolutions are false.

\def\framedsolutions{\@framedsolutionstrue\@shadedsolutionsfalse}
\def\unframedsolutions{\@framedsolutionsfalse\@shadedsolutionsfalse}

\newenvironment{problem}[1][]%
  {%
    \FrameRestore
    \@insolutiontrue % cancelled by the end of the environment
    \@probtrue
    \@examplefalse
    \begin{ProblemEnv}[#1]%
  }{%
    \end{ProblemEnv}%
  }%

\newenvironment{example}[1][]%
  {%
    \FrameRestore
    \@insolutiontrue % cancelled by the end of the environment
    \@probtrue
    \@exampletrue
    \begin{ProblemEnv}[#1]%
  }{%
    \end{ProblemEnv}%
  }%

\newenvironment{solution}[1][]%
  {%
    \def\FrameCommand{}%
    \@insolutiontrue % cancelled by the end of the environment
    \@probfalse
    \begin{ProblemEnv}[#1]%
  }{%
    \end{ProblemEnv}%
  }%
  
\newdimen\saved@totalleftmargin
\newcount\@sollistdepth

\chardef\FrameRestore=\catcode`\| % for debug
\catcode`\|=\catcode`\% % (debug: insert space after backslash)

\def\MakeFramed#1{\par
  % measure added width and height; call result \width and \height
  \setbox\z@\vbox{\vskip-1in \hbox{\hskip-1in 
    \FrameCommand{\hbox{\vrule \@height .7in \@depth.3in \@width 1in}}}%
    \vskip\z@skip}%
  \def\width{\wd\z@}\def\height{\ht\z@}%
  \edef\fb@frw{\the\width}\edef\fb@frh{\the\height}%
  % insert pre-penalties and skips
  \begingroup
  \skip@\lastskip
  \if@nobreak\else 
    \penalty9999 % updates \page parameters
    \ifdim\pagefilstretch=\z@ \ifdim\pagefillstretch=\z@
       \edef\@tempa{\the\skip@}%
       \ifx\@tempa\zero@glue \penalty-30
       \else \vskip-\skip@ \penalty-30 \vskip\skip@
    \fi\fi\fi
    \penalty\z@
    % Give a stretchy breakpoint that will always be taken in preference
    % to the \penalty 9999 used to update page parameters.  The cube root
    % of 10000/100 indicates a multiplier of 0.21545, but the maximum 
    % calculated badness is really 8192, not 10000, so the multiplier
    % is 0.2301. 
    \advance\skip@ \z@ plus-.5\baselineskip
    \advance\skip@ \z@ plus-.231\height
    \advance\skip@ \z@ plus-.231\skip@
    \advance\skip@ \z@ plus-.231\topsep
    \vskip-\skip@ \penalty 1800 \vskip\skip@
  \fi
  \addvspace{\topsep}%
  \endgroup
  % clear out pending page break
  \penalty\@M \vskip 2\baselineskip \vskip\height
  \penalty9999 \vskip -2\baselineskip \vskip-\height
  \penalty9999 % updates \pagetotal
| \message{After clearout, \pagetotal=\the\pagetotal, \pagegoal=\the\pagegoal. }%
  \fb@adjheight 
%psh: Added commands:
  \advance\hsize-\@totalleftmargin
  \saved@totalleftmargin=\@totalleftmargin
  \@totalleftmargin=0pt
  \parshape 0
  \let\@listdepth=\@sollistdepth
  \@sollistdepth=0
  \leftmargin=0pt
%psh: end of added commands
 \setbox\@tempboxa\vbox\bgroup
   #1% Modifications to \hsize (can use \width and \height)
   \textwidth\hsize \columnwidth\hsize
%psh: added one line:
   \linewidth=\hsize
}

\def\endMakeFramed{\par
     \kern\z@ \penalty-100 % put depth into height
 \egroup
 \begingroup \put@frame \endgroup
%psh: Added one line:
 \@totalleftmargin=\saved@totalleftmargin
}

% \put@frame takes the contents of \@tempboxa and puts all, or a piece,
% of it on the page with a frame (\FrameCommand).  It recurses until
% all of \@tempboxa has been used up. (\@tempboxa must have zero depth.)

\def\put@frame{\relax
 \ifdim\pagegoal=\maxdimen \pagegoal\vsize \fi
|   \message{=============== Entering putframe ====================^^J
|     \pagegoal=\the\pagegoal,  \pagetotal=\the\pagetotal. }%
 \ifinner \else
    \dimen@\pagegoal \advance\dimen@-\pagetotal % natural space left on page
  \ifdim\dimen@<2\baselineskip 
|   \message{Page has only \the\dimen@\space room left; eject. }%
    \eject \fb@adjheight \put@frame
  \else % there's appreciable room left on the page
|    \message{\string\pagetotal=\the\pagetotal,
|        \string\pagegoal=\the\pagegoal, 
|        \string\pagestretch=\the\pagestretch,
|        \string\pageshrink=\the\pageshrink,
|        \string\fb@frh=\fb@frh. \space}
|    \message{Box of size \the\ht\@tempboxa\space + \fb@frh}%
     \begingroup % temporarily set \dimen@ to be...
     \advance\dimen@.8\pageshrink  % maximum space available on page
     \advance\dimen@-\fb@frh\relax % space available for frame's contents
     \expandafter\endgroup
     % restore \dimen@ to real room left on page
     \ifdim\dimen@>\ht\@tempboxa % whole box does fit
|       \message{fits in \the\dimen@. }%
     \else % box must be split
|       \message{must be split to fit in \the\dimen@. }%
        \setbox\@tempboxa\vbox{% simulate frame and flexiblity of the page:
           \vskip \fb@frh \@plus\pagestretch \@minus.8\pageshrink
           \kern137sp\kern-137sp\penalty-30
           \unvbox\@tempboxa}%
        \edef\fb@resto@set{\boxmaxdepth\the\boxmaxdepth \splittopskip\the\splittopskip}%
        \boxmaxdepth\z@ \splittopskip\z@
        \setbox\tw@\vsplit\@tempboxa to\dimen@
        \setbox\tw@\vbox{\unvbox\tw@}% natural-sized
|       \message{Box of size \the\ht\@tempboxa\space split to \the\dimen@. 
|          Natural height of split box is \the\ht\tw@. }%
        % If the split-to size > (\vsize-\topskip), then set box to full size
        \begingroup
          \advance\dimen@\topskip
          \expandafter\endgroup
        \ifdim\dimen@>\pagegoal
|         \message{Frame is big -- Use up the full column. }%
          \dimen@ii\pagegoal
          \advance\dimen@ii -\topskip
          \advance\dimen@ii \FrameHeightAdjust\relax
        \else  % suspect this is wrong:
          % If the split-to size > feasible room_on_page, rebox it smaller.
          \advance\dimen@.8\pageshrink
          \ifdim\ht\tw@>\dimen@
|           \message{Box too tall; rebox it to \the\dimen@. }%
            \dimen@ii\dimen@
          \else % use natural size
            \dimen@ii\ht\tw@
          \fi
        \fi
        % Re-box contents to desired size \dimen@ii
        \advance\dimen@ii -\fb@frh
        \setbox\tw@\vbox to\dimen@ii \bgroup
        % remove simulated frame and page flexibility:
        \vskip -\fb@frh \@plus-\pagestretch \@minus-.8\pageshrink
        \unvbox\tw@ \unpenalty\unpenalty
        \ifdim\lastkern=-137sp % whole box went to next page
|          \message{box split at beginning! }%
           \egroup \fb@resto@set \eject % (\vskip for frame size was discarded) 
           \fb@adjheight
        \else %
           \egroup \fb@resto@set
           \ifvoid\@tempboxa % it all fit after all
|             \message{box split at end! }%
              \setbox\@tempboxa\box\tw@
           \else % it really did split
|             \message{box split as expected. Its reboxed height is \the\ht\tw@. }%
              \ifdim\wd\tw@>\z@
%psh: Changed the command that inserts the box:
%     Instead of \centerline, we shift right by \saved@totalleftmargin:
%              \centerline{\FrameCommand{\box\tw@}}%  ??? \centerline bad idea
       \hbox{\hskip \saved@totalleftmargin\FrameCommand{\box\tw@}}%
              \else
|               \message{Zero width means likely blank. Don't frame it (guess)}%
                \box\tw@
              \fi
              \hrule \@height\z@
              \eject
              \fb@adjheight
              \put@frame
  \fi\fi\fi\fi\fi
  \ifvoid\@tempboxa\else
%psh: Changed the command that inserts the box:
%     Instead of \centerline, we shift right by \saved@totalleftmargin:
%    \centerline{\FrameCommand{\box\@tempboxa}}%
    \hbox{\hskip\saved@totalleftmargin\FrameCommand{\box\@tempboxa}}%
    \nointerlineskip \null %{\showoutput \showlists}
    \penalty-30 \vskip\topsep
  \fi}

\def\fb@adjheight{%
  \vbox to\FrameHeightAdjust{}% get proper baseline skip from above.
  \penalty\@M \nointerlineskip
  \vskip-\FrameHeightAdjust
  \penalty\@M} % useful for tops of pages

\edef\zero@glue{\the\z@skip}

\catcode`\|=\FrameRestore

% Provide configuration commands:
\providecommand\FrameCommand{\fboxrule=\FrameRule \fboxsep=\FrameSep \fbox}
\@ifundefined{FrameRule}{\newdimen\FrameRule \FrameRule=\fboxrule}{}
\@ifundefined{FrameSep} {\newdimen\FrameSep  \FrameSep =3\fboxsep}{}

% Height of frame above first baseline when frame starts a page:
\providecommand\FrameHeightAdjust{6pt}

% \FrameRestore has parts of \@parboxrestore.  See how it is used in the 
% "settings" argument of \MakeFrame.  Previous behavior can be restored by 
% using \@parboxrestore there, or redefining:
% \makeatletter \renewcommand\FrameRestore{\@parboxrestore} \makeatother
\def\FrameRestore{%
  \let\if@nobreak\iffalse
  \let\if@noskipsec\iffalse
%  \let\par\@@par  ??
  \let\-\@dischyph
  \let\'\@acci\let\`\@accii\let\=\@acciii
%  \parindent\z@ \parskip\z@skip    Definitely omit!
%  \everypar{}%  ??
  \linewidth\hsize
%  \@totalleftmargin\z@
%  \leftskip\z@skip \rightskip\z@skip \@rightskip\z@skip
%  \parfillskip\@flushglue \lineskip\normallineskip
%  \baselineskip\normalbaselineskip
  \sloppy
%  \let\\\@normalcr
}

%  Compatibility with previous versions (temporary!):
\let\fram@d=\MakeFramed  \let\endfram@d=\endMakeFramed

\RequirePackage{amssymb}
\RequirePackage{atbegshi}
\RequirePackage{picture}
\RequirePackage{xcolor}
