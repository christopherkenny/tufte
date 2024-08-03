#let sansfont = ($for(sansfont)$"$sansfont$",$endfor$)

$if(citations)$
#heading(level:1, [References])
#show bibliography: set text(font: sansfont)
#show bibliography: set par(justify: false)
#set bibliography(title: none)

$if(csl)$

#set bibliography(style: "$csl$")
$elseif(bibliographystyle)$

#set bibliography(style: "$bibliographystyle$")
$endif$
$if(bibliography)$

#bibliography($for(bibliography)$"$bibliography$"$sep$,$endfor$)
$endif$
$endif$
