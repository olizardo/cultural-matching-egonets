import re

with open('manuscript.tex', 'r') as f:
    text = f.read()

new_subsection = r"""\subsection{Tastes and Social Networks: Two Perspectives}\label{tastes-and-social-networks-two-perspectives}

The relationship between cultural tastes and social networks has been conceptualized through two distinct theoretical ``ur-models'' in sociological theory. The \textbf{network transmission perspective}, rooted in \emph{constructural imagery} \citep{carley1991}, views networks as the pre-existing ``infrastructure'' and tastes as the malleable contents that flow through them \citep{erickson1996, mark1998a}. In this view, social ties constitute the ``pipes'' through which cultural practices diffuse \citep{borgatti2005}. Tastes are learned, adopted, and abandoned based on the continuous exchange of cultural information and local bandwagon imitation within an actor's immediate ego network \citep{mark2003}. Because personal networks exhibit substantial over-time volatility---with 30\% to 60\% turnover annually \citep{morgan1997, suitor1997}---the network transmission perspective implies that individual tastes must exhibit corresponding volatility.

In contrast, the \textbf{cultural capital perspective} conceptualizes tastes as highly durable, embodied dispositions reaped from early socialization \citep{bourdieu1984, bourdieu1990}. Building on the ``interconvertibility'' of different forms of capital \citep{bourdieu1986}, this view emphasizes a \emph{culture conversion mechanism}: cultural aptitudes serve as fundamental resources utilized to accumulate and sustain social capital. From this perspective, networks are not fixed infrastructures but rather ``fleeting'' structures built and maintained via ongoing cultural interactions and conversations \citep{dimaggio1987, lizardo2006}. Individuals actively leverage their pre-existing tastes to construct novel relationships or to shed culturally incompatible ties \citep{vaisey2010}. If tastes are durable and personal networks are volatile, it is highly probable that tastes serve as \emph{drivers} of network connections rather than being exclusively determined by them. This leads to the concept of \textbf{choice homophily} or cultural matching: new social connections are selected, and existing connections are maintained, based on pre-existing cultural compatibility \citep{lazarsfeld1954, werner1979}. Consequently, socio-demographic homophily may frequently operate as a \emph{by-product} of this culture conversion process keyed around cultural alignment, rather than homophily acting solely as an exogenous structural constraint \citep{carley1991, dimaggio1987}.

"""

pattern = re.compile(r'\\subsection\{Tastes and Social Networks: Two Perspectives\}.*?(?=\\subsection\{Cultural Matching and Tie Persistence\})', re.DOTALL)
text = pattern.sub(new_subsection, text)

with open('manuscript.tex', 'w') as f:
    f.write(text)
