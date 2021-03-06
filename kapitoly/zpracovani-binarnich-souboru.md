<!--

Linux Kniha kouzel, kapitola Zpracování binárních souborů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
-->

# Zpracování binárních souborů

!Štítky: {tematický okruh}{kontrolní součet}

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Kontrolní součty a heše

*# vypočítat hexidecimální haše souborů, každou hash na nový řádek (MD5/SHA1/SHA256/SHA512)*<br>
**md5sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ 8147f2a49ee708d9f7c20164cf48cfcf<br>
**sha1sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ c61d1871cf7d71f29e2cfeda9dd73abe18a8fb42<br>
**sha256sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ ea6c53b8ffae9d15408a14f1806e6813c4c92b32ee1e8fd05c39d76210755bb3<br>
**sha512sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ f7389d5b8264db3f0950a1e512dd00f335b0ec77db9b6d7e7b36905b31864ec3182fe0e70ae7458951396dfdadbe5f3e1a326af00f8212092b7f7530fb6d9b87

*# vypočítat/ověřit kontrolní součty (SHA256)*<br>
*// Analogicky můžete také použít příkazy „sha1sum“, „sha224sum“, „sha384sum“ a „sha512sum“. Existuje také obecný „shasum“.*<br>
**sha256sum** {*soubor*}... **&gt;** {*cílový-soubor.sha256*}<br>
**sha256sum** [**\-\-ignore-missing**] <nic>[**\-\-status**] **-c** {*soubor.sha256*}

*# vypočítat/ověřit kontrolní součty (MD5)*<br>
*// Heše souborů a jejich názvy (včetně cesty) se uloží do uvedeného souboru.*<br>
**md5sum** {*cesta*}... **&gt;** {*cílový-soubor.md5*}<br>
**md5sum** [**\-\-ignore-missing**] <nic>[**\-\-status**] **-c** {*soubor.md5*}

*# vypočítat heš CRC32 (hexadecimální/desítkovou)*<br>
*// Poznámka: Příkaz „crc32“ lze použít i s více soubory, ale v takovém případě vypisuje ke kontrolním součtům i názvy souborů bez odzvláštnění, což znamená, že nelze bezpečně zpracovat soubory jejichž cesta obsahuje znak konce řádku.*<br>
**crc32** {*soubor*}<br>
**printf %d\\n $(crc32 "**{*soubor*}**")**

*# vypočítat z jednoho souboru heše záznamů ukončených nulovým bajtem*<br>
?

### Vytváření souboru

*# vytvořit prázdný soubor*<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...

*# vytvořit soubor tvořený nulovými/jinými bajty*<br>
**head -c** {*velikost-P*} **/dev/zero &gt;** {*soubor*}
**head -c** {*velikost-P*} **/dev/zero \| tr \\\\0 \\\\**{*osmičková-hodnota*} **&gt;** {*soubor*}

*# pseudonáhodná data (libovolné bajty/bajty v určitém rozsahu)*<br>
**head -c** {*velikost-P*} **/dev/urandom &gt;** {*soubor*}<br>
**tr -cd '\\**{*osm.-min*}**-\\**{*osm.-max*}**' &lt; /dev/urandom \| head -c** {*velikost-P*} **&gt;** {*soubor*}

*# soubor s bajty 0 až 255*<br>
**printf %02x {0..255} \| xxd -r -p &gt;~/ram/bytes.dat**

### Spojování a dělení

*# spojit soubory*<br>
**cat** {*soubor*}... **&gt;**{*cíl*}

*# rozdělit soubor na díly po určitém počtu bajtů*<br>
?

*# rozdělit soubor na N přibližně stejně velkých dílů*<br>
?



### Kódování (base64, uuencode, xor)

*# zakódovat do/dekódovat z base64*<br>
**base64 -w 0** [{*soubor*}]<br>
**base64 -d** [{*soubor*}] **&gt;** {*cíl*}

*# zakódovat do/dekódovat z uuencode*<br>
**uuencode /dev/stdout &lt;** {*soubor*} **\| sed -n 'x;3,$p'**<br>
**sed $'1i\\\\\\nbegin 644 /dev/stdout\\n$a\\\\\\nend' temp.dat \| uudecode &gt;** {*cíl*}

*# symetrické kódování operátorem „xor“*<br>
?

### Srovnání souborů podle obsahu

*# jsou dva soubory po bajtech **shodné**?*<br>
**cmp** [**-s**] {*soubor*} {*soubor*}

*# jsou po bajtech shodné zadané úseky?*<br>
**cmp** [**-s**] **-n** {*bajtů-k-porovnání-P*} {*soubor1*} {*soubor2*} {*začátek1-P*} {*začátek2-P*}

*# který ze dvou souborů je větší?*<br>
*// Pokud příkaz uspěje, „soubor1“ je větší; jinak je nutno soubory otestovat ještě v opačném pořadí; pokud obě testování selžou, jsou soubory stejně velké.*<br>
**test $(stat -c %s "**{*soubor1*}**") -gt $(stat -c %s "**{*soubor2*}**")**

### Ostatní

*# zkrátit či prodloužit soubor na uvedenou velikost (obecně/příklady...)*<br>
*// Prodlužuje se nulovými bajty.*<br>
**truncate -s** {*velikost*} {*soubor*}...<br>
?

*# nastavit bajt na určité adrese*<br>
**printf %08x:%02x** {*adresa*} {*hodnota-bajtu*} **\| xxd -r -** {*soubor*}

*# vzít prvních N bajtů/kibibajtů/mebibajtů/gibibajtů*<br>
**head -c** {*N*} {*soubor*}<br>
**head -c** {*N*}**K** {*soubor*}<br>
**head -c** {*N*}**M** {*soubor*}<br>
**head -c** {*N*}**G** {*soubor*}

*# vzít prvních N bajtů/kilobajtů/megabajtů/gigabajtů*<br>
**head -c** {*N*} {*soubor*}<br>
**head -c** {*N*}**kB** {*soubor*}<br>
**head -c** {*N*}**MB** {*soubor*}<br>
**head -c** {*N*}**GB** {*soubor*}

*# vynechat prvních N bajtů/kibibajtů/mebibajtů/gibibajtů*<br>
**tail -c +**{*N+1*} {*soubor*}<br>
?<br>
?<br>
?
<!--
Problém: tail -c +1K přeskočí jen 1023 bajtů!
-->

*# vyjmout úsek bajtů*<br>
?

*# přepsat úsek bajtů v souboru*<br>
?

*# určit MIME typ souboru*<br>
**file** [**-b**] <nic>[**-L**] **\-\-mime-type** {*soubor*}...

*# určit typ souboru (zejména pro člověka*<br>
**file** {*soubor*}...

*# určit velikost souboru v bajtech (alternativy)*<br>
**wc -c** [{*soubor*}]...<br>
**stat -c %s** {*soubor*}

*# určit počet bajtů určité hodnoty v daném souboru*<br>
**tr -cd \\\\**{*osmičková-hodnota*} **&lt;**{*soubor*} **\| wc -c**

*# vypsat hexadecimálně (pro člověka)*<br>
**xxd** [**-c** {*bajtů-na-řádek*}] <nic>[**-g** {*bajtů-na-skupinu*}] <nic>[**-s** {*počáteční-adresa*}] <nic>[**-l** {*max-počet-bajtů*}] <nic>[**-u**] {*soubor*}

*# obrátit každou dvojici/čtveřici/osmici bajtů*<br>
**dd** [**if=**{*vstupní-soubor*}] <nic>[**of=**{*výstupní-soubor*}] **conv=swab**<br>
**xxd -e -g 4** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}<br>
**xxd -e -g 8** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}

*# obrátit po bajtech celý soubor*<br>
?

<!--
?
gawk -b 'BEGIN {RS="....";OFS=ORS="";} {print substr(RT, 4, 1), substr(RT, 3, 1), substr(RT, 2, 1), substr(RT, 1, 1), $0}'
-->

*# nahradit bajty jedné hodnoty bajty jiné hodnoty*<br>
**tr '\\**{*osm.-původní1*}[**\\**{*osm.původníx*}]...**' '\\**{*osm.-nová1*}[**\\**{*osm.-nováx*}]...**' &lt;** {*zdroj*} **&gt;** {*cíl*}



<!--

Délka je nezáporný počet bajtů, případně s násobící příponou „K“ (2^10), „M“ (2^20), „G“ (2^30), „T“ (2^40) či „P“ (2^50).

-->

### Záplatování

<!--
Možnosti:
- bsdiff (jen pro malé soubory)
- rdiff
- xdelta (selhala na zkušebním vstupu)
-->

*# vytvořit záplatu*<br>
**rdiff \-\- signature** {*původní-soubor*} **- \| rdiff** [**-s**] **\-\- delta -** {*nový-soubor*} **- \| gzip -9 &gt;**{*cíl-záplata.gz*}

*# aplikovat záplatu*<br>
**zcat** {*záplata.gz*} **\| rdiff** [**-s**] **\-\- patch** {*původní-soubor*} **- - &gt;**{*cíl-soubor*}


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### xxd

*# *<br>
**xxd**



## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [Článek na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* Oficiální stránku programu
* Oficiální dokumentaci
* [Manuálovou stránku](http://manpages.ubuntu.com/)
* [Balíček](https://packages.ubuntu.com/)
* Online referenční příručky
* Různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* Publikované knihy
* [Stránky TL;DR](https://github.com/tldr-pages/tldr/tree/master/pages/common)

!ÚzkýRežim: vyp
