import re

with open('manuscript.tex', 'r') as f:
    text = f.read()

# Replace Paragraph 1
p1_old = r"The relationship between cultural tastes and social networks has been conceptualized in two contrasting ways in sociological theory\. The.*?must exhibit corresponding volatility\."
p1_new = """The relationship between cultural tastes and social networks has been conceptualized in two contrasting ways in sociological theory. The \\textbf{network transmission perspective}, drawing on constructural imagery \\citep{carley1991}, views tastes as malleable, network-contingent contents \\citep{erickson1988, erickson1996, mark1998a, mark2003}. In this view, social ties constitute the pre-existing ``infrastructure'' or ``pipes'' through which cultural practices diffuse \\citep{borgatti2005, erickson1996}. Tastes are learned, adopted, and abandoned based on continuous exchange of cultural information and local bandwagon imitation within an actor's immediate ego network \\citep{mark2003}. Because personal networks exhibit substantial over-time volatility---with 30\\% to 60\\% turnover annually in most personal networks \\citep{morgan1997, suitor1997}---the network transmission perspective implies that individual tastes must exhibit corresponding volatility."""
text = re.sub(p1_old, p1_new.replace('\\', '\\\\'), text, flags=re.DOTALL)

# Replace Paragraph 2
p2_old = r"In contrast, the \\textbf\{cultural capital perspective\}.*?constraint \\citep\{carley1991, dimaggio1987\}\."
p2_new = """In contrast, the \\textbf{cultural capital perspective} conceptualizes tastes as highly durable, embodied dispositions reaped from early socialization \\citep{bourdieu1984, bourdieu1990, holt1997, holt1998}. Emphasizing the ``interconvertibility'' of different forms of capital \\citep{bourdieu1986}, this view sees cultural aptitudes not merely as by-products of ties, but as fundamental resources that help people form and sustain network connections. Here, networks are seen as fleeting structures built and maintained via interactions \\citep{dimaggio1987}, and individuals actively use pre-existing tastes to construct novel relationships or shed culturally incompatible ties \\citep{vaisey2010}. If tastes are durable and personal networks are volatile, it is highly probable that tastes serve as \\emph{drivers} of network connections rather than being exclusively determined by them \\citep{lizardo2006}. This leads to the concept of \\textbf{choice homophily} or cultural matching: new social connections are selected, and existing connections are maintained, based on pre-existing cultural compatibility \\citep{lazarsfeld1954, werner1979}. In other words, socio-demographic homophily may frequently operate as a \\emph{by-product} of active contact selection keyed around cultural alignment, rather than homophily acting as an exogenous structural constraint \\citep{carley1991, dimaggio1987}."""
text = re.sub(p2_old, p2_new.replace('\\', '\\\\'), text, flags=re.DOTALL)

with open('manuscript.tex', 'w') as f:
    f.write(text)
