#import "template.typ": *
#import "@preview/truthfy:0.2.0": generate-table, generate-empty
#import "@preview/tablex:0.0.6": tablex, cellx, rowspanx, colspanx
#import "@preview/codelst:2.0.0": sourcecode
#show: setup
#set heading (
    numbering: "1."
)

#let sc = sourcecode.with(
    numbers-style: (lno) => text(
        size: 10pt,
        font: "Times New Roman",
        fill: rgb(255,255,255),
        str(lno)
    ),
    frame: block.with(
        stroke: 1pt + rgb("#a2aabc"),
        radius: 2pt,
        inset: (x: 10pt, y: 5pt),
        fill: rgb("555555")
    )

)


#let hm = h(1mm)


#v(1fr)
#align(center)[#text(32pt)[Funktionsweise eines Rechners \  #align(center)[#image("images/architecture.png", width: 80%)] ] \ Stable Diffusion Art "Computer Architecture"]
#v(1fr)

#pagebreak()

= Historisches

#grid(rows:1, columns:(50%,50%), gutter:10pt, [Die Entwicklung von Computern erstreckt sich über mehrere Jahrhunderte und umfasst zahlreiche bedeutende Meilensteine. Ursprünglich als mechanische Rechenhilfen konzipiert, begann die Evolution der Computer im antiken Griechenland mit mit sehr primitiven Erfindungen wie dem Abakus - eher noch eine Rechenhilfe. Im 19. Jahrhundert entwickelten sich mechanische Rechenmaschinen wie die #link("https://de.wikipedia.org/wiki/Analytical_Engine")[Analytical Engine] von Charles Babbage und Ada Lovelace, die als erste Programmiererin gilt. Babbages erste Konstruktion - die Differenzmaschine - war noch auf eine Aufgabe spezialisert, die Analytical Engine dagegen sollte allgemeiner eine Problemlösemaschine sein.
],[ #align(center)[#image("images/analytical_engine.jpg", width:90%)_Analytical Engine, Quelle: Wikipedia_]])

Der Wendepunkt in der Computerentwicklung kam im 20. Jahrhundert mit der Erfindung des Transistors, der die Grundlage für kleinere, effizientere und zuverlässigere Rechner legte. Die Ära der Großrechner begann in den 1940er Jahren mit dem #link("https://de.wikipedia.org/wiki/ENIAC")[ENIAC], gefolgt vom #link("https://de.wikipedia.org/wiki/UNIVAC_I")[UNIVAC], das erstmals für kommerzielle Zwecke eingesetzt wurde.


#grid(rows:1, columns:(50%,50%), gutter:10pt, [#align(center)[#image("images/eniac.jpg", width:90%)_ENIAC, Quelle: Wikipedia_]
],[Die bahnbrechende Arbeit von Pionieren wie Alan Turing in der Kryptographie und theoretischen Informatik sowie von Grace Hopper, die den ersten Compiler entwickelte, legte den Grundstein für die moderne Computerwissenschaft. Die Entwicklung der #link("https://de.wikipedia.org/wiki/Integrierter_Schaltkreis")[integrierten Schaltkreise] in den 1950er und 1960er Jahren führte zu kleineren, leistungsfähigeren und kostengünstigeren Computern. Spätestens zu diesem Zeitpunkt nahm die Entwicklung dramatisch an Fahrt auf.
])



In den 1970er Jahren revolutionierte die Einführung des Personal Computers (PC) durch Unternehmen wie Apple und IBM die Computerlandschaft. Die Popularisierung grafischer Benutzeroberflächen und Betriebssysteme wie MS-DOS und später Microsoft Windows trugen zur Verbreitung des Computereinsatzes bei.

Die fortlaufende Miniaturisierung von Chips gemäß #link("https://de.wikipedia.org/wiki/Mooresches_Gesetz")[Moores Gesetz] ermöglichte die Entwicklung leistungsfähigerer Prozessoren und Speicher. Jedes Smartphone ist - obwohl täglicher Gebrauchsgegenstand - ein kleines Wunderwerk der Technik.

In diesem Skript können wir nur sehr wenig der tatsächlichen Funktionsweise moderner Rechner erkunden. Stattdessen beschäftigen wir uns - neben grundlegender Schaltungslogik - vorwiegend mit einer (virtuellen) #link("https://de.wikipedia.org/wiki/Registermaschine")[Registermaschine].

#pagebreak()

= Elektronik

== Transistoren

Die moderne Elektronik ist untrennbar mit dem Begriff des *Transistors* verbunden. Ein Transistor ist im Wesentlichen ein (ggf. mikroskopisch kleiner) Schalte. Die untenstehende Abbildung zeigt schematisch den Aufbau.

#grid(columns: (40%,60%), rows:1, gutter:10pt, [#image("images/transistor.png")],[Sobald die *Spannung zwischen Gate und Source* (also die Potentialdifferenz zwischen G und S) einen bestimmten Wert überschreitet, wird der Transistor, also die Verbindung zwischen Drain und Source, leitend. Man sagt, der *Transistor "schaltet"*. Ein häufiger Schwellenwert, der überschritten werden muss, ist 0,7 V.

Wenn die *Spannung zwischen Gate und Source zu klein* bzw. gleich Null ist, dann ist der Transistor nicht leitend, also herrscht zwischen Drain und Source ein sehr großer Widerstand. Man sagt, der Transistor "sperrt".

D.h. unser Gate-Anschluss fungiert als Schalter für den Stromfluss zwischen Drain und Source.
])

In der *digitalen Elektronik* interpretiert man Potentialwerte binär, man spricht also nur noch von "hohem Potential" oder "niedrigem Potential" (also "high" oder "low"). Eine typische Größenordnung für ein hohes Potential ist 5 V.

Es spielt keine Rolle, ob das Potential an einer Stelle 0,2 V oder 0,4 V beträgt, es ist einfach nur niedrig. Ebenso spielt es keine Rolle, ob es 4,1 V oder 4,7 V beträgt, es ist einfach nur hoch.
*Hohes bzw. niedriges Potential* wird dann durch den *Wert 1 bzw. 0* ausgedrückt.

In der Informatik denken wir in den seltensten Fällen noch direkt über Transistoren nach (das ist das Feld der Ingenieure und Elektrotechniker), aber auf einem grundlegenden Niveau sind die Realisierungen *logischer Funktionen* interessant, also die Frage: wie können wir beispielsweise eine AND-Beziehung realisieren (z.B. für die Frage, ob zwei boolean Variablen denselben Wert annehmen).

Die Verknüpfung zur klassischen Logik ist hier natürlich offensichtlich, im Folgenden findet sich eine sogenannte *Wahrheitstabelle* für einige der logischen Operatoren "und" $and$ bzw. $or$ "oder".
#align(center)[
#generate-table($A and B$, $A or B$)
]

Wenn wir 0 und 1 wieder wie oben als "Strom fliesst nicht" und "Strom fliesst" interpretieren, so müssten wir also jeweils eine Schaltung schaffen, die der entsprechenden Tabelle entspricht. D.h. für AND brauchen wir eine Schaltung, bei der nur dann Strom fliesst, wenn *beide* Eingabewerte geschaltet werden. Die Physik der Mittelstufe rät uns dann, in irgendeiner Form eine *Reihenschaltung* zu verwenden.

Mit einer *Parallelschaltung* können wir beispielsweise eine NOR-Funktion realisieren, d.h. ein "invertiertes Oder" (Schauen wir uns obige Wahrheitstabelle an, so darf dort nur Strom fliessen, wenn beide Eingangswerte auf 0 gesetzt sind). Für diesen Fall hier einmal konkret:

Seien $E_1$ und $E_2$ zwei voneinander unabhängige Eingangspotentiale und $A$ das Ausgangspotential, das wir messen wollen.

Ist $E_1 = 1$ und $E_2 = 0$, dann leitet der linke Transistor und der rechte sperrt, der *Gesamtwiderstand* der beiden Transistoren ist wegen des leitenden linken Transistors *fast Null* (es ist in der Parallelschaltung nur nötig, dass einer der beiden Zweite gut leitet), fast das ganze Potential fällt an dem ohm'schen Widerstand ab, das Potential im Punkt A ist also nahe bei 0 V, also gilt: $A = 0$

#grid(columns:(50%,50%), rows: 1, gutter:10pt,[#image("images/NOR.png")], [#v(1.5cm)Mit der zugehörigen Wahrheitstabelle: #align(center)[#table(rows:5, columns:3, [$E_1$],[$E_2$], [$A$], [0],[0],[1],[0],[1],[0], [1],[0],[0],[1],[1],[0])]])

== Logische Schaltungen

*Übersicht über die "klassischen" logischen Funktionen mit zwei Eingangswerten*

#align(center)[
#table(rows:5, columns:8,
[*A*],[*B*],[*AND*],[*NAND*],[*OR*],[*NOR*],[*XOR*],[*XNOR*],
[0],[0],[0],[1],[0],[1],[0],[1],
[0],[1],[0],[1],[1],[0],[1],[0],
[1],[0],[0],[1],[1],[0],[1],[0],
[1],[1],[1],[0],[1],[0],[0],[1])
]

Eine mögliche Darstellung in Schaltplänen ist die folgende (es sind jedoch viele Notationen gebräuchlich):

#align(center)[#image("images/schaltungen.png")]

Soweit können wir nur einzelne Wahrheitswerte bilden, im Folgenden soll kurz skizziert werden, wie wir auf Basis dieser *Logikgatter* zu "Rechnungen" wie z.B. der Addition von Binärzahlen kommen.

== *Halbaddierer und Volladdierer*

Ein Halbaddierer kann zwei einstellige Binärzahlen miteinander addieren. Im Gegensatz zu obigen Gattern besitzt er zwei Eingänge *und* zwei Ausgänge. Ein Ausgang ist dafür gedacht den *Übertrag* (also den "Rest") weiterzugeben, der andere gibt die eigentliche Summe weiter.
#let r(body) = text(red)[#body]
#let b(body) = text(blue)[#body]
Ein Halbaddierer wird üblicherweise mit einem #b[AND] und einem #r[XOR]-Gatter realisiert:


#grid(columns:(50%,50%), rows:1, gutter:10pt, [#v(0.5cm)#align(center)[#table(rows:5, columns:4, [*X*],[*Y*], [#r[*S*]], [#b[*C*]],
[0],[0],[#r[0]],[#b[0]],
[0],[1],[#r[1]],[#b[0]],
[1],[0],[#r[1]],[#b[0]],
[1],[1],[#r[0]],[#b[1]])]],[#image("images/halbaddierer.png", width:50%)])

*Beispiel*: $X = 1$ und $Y = 1$ ist der interessante Fall, denn hier tritt der Übertragsfall auf. Das AND-Gatter stellt sicher, dass der Übertrag auf 1 gesetzt wird (dies ist auch der einzige Fall in dem dies passieren kann) und das XOR-Gatter liefert uns die gewünschte $0$ ($1 + 1 = 0$ mit Übertrag 1!)

Diese Halbaddierer alleine sind noch nicht wirklich beeindruckend (lässt man die Magie der Elektrotechnik außer Acht). Nützlicher wird bereits der *Volladierer*, der drei einstellige Binärzahlen addieren kann. Er besteht im Wesentlichen aus zwei Halbaddierern und einem OR-Gatter (realisierbar mit ca. 25 Transistoren!).

#grid(columns:(30%,70%), rows:1, gutter:10pt, [#align(center)[#table(rows:9, columns:5, inset:8pt, [*X*],[*Y*],[*$C_("in")$*], [#r[*S*]], [#b[*$C_("out")$*]],
[0],[0],[0],[#r[0]],[#b[0]],
[0],[1],[0],[#r[1]],[#b[0]],
[1],[0],[0],[#r[1]],[#b[0]],
[1],[1],[0],[#r[0]],[#b[1]],
[0],[0],[1],[#r[1]],[#b[0]],
[0],[1],[1],[#r[0]],[#b[1]],
[1],[0],[1],[#r[0]],[#b[1]],
[1],[1],[1],[#r[1]],[#b[1]]
)]],[#v(0.2mm)#image("images/volladdierer.png")])

Die Benennung des dritten Eingangs als $C_("in")$ legt bereits nahe, dass sich mit Volladierern ganze Addiernetzwerke realisieren lassen, die dann nicht nur einstellige Binärzahlen addieren können. Für jede Stelle der Summe zweier Binärzahlen benötigt man dann einen Volladdierer. Man verbindet jeweils $C_("in")$ des nächstens Volladdierers mit $C_("out")$ des aktuellen:

#grid(columns:(70%,30%), rows:1, gutter:10pt, [#image("images/addiererkette.png")],[#image("images/addition.png")])


Für einen 64-Bit-Addierer würde man mit dieser Schaltungslogik bereits 1600 Transistoren benötigen!

#align(center)[#image("images/64bitaddition.png", width:30%)]

Hier geht es bisher nur um Addition! Es ist also leicht vorstellbar, dass für komplexere Aufgaben noch weitaus mehr Transistoren notwendig sind. Bisher schien das wenig problematisch, denn es wurde das sogenannte *Moore*sche Gesetz* formuliert:

"Die Anzahl der Transistoren integrierter Schaltkreise verdoppelt sich im Durchschnitt alle zwei Jahre"

#align(center)[#image("images/mooreslaw.png") \ Quelle: Wikipedia]

In der Darstellung ist die y-Achse, also die Anzahl der Transistoren logarithmisch skaliert. Damit wird das exponentielle Wachstum durch die Gerade dargestellt, die durch die gegebenen Punkte approximiert werden kann.

*Beispiel*: Im Jahr 1971 hatte der Intel 4004 2.250 Transistoren eingebaut, die eine Strukturgröße von $10.000 "nm"$ aufwiesen. Der Apple M1 im Jahr 2020 hatte bereits $16.000.000.000$ Transistoren bei einer Strukturgröße von $5 "nm"$ pro Transistor.

Natürlich handelt es sich hier nicht um ein bindendes Gesetz, sondern um eine reine Beobachtung und es bleibt abzuwarten, wie lange der Trend noch fortgeführt werden kann. Bei extrem kleinen Strukturen werden zunehmend Quanteneffekte relevant, die die weitere Verkleinerung verhindern könnten. Moore selbst sagte das Ende seines Gesetzes für ca. 2022 voraus, die Industrie zeigt sich aber selbstsicher und behauptet noch einige Jahre durchhalten zu können.

#pagebreak()

== Speicherung von Daten

Das vorangehende Kapitel lieferte einen sehr kleinen Einblick in die Grundlagen der Rechentechnik. Neben der Berechnung spielt aber natürlich auch die *Speicherung* von Daten eine wesentliche Rolle, wenn man die Architektur eines Rechners verstehen möchte.

Wir betrachten hier ein vereinfachtes Modell einer *DRAM-Zelle* (Dynamic Random Access Memory). Eine solche Zelle besteht im Wesentlichen aus einem Kondensator und einem Transistor. Jede Speicherzelle kann dabei genau ein Bit speichern.

#grid(columns:2, rows:1, gutter:10pt, [*Lesen bzw. Schreiben der Information*:

Der Kondensator C kann geladen (=1) oder ungeladen (=0) sein.

Falls an der Wortleitung, also am Gate des Transistors, das Potential "low" herrscht, sperrt der Transistor. Bitleitung und Kondensator sind nicht verbunden.

Falls an der Wortleitung, also am Gate des Transistors, das Potential "high" herrscht, leitet der Transistor.

Dann befindet sich die Bitleitung auf dem gleichen Potential wie der Kondensator und man kann sein Potential (also die gespeicherte Information 1 bzw. 0) messen oder verändern, also eine Information lesen oder schreiben.

], [#align(center)[#image("images/dramzelle.png") \ Quelle: Wikipedia]] )

Mehrere Speicherzellen zusammen bilden eine *Speicherzeile*.

Wird auf eine Wortleitung ein Signal gelegt, sö können aus allen Speicherzellen der Zeile die darin gespeicherten Informationen gleichzeitig über die Bitleitungen ausgelesen werden, bzw. die auf den Bitleitungen liegenden Signale können simultan in die Zellen dieser Zeile hineingeschrieben werden.

Man könnte sich das Ganze also so vorstellen:
- *Eine Wortleitung* ist ein Schlüssel, der alle Zellen einer Speicherzeile öffnen kann.
- *Mehrere Bitleitungen* sind die Türen, die den Zugang zu den jeweiligen Zellen ermöglichen.

#align(center)[#image("images/speicherzeile.png")\ Quelle: Wikipedia]

== Adressierung und Datenübertragung

Neben der eigentlichen Speicherung der Daten muss natürlich auch die Übertragung der Daten geregelt werden, einerseits muss ein Prozessor (also eine irgendwie geartete "Recheneinheit") Daten an einer bestimmten "Stelle" im Speicher anfordern können - andererseits müssen diese Daten dann auch geliefert werden. Die entsprechenden Leitungen werden *Adressbus* (für die Adressen der Speicherzellen) und *Datenbus* genannt.

 Schematisch dargestellt sieht dies so aus:

#align(center)[#image("images/datenadressbus.png")]

Mit einem Adressbus der Breite $a$ - dabei bedeutet "Breite" letztendlich nur "Anzahl der Leitungen" kann man $2^a$ Adressen codieren bzw. ansprechen, da wir nur $2^a$ Binärzahlen so codieren können.

Die Breite des Datenbusses bestimmt die Anzahl an Bits, die pro Adresse abgerufen werden können, hier im Allgemeinen Fall also *d Bit* pro Adresse.

Man spricht hier auch von der *Architekturbreite*. (früher 8, 16, 32, heute meistens 64 Bit Architekturen üblich).

Um den Speicher vollständig adressieren zu können, muss er also innerhalb der Größe *$2^a dot d$* bleiben, da ansonsten nicht genug eindeutige Adressen existieren.

== Zeichencodierungen

Neben Zahlen müssen auch Buchstaben, Zeichen und anderes codiert werden. Der "Klassiker" dieser Codierungen ist die *ASCII-Tabelle* (American Standard Code for Information Interchange). Die ursprüngliche Tabelle sieht so aus:

#align(center)[#image("images/asciichart.png") \ Quelle: Wikipedia]

Beispielsweise hat der Buchstabe *e* die Nummer 101, also die Bitfolge $0110 0101$.

Jeder Code verwendet dabei nur 7 Bit pro Zeichen. D.h. mit dieser ursprünglichen Codierung können "nur" 128 verschiedene Zeichen codiert werden.

Das hat sich als nicht ausreichend herausgestellt. Heute gebräuchlicher ist der sogenannte #link("https://de.wikipedia.org/wiki/Unicode")[*Unicode*-Standard].

Hier werden $2^16 = 65.536$ pro Ebene codiert und es gibt insgesamt 18 Ebenen.

Jedes einzelne Zeichen wird also durch die Angabe der Ebene und eine 16 Bit lange Positionsangabe eindeutig beschreiben.

*Beispiel*: der Smiley mit Herzchen-Augen hat die Nummer 1f60d

Genaueres findet sich z.B. #link("http://www.unicode.org/charts/")[hier].



= Eine Registermaschine

Unser Buch listet als wesentliche Komponenten/Eigenschaften einer grundlegenden "Rechners" (was für uns der Prototyp einer Registermaschine ist):

1. Zentraleinheit(en) mit Steuer- und Rechenwerken (*ALU* - Arithmetic Logic Unit)
2. Speicherelemente (Speicherwerk)
3. Ein- bzw. Ausgabeeinheiten
4. Bus-Systeme zum Datentransport

Bis auf die Ein- und Ausgabeeinheiten also genau die Elemente, die zuvor schon in Grundzügen besprochen worden sind.

Diese wurde nach *von Neumann* benannt, der diese Definition auf Basis der Arbeit von Zuse festgelegt hat und heißt deswegen *Von-Neumann-Architektur*.

#align(center)[#image("images/vonneumann.png", width: 50%) \ Quelle: Wikipedia]


Ein etwas genauerer Überblick, der an die später verwendete Minimaschine angelehnt ist:

#align(center)[#image("images/schemaRegistermaschine.png")]

Die einzelnen Bestandteile werden im Folgenden noch genauer erläutert.

== ALU

Eine arithmetisch-logische-Einheit ist für die eigentliche Rechenarbeit zuständig. Sie hat in der Regel die folgenden Komponenten:
1. *Akkumulator*: Speichert temporär (!) Daten während der Rechenoperationen (es wird z.B. der Wert einer Speicherzelle auf den Wert des Akkumulators addiert und anschließend wieder im Akkumulator abgelegt).
2. *Datenregister*: Hierbei handelt es sich um weitere Speicherorte für Zwischenergebnisse und Werte, die nicht in den "normalen" Speicher geschrieben werden soll - insbesondere ist die Zugriffsgeschwindigkeit der ALU auf die Register sehr schnell. #hinweis(customTitle: "Für die Experten")[- Viele Architekturen erlauben den Rechenwerken nur die Manipulation der Daten in den Registern und *nicht* an anderen Speicherorten wie dem RAM.
- Ein einzelnes Register hat i.d.R. die Größe einer Zweierpotenz, d.h. 8 Bit, 16 Bit, usw. Das limitiert auch die Größe der Zahlen, mit denen wir unmittelbar rechnen können!
]
3. *Funktionseinheit - Befehlsregister*: Steuert die Art der Operationen, die die ALU ausführt.
4. *Statusregister (Flags)*: Liefert Informationen über das Ergebnis der durchgeführten Operation, indem sogenannte flags gesetzt werden. Diese können z.B. anzeigen, ob das Ergebnis null ist, nicht-negativ oder einen Überlauf anzeigen.
5. *Ergebnisregister*: Speichert das Endergebnis der Berechnung, bevor es wieder in den Akkumulator, andere Register (oder den Speicher!) geschoben werden.

== Speicherwerk
Das Speicherwerk wird von Von Neumann als gleich große, fortlaufend nummerierte Zellen eingeteilt. Jede Zelle speichert eine folge aus Bits (siehe DRAM oben). Wir werden uns auf 8-Bit Speicherzellen beschränken, dies entspricht also einem Byte (oder 2 Hex-Zahlen - wir werden sehen, dass in der Minimaschine die Inhalte der Speicherzellen wieder hexadezimal dargestellt werden).

#merke[In diesen Zellen werden sowohl die *Befehle* als auch die *Daten* eines Programms gespeichert. Dies ist ein offensichtliches Sicherheitsrisiko bzw. eine Problemquelle. Ein Programm kann sich beispielsweise aus Versehen "selbst löschen", indem es seinen Befehlsbereich mit Daten überschreibt.]

== Ein- bzw. Ausgabeeinheiten

Der am wenigsten mysteriöse Teil der Architektur. Hier sind die typischen Eingabegeräte wie Tastaturen, Mäuse, etc. gemeint. Auf der Ausgabeseite stehen z.B. Monitore, Drucker oder Lautsprecher.

== Bus-Systeme

Der bereits mehrfach verwendete Begriff *Bus* steht für eine physikalische Verbindung zwischen verschiedenen Komponenten, z.B. Kabel oder Lichtwellenleiter. Diese Verbindungen transportieren die Signale in Form elektromagnetischen Impulsen. Die verschiedenen Kabel werden dann gedanklich nach ihren Aufgaben getrennt. So ergeben sich die bereits erwähnten:
1. *Datenbusse*, die die eigentlichen "Daten" hin und herschieben.
2. *Steuerbusse*, die die Kommunikation zwischen den einzelnen Werken steuern.
3. *Adressbusse*, die zur Übermittlung des Speicherorts für Daten oder Befehle verwendet werden.

#hinweis[Auch hier spielen die Begriffe *parallel* und *seriell* wieder eine Rolle.
1. Ein *paralleler* Bus besteht aus mehreren Einzelleitungen, über die mehrere Signale gleichzeitig übertragen werden können, z.B. der Adressbus.
2. Ein *serieller* Bus überträgt die Informationen als Folge einzelner aufeinander folgender Signale. Der universelle serielle Bus (USB) ist der Standard für die Kommunikation mit externen Geräten.]

== Zusammenfassung

Eine Registermaschine besteht aus einem Arbeitsspeicher für die Programme, sowie einer Reihe von Registern und (mindestens) einer ALU. Wir verwenden im folgenden die folgenden Register:
1. *Befehlszähler BZ*: enthält die Speicheradresse des nächsten zu bearbeitenden Befehl.
2. *Statusregister SR*: enthält die Informationen über das Ergebnis der letzten Operation.
3. *Datenregister A, R1, R2,...*: dienen zur Ablagen der Daten. Das Datenregister Akkumulator *A* enthält dabei im speziellen den Eingabewert für den folgenden Rechenbefehl.

= Programmierung mit der Minimaschine

Zur Programmierung von Registermaschinen werden *Assembler-Programme* verwendet. Hierbei handelt es sich um Programmiersprachen, die nur die elementaren, maschinennahen Befehle enthalten. Dazu gehören in der Regel:

1. *Transportbefehle* zum Laden der Datenregister, z.B. _LOAD_ oder _STORE_.
2. *artihmetische Befehle* zur Ausführung von Rechnungen, z.B: _ADD_, _SUB_, _MUL_, etc.
3. *Sprungbefehle*, die zu einer bestimmten "Marke" im Code springen können, z.B. _JMP_.
4. *logische Verknüpfungen*: _AND_, _OR_, etc.
5. *END*, damit wir auch aufhören können.

Im Folgenden werden wir diese Befehle nach und nach genauer betrachten und damit die sogenannte *Minimaschine* programmieren (die Simulation einer Registermaschine durch Java).

== Aufbau und Verwendung Minimaschine

Startet man die Minimaschine, so sieht diese sehr ähnlich aus, wie die obige Veranschaulichung der Von-Neumann-Architektur:

#align(center)[#image("images/minimaschine.png")]

Zusätzlich kann auch der Speicher direkt betrachtet werden, bevor ein Programm geladen wurde steht in jeder Speicherzelle eine $0$:

#align(center)[#image("images/ram.png")]

Bisher passiert noch nicht viel, es muss erst ein Programm geschrieben werden! Dies kann unter "Ablage" -> "Neu" oder "Öffnen" in einem weiteren Fenster geschrieben werden.

Hat man sein Programm geschrieben kann man unter "Werkzeuge" -> "assemblieren" das Programm in den Minimaschinen-Speicher laden.
#align(center)[#image("images/assemblieren.png", width:50%)]

Danach kann mit den Schaltflächen "Ausführen", "Einzelschritt" oder "Mikroschritt" in der CPU-Kontrolle das Programm ausgeführt werden, je nach gewünschter Feingranularität.

#hinweis[Nach der vollständigen Ausführung des Programms, kann es nicht sofort neu gestartet werden - zunächst muss die Maschine in ihren Anfangszustand zurückversetzt werden unter "Werkzeuge" -> "CPU rücksetzen" im Fenster "CPU-Kontrolle".]

#task[Machen Sie sich mit den verschiedenen Fenstern vertraut und öffnen Sie das bereitgestellte Programm "example.mia".

Laden Sie das Programm in die Minimaschine und testen Sie die verschiedenen Ausführungsmodi. Geben Sie an, was das Ziel des Programms ist]

An dieser Stelle bietet es sich an einige Einstellungsmöglichkeiten des Speichers ebenfalls zu testen, unter Werkzeuge finden sich die folgenden Optionen:

1. *Große Darstellung*: für kleine Programme sehr zu empfehlen
2. *Speicher löschen*: um sicherzustellen, dass keine Programmreste enthalten sind, bevor ein neues Programm assembliert wird.
3. *Darstellung hexadezimal*: selbsterklärend
4. *Opcodes anzeigen*: hier wird auch im Speicher die Art des Befehls statt der korrespondierenden Zahl angegeben, Details dazu im nächsten Kapitel.
5. *Speicher editieren*: So könnte man vor der Ausführung noch im Speicher Änderungen einpflegen, wird von uns selten genutzt.

#align(center)[#image("images/mmspeicher2.png")]

== Aufbau von Maschinenbefehlen und Befehlszyklus

Bevor wir konkret mit dem Schreiben von Programmen beginnen muss der *Befehlszyklus* der Minimaschine analysiert werden, also die Abfolge in der Dinge ausgeführt werden, außerdem benötigen wir einen Grundstock von konkreten Befehlen, mit denen wir arbeiten können.

Ein einzelner Befehl besteht aus einem *OP-Code* und den *OP-Daten*, also aus einem bestimmten *Operator* und den zugehörigen *Operanden*, also den "Argumenten" dieses Befehls.

In der Sprache, die der Minimaschine zugrunde gilt z.B.:
- *276* entspricht dem LOAD-Befehl (also laden)
- *277* ist der Code für den STORE-Befehl (speichern)
- *266* für ADD, also die Addition, usw.

#merke[In einem Minimaschinenprogramm kann eine Zahl, z.B. 15 für die Nummer einer *Speicherzelle* stehen, oder für die *Zahl* direkt, das kommt auf den entsprechenden Befehl an. Das heißt der gleiche Operand wird von unterschiedlichen Befehlen auch unterschiedlich interpretiert, z.B.:
- *LOAD 15* wird den Wert der in *Speicherzelle 15* steht in den Akkumulator (in der Minimaschine oben links dargestellt) laden.
- *LOADI 23* dagegen wird die *Zahl* 23 in den Akkumulator laden, von vielen Befehlen gibt es auch eine "*I-Variante*"

Die Verwechselung der beiden Befehle ist eine der größten Fehlerquellen, auch im Abitur.
]

Die Ausführung eines Befehls beginnt immer in der nullten Speicherzelle des Arbeitsspeichers und es beginnt der *Zyklus*, der sich in die folgenden Phasen gliedert.

1. *Befehlsabruf (Fetch-Phase)*: Die ALU ruft den nächsten Befehl aus dem Speicher ab, die Adresse dieses nächsten Befehls findet sich im Befehlszähler (*Instruction Pointer*), dieser wird danach außerdem inkrementiert.
2. *Befehlsdekodierung (Decode-Phase)*: Das Steuerwerk dekodiert den Befehl, wird also in eine für die ALU verständliche Form umgewandelt. Es wird sowohl der Befehlstyp als auch die Operanden entschlüsselt.
3. *Befehlsausführung (Execute-Phase)*: Der dekodierte Befehl wird vom Rechenwerk ausgeführt. In dieser Phase werden auch die verschiedenen Statusflags (in der Minimaschine links unten) gesetzt.
4. *Speicherzugriff (Memory-Access-Phase)*: Erfordert der Befehl einen Speicherzugriff, so werden die Daten in dieser Phase geladen.
5. *Ergebnisrückgabe und Weiterleitung (Write Back/Result-Phase)*: Bei den meisten Befehlen wird das Ergebnis an einen bestimmten Speicherort, z.B. Register oder Speicher geschrieben.


== Befehlssatz

Wir beginnen mit einem kleinen Befehlssatz und beschränken uns zunächst auf *Speicherbefehle* und *Arithmetikbefehle*:

#tablex(rows:13, columns:(12%,12%,76%),
colspanx(3)[*Speicherbefehle*],
[*LOAD*], [Adresse], [Lädt den Wert von der angegebenen Adresse in den Akkumulator],
[*LOADI*], [Zahl], [Lädt die angegebene Zahl in den Akkumulator],
[*STORE*], [Adresse], [Lädt den Wert von der angegebenen Adresse in den Akkumulator],
colspanx(3)[*Arithmetikbefehle*],
[*ADD*], [Adresse], [Addiert den Wert der angegebenen Adresse zum Akkumulator.],
[*SUB*], [Adresse], [Addiert den Wert der angegebenen Adresse zum Akkumulator.],
[*MUL*], [Adresse], [Multipliziert den Wert der angegebenen Adresse zum Akkumulator.],
[*DIV*], [Adresse], [Dividiert den Wert der angegebenen Adresse zum Akkumulator.],
[*ADDI*], [Zahl], [Addiert die angegebene Zahl zum Akkumulator.
],
[*SUBI*], [Zahl], [Subtrahiert die angegebene Zahl zum Akkumulator.
],
[*MULI*], [Zahl], [Multipliziert die angegebene Zahl zum Akkumulator.
],
[*DIVI*], [Zahl], [Dividiert die angegebene Zahl zum Akkumulator.
],
)

#pagebreak()
== Das erste Programm

Mit Hilfe dieses Wissens analysieren wir nun das obige Programm:

#sc[```yasm
LOADI 25
STORE 100
LOADI 35
STORE 101
LOAD 100
ADD 101
STORE 102
HOLD
```]

Zeilenweise gelesen:
1. Lade die *Zahl* 25 in den Akkumulator
2. Speichere die Zahl im Akkumulator in der Speicherzelle mit *Adresse* 100
3.Lade die *Zahl* 35 in den Akkumulator
4. Speichere die Zahl im Akkumulator in der Speicherzelle mit *Adresse* 101
5. Lade die Zahl aus der Speicherzelle 100 in den Akkumulator
6. Addiere die Zahl in der Speicherzelle 101 zur Zahl im Akkumulator
7. Speichere die Zahl im Akkumulator in der Speicherzelle 102
8. Die Maschine hält an und beendet ihre Berechnung (ansonsten produzieren wir bei einem weiteren Schritt ggf. einen Fehler und die Maschine endet in einem Fehlerzustand)

Letztendlich werden also nur die beiden Zahlen 25 und 35 addiert und das Ergebnis in der Zelle 102 gespeichert!

#merke[Hier zeigt sich wieder ein großes Problem: wir könnten statt "STORE 100" in Zeile 2 natürlich auch z.B. "STORE 4" schreiben. Dadurch überschreiben wir aber unser eigenes Programm! Wenn die Zahl nicht selbst ein valider OP-Code ist stürzt das Programm an dieser Stelle ab.]
#align(center)[#image("images/mmerror.png")]

== Weitere Beispiele

=== Mittelwert zweier Zahlen

#task(customTitle: "Aufgaben")[1. Schreiben Sie ein Programm, das zwei Zahlen in den Speicherzellen 100 und  101 speichert und anschließend den Mittelwert dieser zwei Zahlen in der Speicherzelle 102 ablegt.

2. Erweitern Sie das Programm, sodass es den Mittelwert von drei Zahlen berechnet.]

#hinweis[Gehen Sie davon aus, dass der Mittelwert eine ganze Zahl ergibt.]

Die Lösung findet sich auf der nächsten Seite


#pagebreak()

Für das erste Programm benötigen wir zusätzlich zum bisher betrachteten nur den DIVI-Befehl, um durch die Anzahl, sprich hier 2 teilen zu können.

#sc[```yasm
LOADI 50
STORE 100
LOADI 40
STORE 101
LOAD 100
ADD 101
DIVI 2
STORE 102
HOLD
```]

Für unsere Minimaschine sind auch Kommentare möglich mit vorangestelltem *\#*:

#sc[```yasm
#Daten laden
LOADI	3
STORE	100
LOADI	5
STORE	101
LOADI	2
STORE	102

#MW berechnen
LOAD	100
ADD	101
ADD	102
DIVI	3
STORE	103
HOLD
```]

Insbesondere wenn wir mit vielen Eingaben arbeiten ist es natürlich lästig, am Anfang alle Zahlen immer zu laden und in Zellen abzulegen. Glücklicherweise gibt es auch eine "Abkürzung", man kann sogenannte *Bezeichner* verwenden, das sähe hier z.B. so aus:

#sc[```yasm
#Programm:
LOAD	Z1
ADD	    Z2
ADD 	Z3
DIVI	3
STORE	R
HOLD

#Daten:
Z1:	WORD	3
Z2:	WORD	5
Z3:	WORD	2
R:
```]

Im eigentlichen Programm wurden die *absoluten Adresse* durch die Label bzw. Bezeichner ersetzt. Diese Daten werden nach dem eigentlichen Programm definiert - die Bezeichner sind dabei frei wählbar.


Die Definition der Label bewirkt, dass die durch den *WORD*-Befehl erzeugten Werte nach dem Assemblieren in den Speicherzellen direkt hinter dem Programm abgelegt werden. Das Label *R* für "result" erhält keinen Wert, reserviert aber die Stelle an der dann am Ende das Ergebnis abgelegt wird.

Man muss sich also keine Gedanken mehr über passende Adressbereiche im Speicher machen und überlasst die Organisation des Speichers dem Betriebssystem.

#hinweis[Leider ist es nicht unüblich, dass im schriftlichen Abitur die Verwendung von *absoluten* Speicheradressen explizit verlangt wird. Dann müsste hier die erste Variante dieses Programms als Lösung angegeben werden.]

=== Berechnung der Halbjahresleistung

#task[Schreiben Sie ein Programm, dass die Halbjahresleistung in einem Fach in der Oberstufe berechnet, gehen Sie dabei von den folgenden noten aus:
- Ein kleiner Leistungsnachweis
- Eine mündliche Note
- Eine Abfrage
- Eine Klausur

Gehen Sie dabei zuerst "naiv" vor und versuchen Sie anschließend das auftretende Problem zu lösen.
]

Die naive Lösung könnte z.B. so aussehen:

#sc[```yasm
#Programm:
LOAD    UB
ADD	    KA
ADD	    RA
DIVI    3
ADD	    KL
DIVI    2
STORE   R
HOLD

#Daten:
KL:	WORD	9
UB:	WORD	13
KA:	WORD	9
RA:	WORD	10
R:	WORD	0

```]

Berechnet man auf diese Art einen nicht-ganzzahligen Schnitt, so wird die Nachkommastelle durch Verwendung von DIVI abgeschnitten. Liegt der Wert also in einem Bereich, in dem eigentlich aufgerundet wird, wird ein falsches Ergebnis angegeben. Grundsätzlich müsste also bei Werten wie $ 10\,5$ oder $6\,83$ oder $4,74$ aufgerundet werden.


Wir haben keine direkte Möglichkeit mit Dezimalzahlen zu rechnen, deswegen brauchen wir eine andere Lösung.

Eine naheliegende Überlegung wäre, einfach zu allen Werten einfach $0,5$ zu addieren, denn dann würden alle Werte im Abrundungsbereich weiterhin zum korrekten Bereich hin abgeschnitten, die Werte im Aufrundungsbereich aber werden über die nächste Ganzzahl geschoben.

Das funktioniert aber auch nicht so leicht! Denn wir können $0,5$ nicht addieren, wohl aber 5! D.h. wir können die gesamte Rechnung vorher mit den um Faktor $10$ skalierten Werten durchführen, dann $5$ addieren und danach wieder zurücksskalieren.

*Beispiel*: kleiner Leistungsnachweis: $9$, Abfrage: $13$, Unterrichtsbeitrag: $10$, Klausur: $9$

$ (9 + 13 + 10)/3 = 32/3 #h(1cm) (32/3 + 9) : 2 approx 9,83 $

Würde abgeschnitten werden! Mit der modifizierten Rechnung:

$ ((9 + 13 + 10)*10)/3 = 320/3 #h(1cm)  (320/3 + 90) : 2 + 5 approx 103,33 $

Teilen wir dieses Ergebnis mit DIVI 10, so erhalten wir die gewünschten 10.

Umgesetzt in ein Programm ergibt sich:

#sc[```yasm
#Programm:
LOAD  UB
ADD	  KA
ADD	  RA
MULI	10
DIVI	3
STORE	temp
LOAD	KL
MULI	10
ADD   temp
DIVI	2
ADDI	5
DIVI	10
STORE	R
HOLD

#Daten:
KL:	    WORD	9
UB:	    WORD	12
KA:	    WORD	9
RA:	    WORD	13
temp:	  WORD	0
R:	    WORD	0

```]

=== Division mit Rest

Wenn wir schon keine Dezimalzahlen haben, können wir wenigstens wie in der Grundschule rechnen!

#task[Schreiben Sie ein Programm, dass für eine gegebenen Division sowohl den Ganzzahlanteil, als auch das Ergebnis ausgibt!]

Eine mögliche Lösung sieht wie folgt aus:

#sc[```yasm
#Programm:
LOAD 	Dividend
DIV 	Divisor
STORE 	Ergebnis

MUL 	Divisor
STORE 	Rest
LOAD 	Dividend
SUB 	Rest
STORE 	Rest
HOLD

#Daten:
Dividend:	WORD	23
Divisor:	WORD	6
Ergebnis:	WORD	0
Rest:	WORD	0


```]

== Erweiterung des Befehlssatzes

Nach diesen ersten einfachen Programmen erweitern wir den Befehlssatz zunächst um einige weitere Arithmetikbefehle:


#tablex(rows:5, columns:(12%,12%,76%),
colspanx(3)[*Arithmetik-Befehle*],
[*MOD*], [Adresse], [Dividiert den Wert im Akkumulator durch den Wert der angegebenen Adresse und speichert den Rest im Akkumulator.
],
[*CMP*], [Adresse], [Vergleicht den Wert der angegebenen Adresse mit dem Wert im Akkumulator, wie bei der Subtraktion "akku - adresswert" und setzt die Flags. *Im Unterschied zu SUB wird der Wert im Akkumulator nicht geändert*],
[*MODI*], [Adresse], [Dividiert den Wert im Akkumulator durch die angegebene Zahl und speichert den Rest im Akkumulator.
],
[*CMPI*], [Adresse], [Vergleicht den Wert der angegebenen Adresse mit dem Wert im Akkumulator, wie bei der Subtraktion "akku - adresswert" und setzt die Flags.],
)

Damit wären natürlich einige der Aufgaben oben einfacher gewesen :)

Wesentlich interessanter ist eine weitere Art von Befehlen, die *Sprung-Befehle*.

Mit ihnen können wir zu einer bestimmten Anweisung springen, z.B. bedeutet *JMP 6*: In der Execute-Phase wird der Befehlszähler auf 6 gesetzt (statt wie üblich inkrementiert zu werden). Wir setzen die Ausführung des Programms also mit dem Befehl in der Speicherzelle 6 fort.

Dieser Sprung-Befehl lässt sich auch mit den oben erwähnten Flags kombinieren: es gibt Befehle, die nur dann springen, falls z.B. das negative-Flag gesetzt ist, eine Übersicht:

#tablex(rows:14, columns:(12%,28%,60%),
colspanx(3)[*Die relevanten Flags*],
[*N*], [Negative-Flag], [Wird gesetzt, wenn der Wert im Akkumulator negativ ist.],
[*Z*], [Zero-Flag], [Wird gesetzt, wenn der Wert im Akkumulator Null ist.],
[*V*], [Overflow-Flag], [Wird gesetzt, , wenn es bei der vorhergehenden Operation einen Overflow gab, das Ergebnis also den Zahlenbereich überschritten hat. Im Akkumulator steht somit nicht das mathematisch korrekte Ergebnis],
[*CMPI*], [Adresse], [Vergleicht den Wert der angegebenen Adresse mit dem Wert im Akkumulator, wie bei der Subtraktion "akku - adresswert" und setzt die Flags.],
colspanx(3)[*Sprungbefehle*],
[*JMP*], [Adresse], [Setzt den Befehlszähler auf die angegebene Adresse, das Programm wird somit mit dem nächsten Befehlszyklus dort fortgesetzt.
],
[*JMPN*], [Adresse], [Springt, falls das Negative-Flag gesetzt ist (Jump Negative).],
[*JMPZ*], [Adresse], [Springt, falls das Zero-Flag gesetzt ist (Jump Zero).],
[*JMPP*], [Adresse], [Springt, falls weder das Zero- noch das Negative-Flag gesetzt ist (Jump Positive).],
)
