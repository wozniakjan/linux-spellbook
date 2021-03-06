<!--

Linux Kniha kouzel, kapitola Zpracování textových souborů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Chybí ukázka.
[ ] Nepokrývá formát CSV.
[ ] Nedobré pokrytí formátu PSV.

⊨
-->

# Zpracování textových souborů

!Štítky: {tematický okruh}{zpracování textu}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá nástroji pro řazení, filtrování a záplatování textových souborů. Nezabývá se podrobně komplexními nástroji jako GNU awk, sed či Perl,
přestože jsou v některých zaklínadlech použity.

Tato verze kapitoly nepokrývá zpracování formátu CSV. Formát PSV (záznamy v odstavcích) je pokryt nedostatečně.

Tato kapitola se nezabývá zpracováním textových formátů se složitější strukturou jako např. JSON či XML.

## Definice

* **Kódování znaků** je určitá reprezentace znakové sady textu pomocí bajtů a jejich sekvencí v souboru či paměti. U textových souborů uvažujeme výhradně kódování UTF-8, případně ASCII (které je podmnožinou UTF-8). Soubory v jiných kódováních sice také můžeme zpracovávat, ale obvykle je výhodnější je nejprve převést na UTF-8.
* **Znak** (character) je základní jednotka textu, které je kódováním znaků přiřazen nějaký význam a reprezentace. Např. „A“ je v UTF-8 znak, který znamená písmeno A a je reprezentován bajtem o hodnotě 65. „\\n“ je v UTF-8 znak, který znamená konec řádku a je reprezentován bajtem o hodnotě 10.
* **Řetězec** (string) je libovolná posloupnost znaků, i prázdná či tvořená jedním znakem.
* **Záznam** je zobecnění pojmu „řádek“ v textovém souboru. Textový soubor se dělí na jednotlivé záznamy podle jejich zakončení **ukončovačem záznamu** (record separator), což je typicky znak konce řádku „\\n“ nebo nulový bajt „\\0“. Záznamy se číslují od 1.
* Záznam může být brán jako celek, nebo může být dál rozdělen na **sloupce** (fields). Existuje několik metod dělení záznamu na sloupce, nejčastější je použití určitého znaku ASCII jako „oddělovače sloupců“ (field separator). Sloupce se v každém záznamu číslují od 1.
* **Odstavec** je posloupnost záznamů v souboru ukončená více než jedním ukončovačem záznamu (tzn. v praxi typicky jedním či více prázdnými řádky).
* **Záplata** je speciální textový soubor, který obsahuje záznam o změnách mezi dvěma verzemi jednoho nebo více textových souborů. Využití záplat je v dnešní době zřídkavé.

V této kapitole rozlišuji následující formáty textových souborů:

* TXT − záznamy ukončeny „\\n“, na sloupce se nedělí.
* TXTZ − záznamy ukončeny „\\0“, na sloupce se nedělí.
* TSV − záznamy ukončeny „\\n“, sloupce se dělí tabulátorem („\\t“) nebo jiným znakem ASCII (např. v /etc/passwd se dělí znakem „:“).
* TSVZ − záznamy ukončeny „\\0“, sloupce se oddělují tabulátorem („\\t“) nebo jiným znakem ASCII.
* PSV − komplikovaný textový formát s pojmenovanými sloupci; záznamy jsou ukončeny sekvencemi více než jednoho znaku „\\n“; sloupce jsou pojmenovány.
* pevná šířka sloupců − záznamy ukončeny „\\n“, sloupce (kromě posledního) jsou zarovnány na pevný počet znaků pomocí mezer.

!ÚzkýRežim: vyp

## Zaklínadla (txt, txtz)

**Důležitá poznámka pro všechna zaklínadla v této sekci:** Kde je v zaklínadle volitelný parametr „z“ (resp. „-z“), tento parametr funguje jako přepínač mezi formáty txt a txtz. Při použití formátu txt tento přepínač vynechejte, při použití txtz ho naopak vždy zařaďte.

### Vytvoření a smazání

*# vytvořit **prázdný soubor** (existuje-li, vyprázdnit)*<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...

*# vytvořit prázdný soubor (existuje-li, jen aktualizovat čas „změněno“)*<br>
**touch** {*soubor*}...

<!--
*# **smazat** soubor*<br>
**rm** [**-f**] <nic>[**-v**] {*soubor*}...
-->

*# N-krát zopakovat určitý záznam (txt/txtz)*<br>
*// Výchozí hodnota textu záznamu je „y“.*<br>
**yes** [[**\-\-**] {*text-záznamu*}] **\| head -n** {*N*}<br>
**printf %s\\0 $'**{*text-záznamu*}**' \| sed -z ':x;p;b&blank;x' \| head -zn** {*N*}

### Filtrace záznamů podle pořadí

*# vzít/vynechat N **prvních***<br>
**head -**[**z**]**n** {*N*} [{*soubor*}]...<br>
**tail -**[**z**]**n +**{*N+1*} [{*soubor*}]...

*# vzít/vynechat N **posledních***<br>
**tail -**[**z**]**n** {*N*} [{*soubor*}]...<br>
**head -**[**z**]**n -**{*N*} [{*soubor*}]...

*# vzít/vynechat **konkrétní** záznam*<br>
**sed -**[**z**]**n** {*číslo-záznamu*}**p** [{*soubor*}]...<br>
**sed** [**-z**] {*číslo-záznamu*}**d** [{*soubor*}]...

*# vzít/vynechat **rozsah** záznamů*<br>
**sed -**[**z**]**n** {*první-ponechaný*}**,**{*poslední-ponechaný*}**p** [{*soubor*}]...
**sed** [**-z**] {*první-vynechaný*}**,**{*poslední-vynechaný*}**d** [{*soubor*}]

*# vzít pouze **liché/sudé** záznamy*<br>
**sed -**[**z**]**n $'p\\nn'** [{*soubor*}]...<br>
**sed -**[**z**]**n $'n\\np'** [{*soubor*}]...

### Filtrace záznamů podle obsahu

*# vzít/vynechat záznamy odpovídající **regulárnímu výrazu***<br>
**egrep** [**-z**] <nic>[**-x**] <nic>[{*parametry*}] {*regulární-výraz*} [{*soubor*}]...<br>
**egrep** [**-z**] **-v** [**-x**] <nic>[{*parametry*}] {*regulární-výraz*} [{*soubor*}]...

*# vzít/vynechat záznamy obsahující **podřetězec***<br>
*// Poznámka: V hledaném podřetězci se nesmí vyskytovat znak \\n, a to ani u formátu txtz, protože fgrep tento znak používá k oddělení více různých hledaných podřetězců. Pokud váš podřetězec tento znak obsahuje, existuje několik řešení, nejjednodušším je pomocí příkazu „tr“ na vstupu i výstupu příkazu fgrep prohodit znak \\n s jiným ASCII znakem, který se v hledaném podřetězci nevyskytuje.*<br>
**fgrep** [**-z**] **'**{*podřetězec*}**'** [{*soubor*}]...<br>
**fgrep** [**-z**] **-v '**{*podřetězec*}**'** [{*soubor*}]...

*# vzít/vynechat záznamy shodné s **řetězcem***<br>
**fgrep -**[**z**]**x '**{*řetězec*}**'** [{*soubor*}]...<br>
**fgrep -**[**z**]**xv '**{*řetězec*}**'** [{*soubor*}]...

*# vzít/vynechat záznamy od prvního vyhovění regulárnímu výrazu*<br>
**sed -**[**z**]**En '/**{*regulární výraz*}**/,$p'** [{*soubor*}]...<br>
**sed -**[**z**]**E '/**{*regulární výraz*}**/,$d'** [{*soubor*}]...

<!--
Příliš složité:

*# vzít záznamy v každém rozsahu definovaném regulárními výrazy (txt/txtz)*<br>
**sed -En '/**{*reg. výraz první zázn.*}**/,/**{*reg. výraz posl. zázn.*}**/p'** [{*soubor*}]...<br>
**sed -zEn '/**{*reg. výraz první zázn.*}**/,/**{*reg. výraz posl. zázn.*}**/p'** [{*soubor*}]...

*# vynechat záznamy v každém rozsahu definovaném regulárním výrazy (txt/txtz)*<br>
**sed -E '/**{*reg. výraz první vynechaný*}**/,/**{*reg. výraz posl. vynechaný*}**/d'** [{*soubor*}]...<br>
**sed -zE '/**{*reg. výraz první vynechaný*}**/,/**{*reg. výraz posl. vynechaný*}**/d'** [{*soubor*}]...
-->

<!--
Hledání souborů podle obsahu:

egrep -Lr {*regulární-výraz*} {*soubor-či adresář*}...

-->

### Filtrace záznamů podle počtu výskytů

*# vybrat ty, které se vysktují **pouze jednou***<br>
**LC\_ALL=C sort** [**-z**] <nic>[{*soubor*}]... **\| uniq -**[**z**]**u**

*# vybrat ty, které se vyskytují více než jednou (**duplicity**); vypsat jeden na skupinu/všechny*<br>
**LC\_ALL=C sort** [**-z**] <nic>[{*soubor*}]... **\| uniq -**[**z**]**d**<br>
**LC\_ALL=C sort** [**-z**] <nic>[{*soubor*}]... **\| uniq -**[**z**]**D**

*# vybrat ty, které se vyskytují N-krát*<br>
**LC\_ALL=C sort** [**-z**] <nic>[{*soubor*}]... **\| uniq -**[**z**]**c \| sed -**[**z**]**E 's/^\\s\***{*N*}**\\s//;t;d'**

*# seřadit a **vypsat počet výskytů** (především pro člověka)*<br>
**LC\_ALL=C sort** [**-z**] <nic>[{*soubor*}]... **\| uniq -**[**z**]**c \| sort -**[**z**]**n**[**r**]

### Řazení a přeskládání záznamů

*# **obrátit** pořadí (txt/txtz)*<br>
**tac** [{*soubor*}]...<br>
**tac -s \\\\0** [{*soubor*}]...

*# **náhodně** přeskládat*<br>
**shuf** [**-z**] <nic>[{*soubor*}]

*# **seřadit***<br>
[**LC\_ALL=C**] **sort** [**-z**] <nic>[{*parametry*}] <nic>[{*soubor*}]...

*# seřadit a **vyloučit duplicity***<br>
[**LC\_ALL=C**] **sort -**[**z**]**u** <nic>[{*soubor*}]...

*# seskupit k sobě shodné záznamy a tyto skupiny náhodně přeskládat*<br>
**sort -**[**z**]**R** [{*soubor*}]...

*# seřadit, s výjimkou prvních N záznamů*<br>
[**cat** {*soubor*}... **\|**] **(sed -**[**z**]**u** {*N*}**q;** [**LC\_ALL=C**] **sort** [**-z**] <nic>[{*parametry*}]**)**

### Množinové operace (nad seřazenými záznamy)

*# **předzpracování** textového souboru pro množinové operace (vyžadované!)*<br>
**LC\_ALL=C sort -**[**z**]**u** [{*soubor*}]

*# množinové sjednocení (**or**)*<br>
**LC\_ALL=C sort -**[**z**]**mu** {*první-soubor*} {*další-soubor*}...

*# množinový průnik dvou souborů (**and**)*<br>
**LC\_ALL=C join** [**-z**] **-t "" -j 1** {*první-soubor*} {*druhý-soubor*}

*# množinový rozdíl dvou souborů (**and not**)*<br>
**LC\_ALL=C join** [**-z**] **-t "" -j 1 -v 1** {*hlavní-soubor*} {*odečítaný-soubor*}

*# exkluzivní sjednocení dvou souborů (**xor**)*<br>
**LC\_ALL=C join** [**-z**] **-t "" -j 1 -v 1 -v 2** {*soubor1*} {*soubor2*}

*# množinový průnik více souborů (and)*<br>
*// Tip: nejlepšího výkonu této varianty dosáhnete tak, že začnete od nejmenšího vstupního souboru.*<br>
**cat** {*první-soubor*} [**\| LC\_ALL=C join** [**-z**] **-t "" -j 1 -** {*další-soubor*}]...

### Konverze kódování znaků a ukončení řádky

*# konvertovat soubor **do/z** UTF-8*<br>
*// Užitečná kódování: ISO8859-2, WINDOWS-1250, UTF-16, UTF-16BE, UTF-16LE, UTF-8, CP852 (MS-DOS), MAC-CENTRALEUROPE.*<br>
**iconv -f "**{*vstupní kódování*}**" -t UTF-8** [**-o "**{*výstupní-soubor*}**"**] <nic>[{*vstupní-soubor*}]...<br>
**iconv -f UTF-8 -t "**{*cílové kódování*}[**//IGNORE**]**"** [**-o "**{*výstupní-soubor*}**"**] <nic>[{*vstupní-soubor*}]...

*# konvertovat soubor do ASCII s transliterací*<br>
*// Poznámka: tato konverze je ztrátová, a tudíž prakticky jednosměrná.*<br>
**iconv -f "**{*vstupní kodování*}**" -t "ASCII//TRANSLIT"** [**-o "**{*výstupní-soubor*}**"**] <nic>[{*vstupní-soubor*}]...

*# vypsat úplný seznam podporovaných kódování*<br>
**iconv -l \| sed -E 's!/\*$!!'**

*# konverze ukončení řádku: Windows na Linux (\\r\\n na \\n)*<br>
**tr -d \\\\r &lt;**{*vstupní-soubor*} **&gt;**{*výstupní-soubor*}

*# konverze ukončení řádky: Linux na Windows (\\n na \\r\\n)*<br>
**sed -E 's/\\r\*$/\\r/'**

*# konverze ukončení řádku: Mac OS na Linux (\\r na \\n)*<br>
**tr \\\\r \\\\n &lt;**{*vstupní-soubor*} **&gt;**{*výstupní-soubor*}

*# konverze ukončení řádky: Linux na Mac OS (\\n na \\r)*<br>
**tr \\\\n \\\\r &lt;**{*vstupní-soubor*} **&gt;**{*výstupní-soubor*}

*# pokusit se zjistit kódování textu*<br>
?

### Ostatní

*# **počet záznamů** (txt/txtz)*<br>
**wc -l &lt;** {*soubor*}<br>
**tr -cd \\\\0 &lt;** {*soubor*} **\| wc -c**

*# maximální **délka záznamu** (txt/txtz)*<br>
**tr '\\t' x &lt;** {*soubor*} **\| wc -L**<br>
**tr '\\0\\n\\t' '\\nxx' &lt;** {*soubor*} **\| wc -L**

*# **spojit** soubory za sebe*<br>
*// Standardní vstup můžete mezi soubory vřadit parametrem „-“ místo názvu souboru. Neprázdné soubory musejí být řádně ukončeny ukončovačem záznamu, jinak se poslední záznam spojí s prvním záznamem následujícího souboru.*<br>
**cat** {*soubor*}...

*# **rozdělit** soubor na díly s uvedeným maximálním počtem záznamů (txt/txtz/příklad)*<br>
*// Přípona výstupních souborů nesmí obsahovat oddělovač adresářů „/“. Číslování výstupních souborů začíná od nuly; jinou hodnotu lze nastavit, když místo parametru -d použijete parametr \-\-numeric-suffixes=číslo. Uvedený příklad rozdělí soubor „vse.txt“ po sto řádcích na soubory „rozdelene-zaznamy/s00000dil.txt“, „rozdelene-zaznamy/s00001dil.txt“ atd.*<br>
**split -d -a** {*počet-číslic*} **-l** {*maximální-počet-záznamů*} <nic>[**\-\-additional-suffix='**{*přípona výstupních souborů*}**'**] {*vstupní-soubor*} **"**{*předpona výstupních souborů*}**"**<br>
**split -d -a** {*počet-číslic*} **-l** {*maximální-počet-záznamů*} **-t \\\\0** [**\-\-additional-suffix='**{*přípona výstupních souborů*}**'**] {*vstupní-soubor*} **"**{*předpona výstupních souborů*}**"**<br>
**split -d -a 5 -l 100 \-\-additional-suffix='dil.txt' vse.txt "rozdelene-zaznamy/s"**

*# zapisovat na standardní výstup a současně do souborů*<br>
[{*zdroj vstupu*} **\|**] **tee** [**-a**] {*výstupní-soubor*}...

*# **konvertovat** malá písmena na velká (obecně/příklad)*<br>
**sed -E 's/(.\*)/\\U\\1/'** [{*vstupní-soubor*}]...<br>
**printf "Žluťoučký kůň\\n" \| sed -E's/(.\*)/\\U\\1/'** ⊨ ŽLUŤOUČKÝ KŮŇ

*# konvertovat velká písmena na malá (obecně/příklad)*<br>
**sed -E 's/(.\*)/\\L\\1/'** [{*vstupní-soubor*}]...<br>
**printf "Žluťoučký kůň\\n" \| sed -E's/(.\*)/\\L\\1/'** ⊨ žluťoučký kůň

*# konvertovat malá písmena na velká a naopak*<br>
**sed -E 's/(.)/0\\1/g;s/0([[:lower:]])/1\\U\\1/g;s/0([[:upper:]])/1\\L\\1/g;s/[01]<nic>(.)/\\1/g** [{*vstupní-soubor*}]...

*# obrátit **pořadí znaků** v každém záznamu (txt/txtz)*<br>
**rev** [{*soubor*}]...<br>
?

*# ke každému záznamu přidat **předponu/příponu***<br>
*// Příkaz „sed“ vyžaduje v příponě i předponě další úroveň odzvláštnění znaků „\\“ a „\\n“. Proto v uvedeném případě zadávejte zpětné lomítko jako „\\\\\\\\“ a konec řádku jako „\\\\\\n“. Konec řádku se navíc může vyskytnout pouze při použití formátu txtz, u formátu txt pravděpodobně nebude fungovat správně.*<br>
**sed** [**-z**] **$'i\\\\\\n**{*předpona*}**'** [{*soubor*}]... **\| paste** [**-z**] **-d "" - -**<br>
**sed** [**-z**] **$'a\\\\\\n**{*přípona*}**'** [{*soubor*}]... **\| paste** [**-z**] **-d "" - -**

*# ke každému záznamu přidat předponu i příponu (alternativy)*<br>
*// Uvedené varianty se liší požadavky na odzvláštnění v příponě: v první variantě sed požaduje dodatečné odzvláštění znaků „\\“ a (případně) konce řádku; v druhé variantě požaduje sed odzvláštnění znaků „\\“, „/“ a „&amp;“.*<br>
**sed** [**-z**] **$'i\\\\\\n**{*předpona*}**\\np\\nc\\\\\\n**{*přípona*}**'** [{*soubor*}]... **\| paste** [**-z**] **-d "" - - -**<br>
**sed** [**-z**] **'s/.\*/**{*předpona*}**&amp;**{*přípona*}**/'**

*# přidat **číslo záznamu** pro člověka (txt/txtz)*<br>
**nl** [{*parametry*}] {*soubor*}...<br>
?

*# přeformátovat text do řádků určité šířky*<br>
*// Běžně se k tomu používá příkaz „fmt“, ale ten nerespektuje vícebajtové znaky, takže pro texty v UTF-8 funguje nekorektně.*<br>
?

## Zaklínadla (tsv, tsvz)

**Důležité poznámka pro všechna zaklínadla v této sekci:** Kde je v zaklínadle volitelný parametr „z“ (resp. „-z“), tento parametr funguje jako přepínač mezi formáty tsv a tsvz. Při použití formátu tsv tento přepínač vynechejte, při použití tsvz ho naopak vždy zařaďte.

### Vybrat/spojit sloupce

*# vzít/vynechat určité sloupce*<br>
*// Specifikace sloupců specifikuje množinu (tzn. ne výčet) sloupců. Má tvar jednotlivých čísel oddělených čárkami, např. „7,3,2,5,2“ vypíše sloupce 2, 3, 5 a 7. Místo jednotlivého čísla lze zadat rozsah ve tvaru „číslo-číslo“, „číslo-“ nebo „-číslo“, který se rozvine na všechny odpovídající sloupce, takže např. specifikace „7,3-5,-4“ odpovídá sloupcům 1, 2, 3, 4, 5 a 7.*<br>
**cut** [**-z**] <nic>[**-d** {*oddělovač*}] **-f** {*specifikace,sloupců*} [{*soubor*}]...
**cut \-\-complement** [**-z**] <nic>[**-d** {*oddělovač*}] **-f** {*specifikace,sloupců*} [{*soubor*}]...<br>

*# vzít určité sloupce (bez omezení)*<br>
*// Pro čtení ze standarního vstupu zadejte místo souboru „-“.*<br>
**join** [**-z**] **\-\-nocheck-order -j 1 -a 2 -t $'\\t' -o 2.**{*číslo-prvního-sloupce*}[**,2.**{*číslo-dalšího-sloupce*}]... **/dev/null** {*soubor*}

*# spojit sloupce ze dvou či více souborů podle čísla záznamu*<br>
**paste** [**-z**] <nic>[**-d** {*oddělovač*}] {*soubor1*} {*soubor2*} [{*další-soubor*}]...

*# spojit sloupce ze dvou souborů podle společného sloupce (komplikované)*<br>
*// Chování příkazu „join“ je smysluplné, ale poměrně komplikované. Před použitím tohoto zaklínadla prosím nastudujte manuálovou stránku příkazu join!*<br>
[**LC\_ALL=C**] **join** [**-z**] <nic>[{*další parametry*}] **-t $'\\t' -1** {*číslo-sloupce-v-prvním-souboru*} **-2** {*číslo-sloupce-v-druhém-souboru*} [**-a 1**] <nic>[**-a 2**] <nic>[**-o** {*definice-výstupu*}] {*soubor1*} {*soubor2*}

### Filtrace podle obsahu sloupců

Pro tsvz uveďte část „;RS=ORS="\\0";“.

*# vzít/vynechat záznamy, kde N-tý sloupec odpovídá **regulárnímu výrazu***<br>
**gawk 'BEGIN {FS=OFS="\\t"**[**;RS=ORS="\\0";**]**\} $**{*N*} **~ /**{*regulární výraz*}**/'** [{*soubor*}]...<br>
**gawk 'BEGIN {FS=OFS="\\t"**[**;RS=ORS="\\0";**]**\} $**{*N*} **!~ /**{*regulární výraz*}**/'** [{*soubor*}]...

*# vzít/vynechat záznamy, kde N-tý sloupec obsahuje **podřetězec***<br>
**gawk 'BEGIN {FS=OFS="\\t"**[**;RS=ORS="\\0";**]**\} index($**{*N*}**, "**{*podřetězec*}**")'** [{*soubor*}]...<br>
**gawk 'BEGIN {FS=OFS="\\t"**[**;RS=ORS="\\0";**]**\} !index($**{*N*}**, "**{*podřetězec*}**")'** [{*soubor*}]...

*# vzít/vynechat záznamy, kde N-tý sloupec je **řetězec***<br>
**gawk 'BEGIN {FS=OFS="\\t"**[**;RS=ORS="\\0";**]**\} $**{*N*}** == "**{*podřetězec*}**"'** [{*soubor*}]...<br>
**gawk 'BEGIN {FS=OFS="\\t"**[**;RS=ORS="\\0";**]**\} $**{*N*}** != "**{*podřetězec*}**"'** [{*soubor*}]...

<!--
**egrep '^([<nic>^\t]\t)\{{*N-1*}\}[<nic>^\t]\***{*regulární výraz*}**'**
-->

### Řazení záznamů podle obsahu sloupců

*# seřadit podle N-tého sloupce*<br>
[**LC\_ALL=C**] **sort** [**-z**] **-t $'\\t' -k** {*N*}**,**{*N*}[{*druh-a-příznaky-řazení*}] <nic>[{*soubor*}]...

*# seřadit podle sloupců M až N*<br>
[**LC\_ALL=C**] **sort** [**-z**] **-t $'\\t' -k** {*M*}**,**{*N*}[{*druh-a-příznaky-řazení*}] <nic>[{*soubor*}]...

*# seřadit podle více kritérií*<br>
[**LC\_ALL=C**] **sort** [**-z**] <nic>[**-s**] **-t $'\\t' -k** {*jedno-kritérium*} <nic>[**-k** {*další-kritérium*}]... [{*soubor*}]...

*# příklad: seřadit vzestupně podle číselné hodnoty 7. sloupce a pak sestupně podle 3. sloupce, bez ohledu na velikost písmen*<br>
**sort** [**-z**] **-t $'\\t' -k 7,7n -k 3,3ri** [{*soubor*}]...

<!--
Parametry řazení mohou být: bdfgiMhnRrV
-->

<!--
sort -t '\t' -k ''
-->

### Ostatní

Pro formát tsvz použijte „RS="\\0";“, pro tsv jej vynechejte.

*# **počet sloupců** prvního záznamu*<br>
**head** [**-z**] {*soubor*} **\| tr -cd \\\\t \| wc -c**

*# maximální počet sloupců (tsv/tsvz)*<br>
**gawk 'BEGIN {FS="\\t";** [**RS="\\0";**] **r=0;} NR == 1 \|\| NF &gt; r {r = NF} END {print r}'** [{*soubor*}]...

*# minimální počet sloupců*<br>
*// Poznámka: prázdný řádek se počítá jako 0 sloupců, proto pokud ho vstup obsahuje, výsledek bude 0.*<br>
**gawk 'BEGIN {FS="\\t";** [**RS="\\0";**] **r=0;} NR == 1 \|\| NF &lt; r {r = NF} END {print r}'** [{*soubor*}]...

*# naformátovat záznamy jako tabulku s pevnou šířkou sloupců (tsv/tsvz)*<br>
**column -nt**[**e**]**s** [{*soubor*}]...<br>
[**cat** {*soubor*}... **\|**] **tr '\\0\\n' '\\n&blank;' \| column -n**[**e**]**ts \| tr \\\\n \\\\0**

*# vložit sloupec s **číslem záznamu** před první sloupec*<br>
*// Poznámka: zadáte-li víc souborů, počítadlo záznamů se nebude restartovat na začátku každého z nich.*<br>
**gawk 'BEGIN {** [**RS = ORS = "\\0";**] **OFS = "\\t";} {print NR, $0}'** [{*soubor*}]...
<!--
**sed** [**-z**] **=** [{*soubor*}]... **\| paste** [**-z**] <nic>[**-d** {*oddělovač*}] **- -**
-->

*# vložit sloupec s **číslem záznamu** před N-tý sloupec, kde N není 1*<br>
**gawk** [**-v 'RS=\\0'**] **'{print gensub(/\\t/, "\\t" NR "\\t",** {*N*}** - 1);}'** [{*soubor*}]...


## Zaklínadla (pevná šířka sloupců)

### Vybrat/spojit sloupce

*# vzít určité sloupce (obecně/příklad)*<br>
?<br>
?

*# vynechat určité sloupce*<br>
**colrm** {*první-vynechaný*} [{*poslední-vynechaný*}] <nic>[**&lt;** {*soubor*}]

*# vynechat prvních/posledních deset znaků každého řádku*<br>
**colrm 1 10**<br>
**sed -E 's/.{,10}$//'**

### Filtrace podle obsahu sloupců

Pro tsvz uveďte část „BEGIN {RS=ORS="\\0"}“.

*# vzít/vynechat záznamy, jejichž podřetězec na indexech M až N odpovídá **regulárnímu výrazu***<br>
**gawk '**[**BEGIN {RS=ORS="\\0"}**] **substr($0,** {*M*}**,** {*N*} **-** {*M*} **+ 1) ~ /**{*regulární výraz*}**/'** [{*soubor*}]...<br>
**gawk '**[**BEGIN {RS=ORS="\\0"}**] **substr($0,** {*M*}**,** {*N*} **-** {*M*} **+ 1) !~ /**{*regulární výraz*}**/'** [{*soubor*}]...

*# vzít/vynechat záznamy, jejichž podřetězec na indexech M až N obsahuje **podřetězec***<br>
**gawk '**[**BEGIN {RS=ORS="\\0"}**] **index(substr($0,** {*M*}**,** {*N*} **-** {*M*} **+ 1), "**{*podřetězec*}**")'** [{*soubor*}]...<br>
**gawk '**[**BEGIN {RS=ORS="\\0"}**] **!index(substr($0,** {*M*}**,** {*N*} **-** {*M*} **+ 1), "**{*podřetězec*}**")'** [{*soubor*}]...

*# vzít/vynechat záznamy, jejichž podřetězec na indexech M až N je daný **řetězec***<br>
**gawk '**[**BEGIN {RS=ORS="\\0"}**] **substr($0,** {*M*}**,** {*N*} **-** {*M*} **+ 1) == "**{*řetězec*}**"'** [{*soubor*}]...<br>
**gawk '**[**BEGIN {RS=ORS="\\0"}**] **substr($0,** {*M*}**,** {*N*} **-** {*M*} **+ 1) != "**{*řetězec*}**"'** [{*soubor*}]...

### Řazení

*# řadit podle znaků na indexech M až N*<br>
[**LC\_ALL=C**] **sort** [{*další parametry*}] **-k 1.**{*M*}**,1.**{*N*}{*parametry-řazení*} [{*soubor*}]...

## Zaklínadla (psv)

### Filtrace záznamů podle pořadí

*# vzít/vynechat N **prvních***<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &gt;** {*N*} **{exit} {print}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &gt;** {*N*} **{print}'** [{*soubor*}]...

*# vzít/vynechat N **posledních***<br>
?<br>
?

*# vzít/vynechat **konkrétní** záznam*<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR ==** {*N*} **{print; exit;}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR !=** {*N*} **{print}'** [{*soubor*}]...

*# vzít/vynechat **rozsah** záznamů*<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &gt;=** {*první-ponechaný*} **{print} NR ==** {*poslední-ponechaný*} **{exit}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &lt;** {*první-vynechaný*} **\|\| NR &gt;** {*poslední-vynechaný*} **{print}'** [{*soubor*}]...

*# vzít pouze **liché/sudé** záznamy*<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR % 2 {print}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} !(NR % 2) {print}'** [{*soubor*}]...

### Vybrat/sloučit sloupce

*# vzít jen/vynechat určité sloupce*<br>
?<br>
?

*# sloučit záznamy ze dvou souborů podle čísla záznamu*<br>
?

*# sloučit záznamy ze dvou souborů podle společného sloupce*<br>
?

### Filtrace záznamů podle obsahu sloupců

Vzít/vynechat záznamy,...

*# které **obsahují určitý sloupec***<br>
?<br>
?

*# kde určitý sloupec odpovídá **regulárnímu výrazu***<br>
?<br>
?

*# kde určitý sloupec obsahuje **podřetězec***<br>
?<br>
?

*# kde určitý sloupec je **řetězec***<br>
?<br>
?

### Řazení a přeskládání záznamů

*# **obrátit** pořadí*<br>
**tac -rs $'\\n\\n\\n\*'**

*# **náhodně** přeskládat*<br>
?

*# seřadit podle určitého sloupce*<br>
?

*# seřadit podle více kritérií*<br>
?

### Ostatní

*# **počet záznamů***<br>
**tr '\\na' ab** [**&lt;** {*soubor*}] **\| fgrep -o aa \| wc -l**

*# **rozdělit** soubory na díly s uvedeným maximálním počtem záznamů*<br>
?

*# ke každému záznamu přidat sloupec*<br>
?

## Zaklínadla (záplatování)

*# vytvořit záplatu adresáře*<br>
*// Aby záplata fungovala, označení starého a nového adresáře nesmějí obsahovat žádná lomítka, musejí to být jen holá jména podadresářů aktuálního adresáře.*<br>
**diff -Nar -U 3** {*starý-adresář*} {*nový-adresář*} **&gt;** {*soubor.pdiff*} **\|\| test $? -eq 1**

*# aplikovat záplatu adresáře*<br>
**patch -N -p 1 -d** {*adresář*} **&lt;** {*soubor.pdiff*}

*# vytvořit záplatu souboru*<br>
**LC\_ALL=C TZ=UTC diff -Na -U 3** {*starý-soubor*} {*nový-soubor*} **&gt;** {*soubor.pdiff*} **\|\| test $? -eq 1**

*# aplikovat záplatu souboru*<br>
**patch -NZ**[**t**] {*cílový-soubor*} {*soubor.pdiff*}

## Parametry příkazů

### cut

*# *<br>
**cut** {*parametry*} [{*soubor*}]...

!parametry:

* ☐ -d {*oddělovač*} :: Nastaví oddělovač sloupců pro parametr -f; výchozí je "\\t", což znamená tabulátor. Používejte pouze znaky ASCII.
* ○ -f {*sloupce*} ○ -b {*bajty*} :: Definuje množinu sloupců či bajtů každého záznamu, které mají být propuštěny. Pozor, pořadí ani duplicity nemají vliv na výstup! Příklad specifikace: „7,13-15,-3,20-“
* ☐ --complement :: Neguje definovanou množinu − vybrané sloupce či bajty vypustí a vezme zbytek.
* ☐ -z :: Ukončovač záznamu je \\0 místo \\n.

### join

*# *<br>
[**LC\_ALL=C**] **join** {*parametry*} {*soubor1*} {*soubor2*}

!parametry:

* ○ -1 {*sloupec*} -2 {*sloupec*} ○ -j {*sloupec-pro-oba*} :: Určuje společný sloupec ve vstupních souborech.
* ☐ -t {*znak*} :: Definuje oddělovač sloupců. Prázdný argument značí, že se soubory na sloupce nedělí.
* ○ -a {*1-nebo-2*} ○ -v {*1-nebo-2*} :: Dovolí vypsání nespárovaných záznamů ze souboru 1 nebo 2. Varianta „-v“ navíc potlačí vypsání spárovaných záznamů.
* ☐ -o {*formát*} :: Definuje pořadí sloupců na výstupu. Jednotlivé specifikace mohou mít tvar „0“ (společný sloupec), „1.{*číslo*}“ pro sloupec prvního souboru nebo „2.{*číslo*}“ pro sloupec druhého souboru. Specifikace se oddělují čárkami nebo mezerami. Příklad specifikace: „0,1.1,1.2,2.1,2.2,0“.
* ☐ -z :: Ukončovač záznamu je \\0 místo \\n.
* ○ --check-order ○ --nocheck-order :: Zapne, resp. vypne kontrolu uspořádání vstupního souboru.

### paste

*# *<br>
**paste** [{*parametry*}] <nic>[{*soubor*}]...

!parametry:

* ☐ -d {*oddělovače*} :: Definuje znaky vkládané v místech spojení záznamů. Je-li předaný řetězec prázdný, použijí se prázdné řetězce, jinak se budou cyklicky používat jednotlivé znaky ze zadaného řetězce.
* ☐ -z :: Ukončovač záznamu je \\0 místo \\n.
* ☐ -s :: Ukončovače záznamu kromě posledního interpretuje jako oddělovače sloupců, tím pádem spojí všechny záznamy do jednoho.

### sed

*# *<br>
**sed** [{*parametry-kromě-e-či-f*}] {*skript-sedu*} [{*soubor*}]...<br>
**sed** {*parametry-včetně-e-či-f*} [{*soubor*}]...

!parametry:

* ☐ -E :: Použije rozšířené regulární výrazy místo základních (doporučuji vždy, když skript obsahuje regulární výraz).
* ☐ -n :: Potlačí automatické vypsání „pracovní paměti“ po každém cyklu skriptu.
* ☐ -z :: Ukončovač záznamu je \\0 místo \\n.
* ○ -e {*skript-sedu*} ○ -f {*soubor*} :: Načte skript z parametru, resp. ze souboru; oba parametry lze kombinovat či použít opakovaně.
* ☐ -u :: Načítá jen nezbytný počet bajtů a vypisuje na výstup co nejdřív.

### sort

*# *<br>
[**LC\_ALL=C**] **sort** [{*parametry*}] <nic>[{*soubor*}]...

!parametry:

* ☐ -u :: Po seřazení vyloučí duplicity (z každé skupiny duplicitních řádků ponechá pouze jeden).
* ○ -c ○ -C :: Neřadí; jen zkontroluje, zda je vstup seřazený. Varianta „-c“ navíc vypíše první chybně seřazený řádek.
* ☐ -k {*definice-řadicího-klíče*}{*druh-a-příznaky-řazení*} :: Definuje řadicí klíč, podle kterého se má řadit. Podrobněji − viz manuálová stránka příkazu *sort*.
* ☐ -t {*oddělovač*} :: Definuje oddělovač polí při řazení podle klíčů.
* ☐ -m :: Místo řazení pouze slučuje již seřazené soubory do jednoho.
* ☐ -s :: Stabilní řazení. Zachová relativní pořadí řádků, jejichž všechny řadicí klíče se rovnají.
* ○ -{*druh-řazení*} :: Přepne na jiný druh řazení než obyčejné řetězcové.
* ☐ -{*příznak-řazení*} :: Nastaví příslušný příznak ovlivňující řazení.

<neodsadit>Druhy řazení jsou: g, h, M, n, R, V. Za zmínku z nich stojí jen „n“ − řazení podle číselné hodnoty (včetně případných desetinných míst) a „h“ − totéž, ale s rozpoznáváním přípon K (kilo), M (mega) atd.

Příznaky řazení jsou tyto:

!parametry:

* r :: Řadit sestupně (normálně se řadí vzestupně).
* f :: Nerozlišovat velká a malá písmena.
* d :: „Řazení jako ve slovníku“ − zohledňovat jen písmena, čísla a bílé znaky.
* b :: Ignorovat bílé znaky na začátku klíče (při řazení podle číselné hodnoty se ignorují vždy).
* i :: Ignorovat netisknutelné znaky.

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu, s výjimkou gawk, které, pokud je potřebujete, je nutno doinstalovat:

*# *<br>
**sudo apt-get install gawk**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Nastavení „LC\_ALL=C“ zapíná řazení po bajtech podle jejich číselné hodnoty. Je rychlé, spolehlivé a dokonale přenositelné, nejde však o řazení pro člověka.
* Pozor, „sort -k 2“ znamená řadit podle sloupců 2, 3, 4 atd. až do konce; řazení podle sloupce číslo 2 je „sort -k 2,2“!
* Řazení podle klíčů může být pro začátečníka záludné. Doporučuji zvolený klíč nejprve otestovat na krátkém vstupním souboru s parametrem „\-\-debug“.


## Další zdroje informací

Nejlepším zdrojem podrobnějších informací o jednotlivých použitých příkazech (s výjimkou příkazu „column“) jsou jejich manuálové stránky.

* [Wikipedie: paste](https://cs.wikipedia.org/wiki/Paste)
* [Compute Hope o příkazu sort](https://www.computerhope.com/unix/usort.htm) (anglicky)
* [Linux column Command Tutorial for Beginners](https://www.howtoforge.com/linux-column-command/) (anglicky)
* [Linux Join Command Tutorial for Beginners](https://www.howtoforge.com/tutorial/linux-join-command/) (anglicky)
* [man 1 cut](http://manpages.ubuntu.com/manpages/bionic/en/man1/cut.1.html) (anglicky)
* [man 1 join](http://manpages.ubuntu.com/manpages/bionic/en/man1/join.1.html) (anglicky)
* [man 1 paste](http://manpages.ubuntu.com/manpages/bionic/en/man1/paste.1.html) (anglicky)
* [man 1 sort](http://manpages.ubuntu.com/manpages/bionic/en/man1/sort.1.html) (anglicky)
* [Balíček coreutils](https://packages.ubuntu.com/bionic/coreutils) (anglicky)
* [Video: Joining files and together with join](https://www.youtube.com/watch?v=TygQo1m\_sZo) (anglicky)
* [TL;DR cut](https://github.com/tldr-pages/tldr/blob/master/pages/common/cut.md) (anglicky)
* [TL;DR join](https://github.com/tldr-pages/tldr/blob/master/pages/common/join.md) (anglicky)
* [TL;DR paste](https://github.com/tldr-pages/tldr/blob/master/pages/common/paste.md) (anglicky)
* [TL;DR sed](https://github.com/tldr-pages/tldr/blob/master/pages/common/sed.md) (anglicky)
* [TL;DR shuf](https://github.com/tldr-pages/tldr/blob/master/pages/common/shuf.md) (anglicky)
* [TL;DR sort](https://github.com/tldr-pages/tldr/blob/master/pages/common/sort.md) (anglicky)

!ÚzkýRežim: vyp
