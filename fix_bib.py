with open("manuscript_citations.bib", "r") as f:
    text = f.read()

import re
# Remove the dangling title={Best practices... block and all the Lizardo 2026 blocks
new_text = re.sub(r'  title=\{Best practices.*?year = \{2026\}\n\}', '', text, flags=re.DOTALL)
new_text += """
@article{mize2019best,
  title={Best practices for estimating, interpreting, and presenting nonlinear interaction effects},
  author={Mize, Trenton D},
  journal={Sociological Science},
  volume={6},
  pages={81--117},
  year={2019},
  publisher={Society for Sociological Science}
}
"""

with open("manuscript_citations.bib", "w") as f:
    f.write(new_text)
