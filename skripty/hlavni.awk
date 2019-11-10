# Linux Kniha kouzel, skript hlavni.awk
# Copyright (c) 2019 Singularis <singularis@volny.cz>
#
# Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
# podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/licenses/by-sa/4.0/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA



# Tato funkce vezme řádek textu ve vstupním formátu (Markdown)
# a znak po znaku jej zkonvertuje do výstupního formátu.
# Používá se pro zpracování částí textu, které nepodporují formátování.
function ZpracujZnaky(text,     VSTUP, VYSTUP, ZNAK) {
    VSTUP = text;
    VYSTUP = "";

    while (VSTUP != "") {
        ZNAK = substr(VSTUP, 1, 1);
        if (ZNAK == "\\" && length(VSTUP) > 1) {
            VYSTUP = VYSTUP ZpracujZnak(substr(VSTUP, 2, 1));
            VSTUP = substr(VSTUP, 3);
        } else if (substr(VSTUP, 1, 7) == "&blank;") {
            VYSTUP = VYSTUP ZpracujZnak("␣");
            VSTUP = substr(VSTUP, 8);
        } else if (substr(VSTUP, 1, 4) == "&lt;") {
            VYSTUP = VYSTUP ZpracujZnak("<");
            VSTUP = substr(VSTUP, 5);
        } else if (substr(VSTUP, 1, 4) == "&gt;") {
            VYSTUP = VYSTUP ZpracujZnak(">");
            VSTUP = substr(VSTUP, 5);
        } else if (substr(VSTUP, 1, 5) == "&amp;") {
            VYSTUP = VYSTUP ZpracujZnak("&");
            VSTUP = substr(VSTUP, 6);
        } else if (substr(VSTUP, 1, 5) == "&apo;") {
            VYSTUP = VYSTUP ZpracujZnak("'");
            VSTUP = substr(VSTUP, 6);
        } else if (substr(VSTUP, 1, 6) == "&nbsp;") {
            VYSTUP = VYSTUP ZpracujZnak(" ");
            VSTUP = substr(VSTUP, 7);
        } else if (substr(VSTUP, 1, 6) == "&quot;") {
            VYSTUP = VYSTUP ZpracujZnak("\"");
            VSTUP = substr(VSTUP, 7);
        } else if (JeBilyZnak(ZNAK)) {
            VYSTUP = VYSTUP ZpracujBilyZnak(ZNAK, 0);
            while (VSTUP != "" && JeBilyZnak(C = substr(VSTUP = substr(VSTUP, 2), 1, 1))) {
                VYSTUP = VYSTUP ZpracujBilyZnak(C, 1);
            }
        } else {
            VYSTUP = VYSTUP ZpracujZnak(ZNAK);
            VSTUP = substr(VSTUP, 2);
        }
    }

    return VYSTUP;
}

# Tato funkce vezme řádek textu ve vstupním formátu a zpracuje všechno
# formátování na úrovni řádku. Výstupem je řádek ve výstupním formátu.
#
# Může využívat globálních proměnných TYP_RADKU a PREDCHOZI_TYP_RADKU.
# Lokálně používá zásobník "format".
function FormatovatRadek(text,   VSTUP, VYSTUP, i, j, C) {
    VSTUP = text;
    VYSTUP = "";
    VyprazdnitZasobnik("format");
    while (VSTUP != "") {
        # 11 znaků
        switch (C = substr(VSTUP, 1, 11)) {
            case "<neodsadit>":
                ShoditFatalniVyjimku("Značka <neodsadit> je dovolena jen na začátku prvního řádku nového odstavce!");
                continue;
            default:
                break;
        }
        # 7 znaků
        switch (C = substr(VSTUP, 1, 7)) {
            case "&blank;":
                VYSTUP = VYSTUP ZpracujZnak("␣");
                VSTUP = substr(VSTUP, 8);
                continue;
            default:
                break;
        }
        # 6 znaků
        switch (C = substr(VSTUP, 1, 6)) {
            case "&nbsp;":
                # nezlomitelná mezera se v této verzi nepovažuje za bílý znak
                VYSTUP = VYSTUP ZpracujZnak(" ");
                VSTUP = substr(VSTUP, 7);
                continue;
            case "&quot;":
                VYSTUP = VYSTUP ZpracujZnak("\"");
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab1>":
                VYSTUP = VYSTUP Tabulator(1);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab2>":
                VYSTUP = VYSTUP Tabulator(2);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab3>":
                VYSTUP = VYSTUP Tabulator(3);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab4>":
                VYSTUP = VYSTUP Tabulator(4);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab5>":
                VYSTUP = VYSTUP Tabulator(5);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab6>":
                VYSTUP = VYSTUP Tabulator(6);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab7>":
                VYSTUP = VYSTUP Tabulator(7);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab8>":
                VYSTUP = VYSTUP Tabulator(8);
                VSTUP = substr(VSTUP, 7);
                continue;
            default:
                break;
        }
        # 5 znaků
        switch (C = substr(VSTUP, 1, 5)) {
            case "&amp;":
                VYSTUP = VYSTUP ZpracujZnak("&");
                VSTUP = substr(VSTUP, 6);
                continue;
            case "&apo;":
                VYSTUP = VYSTUP ZpracujZnak("'");
                VSTUP = substr(VSTUP, 6);
                continue;
            case "<tab>":
                VYSTUP = VYSTUP Tabulator(8);
                VSTUP = substr(VSTUP, 6);
                continue;
            default:
                break;
        }
        # 4 znaky
        switch (C = substr(VSTUP, 1, 4)) {
            case "<br>":
                VYSTUP = VYSTUP KonecRadku();
                VSTUP = substr(VSTUP, 5);
                continue;
            case "&lt;":
                VYSTUP = VYSTUP ZpracujZnak("<");
                VSTUP = substr(VSTUP, 5);
                continue;
            case "&gt;":
                VYSTUP = VYSTUP ZpracujZnak(">");
                VSTUP = substr(VSTUP, 5);
                continue;
            default:
                break;
        }
        # 3 znaky
        switch (C = substr(VSTUP, 1, 3)) {
            case "...":
                if (TYP_RADKU == "RADEK_ZAKLINADLA" && VelikostZasobniku("format") == 0 && substr(VSTUP, 4, 1) != ".") {
                    VYSTUP = VYSTUP TriTecky();
                    VSTUP = substr(VSTUP, 4);
                    continue;
                }
                break;
            default:
                break;
        }
        # 2 znaky
        switch (C = substr(VSTUP, 1, 2)) {
            case "**":
                if (Vrchol("format") != "**") {
                    if (TYP_RADKU != "RADEK_ZAKLINADLA") {
                        VYSTUP = VYSTUP FormatTucne(1);
                    }
                    Push("format", "**");
                } else {
                    if (TYP_RADKU != "RADEK_ZAKLINADLA") {
                        VYSTUP = VYSTUP FormatTucne(0);
                    }
                    Pop("format");
                }
                VSTUP = substr(VSTUP, 3);
                continue;
            case "{*":
                if (VelikostZasobniku("format") != 0)
                    break;
                VYSTUP = VYSTUP FormatDopln(1);
                Push("format", "{*");
                VSTUP = substr(VSTUP, 3);
                continue;
            case "*}":
                if (VelikostZasobniku("format") != 1)
                    break;
                if (Pop("format") != "{*") {
                    ShoditFatalniVyjimku("Uzavřena neotevřená formátovací značka: {*..*}");
                }
                VYSTUP = VYSTUP FormatDopln(0);
                VSTUP = substr(VSTUP, 3);
                continue;
            case "$$":
                ShoditFatalniVyjimku("Funkce $$ není v této verzi podporována. Při opakování znaku $ musí být tyto znaky escapovány zpětným lomítkem.");
                break;
            case "--":
                ShoditFatalniVyjimku("Kombinace -- musí být ve zdrojovém kódu povinné escapovaná.");
                break;
            default:
                break;
        }
        # 1 znak
        switch (C = substr(VSTUP, 1, 1)) {
            case "\\":
                VYSTUP = VYSTUP ZpracujZnak(substr(VSTUP, 2, 1));
                VSTUP = substr(VSTUP, 3);
                continue;
            case "<":
                ShoditFatalniVyjimku("Nepovolený znak '<'. Musí být zakódován jako &lt;.");
                continue;
            case ">":
                ShoditFatalniVyjimku("Nepovolený znak '>'. Musí být zakódován jako &gt;.");
                continue;
            case "&":
                # Odlišné umístění závorek kvůli problémům se zvýrazněním syntaxe.
                if (match(VSTUP, /^&[0-9a-zA-Z#]{1,64};/))
                {
                    ShoditFatalniVyjimku("Nepovolená entita na řádku: '" substr($0, RSTART, RLENGTH) "'.");
                }
                else
                {
                    ShoditFatalniVyjimku("Nepovolený znak '&'. Musí být zakódován jako &amp;.");
                }
                continue;
            case "[":
                if (match(VSTUP, /^\[([^\]\\]|\\.)+\]\(([^)\\]|\\.)+\)/)) {
                    # j = délka celého výrazu; i = délka po dělící sekvenci „](“
                    j = RLENGTH;
                    match(VSTUP, /^\[([^\]\\]|\\.)+\]\(/);
                    i = RLENGTH - 1;
                    VYSTUP = VYSTUP HypertextovyOdkaz(ZpracujZnaky(substr(VSTUP, i + 2, j - i - 2)), ZpracujZnaky(substr(VSTUP, 2, i - 2)));
                    VSTUP = substr(VSTUP, j + 1);
                    continue;
                } else if (TYP_RADKU == "RADEK_ZAKLINADLA" && VelikostZasobniku("format") == 0) {
                    VYSTUP = VYSTUP FormatVolitelny(1);
                    VSTUP = substr(VSTUP, 2);
                    continue;
                }
                break;
            case "]":
                if (TYP_RADKU == "RADEK_ZAKLINADLA" && VelikostZasobniku("format") == 0) {
                    VYSTUP = VYSTUP FormatVolitelny(0);
                    VSTUP = substr(VSTUP, 2);
                    continue;
                }
                break;
            case "*":
                if (Vrchol("format") != "*") {
                    VYSTUP = VYSTUP FormatKurziva(1);
                    Push("format", "*");
                } else {
                    VYSTUP = VYSTUP FormatKurziva(0);
                    Pop("format");
                }
                VSTUP = substr(VSTUP, 2);
                continue;
            case "⫽":
                VYSTUP = VYSTUP ZpracujZnak("/") ZpracujZnak("/");
                VSTUP = substr(VSTUP, 2);
                continue;
            case "`":
            case "_":
                ShoditFatalniVyjimku("Neescapovaný znak " C "! Všechny výskyty tohoto znaku musejí být escapovány zpětným lomítkem.");
                continue;
            default:
                # Zpracování bílých znaků
                if (JeBilyZnak(C)) {
                    VYSTUP = VYSTUP ZpracujBilyZnak(C, 0);
                    while (VSTUP != "" && JeBilyZnak(C = substr(VSTUP = substr(VSTUP, 2), 1, 1))) {
                        VYSTUP = VYSTUP ZpracujBilyZnak(C, 1);
                    }
                    continue;
                }
                break;
    }
        VYSTUP = VYSTUP ZpracujZnak(C);
        VSTUP = substr(VSTUP, 2);
    }

    if (VelikostZasobniku("format") > 0) {
        ShoditFatalniVyjimku("Formátovací značka neuzavřena do konce řádku: " Vrchol("format") "\nVstup: <" text ">\nVýstup: <" VYSTUP ">\n\n");
    }
    return VYSTUP;
}

# Tato funkce se volá pro první ze sekvence řádků určitého typu.
function ZacitTypRadku(   bylPredel) {
    bylPredel = 0;
    if (TYP_RADKU != "PRAZDNY" && JE_ODSTAVEC_K_UKONCENI) {
        if (TYP_RADKU != "NORMALNI" || tolower(KAPITOLA) == "licence" || $0 ~ /^<neodsadit>/) {
            printf("%s", KonecOdstavcu());
        } else {
            printf("%s", PredelOdstavcu());
            bylPredel = 1;
        }
        JE_ODSTAVEC_K_UKONCENI = 0;
    }

    switch (TYP_RADKU) {
        case "NORMALNI":
            if (!bylPredel) {
# + dodatečné pravidlo: v kapitole „Licence“ se všechny začátky odstavců uvažují jako po nadpisu (vypne odsazení).
                printf("%s", ZacatekOdstavcu(PREDCHOZI_NEPRAZDNY_TYP_RADKU == "NADPIS" || tolower(KAPITOLA) == "licence" || $0 ~ /^<neodsadit>/));
            }
            if ($0 ~ /^<neodsadit>/) {
                $0 = substr($0, 12);
            }
            break;
        case "ODSAZENY_1":
        case "ODSAZENY_2":
        case "ODSAZENY_3":
        case "ODSAZENY_4":
        case "ODSAZENY_5":
        case "ODSAZENY_6":
            printf("%s", ZacatekOdsazenehoOdstavce(substr(TYP_RADKU, 10)));
            break;
        case "POLOZKA_SEZNAMU":
            if (PREDCHOZI_TYP_RADKU != "POKRACOVANI_POLOZKY_SEZNAMU") {
                printf("%s", ZacatekSeznamu(1, tolower(SEKCE) ~ /^(tipy a.zkušenosti|definice)/ || tolower(KAPITOLA) ~ /^(koncepce projektu)/));
                printf("%s", ZacatekPolozkySeznamu(1));
            }
            break;
        case "ZAKLINADLO":
            delete ppc;
            delete ppt;
        default:
            break;
    }
}

# Tato funkce se volá po posledním ze sekvence řádků určitého typu.
# Slouží k řádnému uzavření konstrukcí typu začátek-oddělovač-konec.
function UkoncitPredchoziTypRadku() {
    switch (PREDCHOZI_TYP_RADKU) {
        case "NORMALNI":
            JE_ODSTAVEC_K_UKONCENI = 1;
            return "";

        case "ODSAZENY_1":
        case "ODSAZENY_2":
        case "ODSAZENY_3":
        case "ODSAZENY_4":
        case "ODSAZENY_5":
        case "ODSAZENY_6":
            printf("%s", KonecOdsazenehoOdstavce(substr(PREDCHOZI_TYP_RADKU, 10)));
            break;

        case "POLOZKA_SEZNAMU":
            if (TYP_RADKU != "POKRACOVANI_POLOZKY_SEZNAMU") {
                printf("%s", KonecPolozkySeznamu(1));
                printf("%s", KonecSeznamu(1));
            }
            return "";

        case "POKRACOVANI_POLOZKY_SEZNAMU":
            printf("%s", KonecPolozkySeznamu(1));
            if (TYP_RADKU != "POLOZKA_SEZNAMU") {
                printf("%s", KonecSeznamu(1));
            } else {
                printf("%s", ZacatekPolozkySeznamu(1));
            }
            return "";

        case "POZNAMKA":
        case "ZAKLINADLO":
            if (JE_UVNITR_ZAKLINADLA && TYP_RADKU != "POZNAMKA" && TYP_RADKU != "RADEK_ZAKLINADLA") {
                VypsatZahlaviZaklinadla();
            }
            return "";

        case "RADEK_ZAKLINADLA":
            printf("%s", KonecZaklinadla());
            JE_UVNITR_ZAKLINADLA = 0;
            return "";

        default:
            return "";
    }
}

function VypsatZahlaviZaklinadla(   i, maPoznamky) {
    if (TYP_RADKU != "RADEK_ZAKLINADLA") {
        ShoditFatalniVyjimku("Zaklínadlo musí mít alespoň jeden řádek!");
    }
    if (TEXT_ZAKLINADLA != NULL_STRING) {
        if (TEXT_ZAKLINADLA != "") {
            printf("%s", ZacatekZaklinadla(++C_ZAKLINADLA, TEXT_ZAKLINADLA, ppc, ppt));
        } else {
            printf("%s", ZacatekZaklinadla(0, "", ppc, ppt));
        }
        TEXT_ZAKLINADLA = NULL_STRING;
        delete ppc;
        delete ppt;
    }
    return 0;
}

BEGIN {
    NULL_STRING = "\x01\x02";
    KAPITOLA = "";
    SEKCE = "";
    PODSEKCE = "";
    C_KAPITOLY = 0;
    C_SEKCE = 0;
    C_PODSEKCE = 0;
    C_ZAKLINADLA = 0;
    FATALNI_VYJIMKA = 0;
    PREDCHOZI_NEPRAZDNY_TYP_RADKU = "";
    PREDCHOZI_TYP_RADKU = "PRAZDNY";
    TYP_RADKU = "PRAZDNY";
    JE_UVNITR_ZAKLINADLA = 0;
    JE_UVNITR_KOMENTARE = 0;
    JE_ODSTAVEC_K_UKONCENI = 0;
    TEXT_ZAKLINADLA = NULL_STRING;
    split("", ppc);
    split("", ppt);
    split("", ppcall);
    split("", pptall);
}

# komentář započatý na samostatném řádku kompletně ignorovat
# (není to ideální řešení, ale dokonalejší řešení jsou problematická)
/^<!--$/,/^-->$/ {
    JE_UVNITR_KOMENTARE = ($0 != "-->");
    next;
}

{
    if (TYP_RADKU != "PRAZDNY") {
        PREDCHOZI_NEPRAZDNY_TYP_RADKU = TYP_RADKU;
    }
    PREDCHOZI_TYP_RADKU = TYP_RADKU;
    TYP_RADKU = "";
    ZPRACOVANO = 0;
}

#
# URČIT TYP ŘÁDKU (a zkontrolovat některé podmínky)
# ============================================================================

# zaznamenat prázdný řádek
/^$/ {
    TYP_RADKU = "PRAZDNY";
}

# vyloučit nepovolené bílé znaky na začátku/konci řádku
/^[ \t\v\r\n]+$/ {
    ShoditFatalniVyjimku("Řádek tvořený pouze bílými znaky není v tomto projektu dovolen!\nŘádek: <" $0 ">");
}
/[ \t\v\r\n]$/ {
    ShoditFatalniVyjimku("Bílé znaky na konci řádku nejsou v tomto projektu dovoleny!\nŘádek: <" $0 ">");
}
/^[ \t\v\r\n]/ {
    ShoditFatalniVyjimku("Bílé znaky na začátku řádku nejsou v tomto projektu dovoleny!\nŘádek: <" $0 ">");
}

# vypustit z řádku inline komentáře (popř. je zpracovat)
/<!--.*-->/ {
    while ((i = index($0, "<!--")) && (j = 4 + index(substr($0, i + 4), "-->"))) {
#        text_komentare = substr($0, i + 4, j - 5);
#        print "DEBUG: inline komentář <!--" text_komentare "-->.";

        $0 = substr($0, 1, i - 1) substr($0, i + j + 2);
    }
}

# určit typ řádku, nebyl-li již určen jako prázdný
{
    if (TYP_RADKU != "") {
        # typ řádku již byl určen
    } else if ($0 ~ /^#+ .+/) {
        TYP_RADKU = "NADPIS";
    } else if ($0 ~ /^>+ .+/) {
        UROVEN = index($0, " ") - 1;
        if (UROVEN > 6) {
            ShoditFatalniVyjimku("Příliš vysoká úroveň odsazení (víc než 6): " $0);
        }
        TYP_RADKU = "ODSAZENY_" UROVEN;
        $0 = substr($0, UROVEN + 2);
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^\* .+/) {
        TYP_RADKU = "POLOZKA_SEZNAMU";
        $0 = substr($0, 3);
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^\*# .*\*<br>$/) {
        TYP_RADKU = "ZAKLINADLO";
        JE_UVNITR_ZAKLINADLA = 1;
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^\*\/\/ .+\*(<br>)?$/) {
        TYP_RADKU = "POZNAMKA";
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^!\[.+\]\(.+\)$/) {
        TYP_RADKU = "OBRAZEK";
    } else if (JE_UVNITR_ZAKLINADLA) {
        TYP_RADKU = "RADEK_ZAKLINADLA";
    } else if (PREDCHOZI_TYP_RADKU == "POLOZKA_SEZNAMU" || PREDCHOZI_TYP_RADKU == "POKRACOVANI_POLOZKY_SEZNAMU") {
        TYP_RADKU = "POKRACOVANI_POLOZKY_SEZNAMU";
    } else {
        TYP_RADKU = "NORMALNI";
    }
#
# DEBUG:
#    printf("\n<TYP=%s>%s>", PREDCHOZI_TYP_RADKU, TYP_RADKU);
}

#
# Pokud se typ řádku změnil, ukončit ten předchozí a zahájit nový
# ============================================================================
PREDCHOZI_TYP_RADKU != TYP_RADKU {
    UkoncitPredchoziTypRadku();
    ZacitTypRadku();
}

#
# ZPRACOVÁNÍ JEDNOTLIVÝCH TYPŮ ŘÁDKŮ
# ============================================================================
TYP_RADKU == "NADPIS" {
    if (PODSEKCE != "")
        printf("%s", KonecPodsekce(KAPITOLA, SEKCE, PODSEKCE));
    if (SEKCE != "" && $0 ~ /^##? /)
        printf("%s", KonecSekce(KAPITOLA, SEKCE));
    if (KAPITOLA != "" && $0 ~ /^# /) {
        if (tolower(KAPITOLA) == "licence") {
            printf("%s", VypnoutRezimLicence());
        }
        printf("%s", KonecKapitoly(KAPITOLA, ppcall, pptall));
    }
    C_ZAKLINADLA = 0;
    if ($0 ~ /^# /) {
        KAPITOLA = ZpracujZnaky(substr($0, 3));
        SEKCE = "";
        PODSEKCE = "";
        C_SEKCE = 0;
        C_PODSEKCE = 0;
        delete ppcall;
        delete pptall;
        printf("%s", ZacatekKapitoly(KAPITOLA, ++C_KAPITOLY));
        if (tolower(KAPITOLA) == "licence") {
            printf("%s", ZapnoutRezimLicence());
        }
    } else if ($0 ~ /^## /) {
        SEKCE = ZpracujZnaky(substr($0, 4));
        PODSEKCE = "";
        C_PODSEKCE = 0;
        printf("%s", ZacatekSekce(KAPITOLA, SEKCE, C_KAPITOLY, ++C_SEKCE));
    } else {
        PODSEKCE = ZpracujZnaky(substr($0, 5));
        printf("%s", ZacatekPodsekce(KAPITOLA, SEKCE, PODSEKCE, C_KAPITOLY, C_SEKCE, ++C_PODSEKCE));
    }
    next;
}

TYP_RADKU == "OBRAZEK" {
    match($0, /\]\(/);
    alt = substr($0, 3, RSTART - 3);
    src = substr($0, RSTART + 2, length($0) - RSTART - 2);
    printf("%s", Obrazek(ZpracujZnaky(src), ZpracujZnaky(alt), src, alt));
    next;
}

TYP_RADKU == "NORMALNI" || TYP_RADKU ~ /^ODSAZENY_[123456]$/ {
    printf("%s\n", FormatovatRadek($0));
    next;
}

TYP_RADKU == "POLOZKA_SEZNAMU" {
    if (PREDCHOZI_TYP_RADKU == TYP_RADKU) {
        printf("%s", KonecPolozkySeznamu(1));
        printf("%s", ZacatekPolozkySeznamu(1));
    }
    printf("%s\n", FormatovatRadek($0));
    next;
}

TYP_RADKU == "POKRACOVANI_POLOZKY_SEZNAMU" {
    printf("%s\n", FormatovatRadek($0));
    next;
}

TYP_RADKU == "ZAKLINADLO" {
    if (PREDCHOZI_TYP_RADKU == "ZAKLINADLO") {
        ShoditFatalniVyjimku("Zaklínadlo nesmí následovat bezprostředně po předchozím zaklínadle. Vložte před něj prázdný řádek.");
    }
    if ($0 ~ /<br>$/) {
        $0 = substr($0, 1, length($0) - 4);
    }
    TEXT_ZAKLINADLA = FormatovatRadek(substr($0, 4, length($0) - 4));
    next;
}

TYP_RADKU == "POZNAMKA" {
    if ($0 ~ /<br>$/) {
        $0 = substr($0, 1, length($0) - 4);
    }
    if (!JE_UVNITR_ZAKLINADLA) {
        ShoditFatalniVyjimku("Poznámky jsou v této verzi podporovány pouze uvnitř zaklínadel.");
        #printf("%s", Poznamka(FormatovatRadek(substr($0, 5, length($0) - 5)), JE_UVNITR_ZAKLINADLA));
    } else {
        INDEX_POZNAMKY_POD_CAROU = length(ppcall);
        CISLO_POZNAMKY_POD_CAROU = INDEX_POZNAMKY_POD_CAROU + 1;
        TEXT_POZNAMKY_POD_CAROU = FormatovatRadek(substr($0, 5, length($0) - 5));
        ppc[length(ppc)] = CISLO_POZNAMKY_POD_CAROU;
        ppt[CISLO_POZNAMKY_POD_CAROU] = TEXT_POZNAMKY_POD_CAROU;
        ppcall[INDEX_POZNAMKY_POD_CAROU] = CISLO_POZNAMKY_POD_CAROU;
        pptall[CISLO_POZNAMKY_POD_CAROU] = TEXT_POZNAMKY_POD_CAROU;
    }
    next;
}

TYP_RADKU == "RADEK_ZAKLINADLA" {
    if ($0 ~ /<br>$/) {
        $0 = substr($0, 1, length($0) - 4);
    }
    VypsatZahlaviZaklinadla();
    jeAkce = (match($0, /^!: ?/) != 0);
    if (!jeAkce) {
        printf("%s", RadekZaklinadla(FormatovatRadek($0), 0));
    } else {
        printf("%s", RadekZaklinadla(FormatovatRadek(substr($0, RLENGTH + 1)), 1));
    }
    next;
}

TYP_RADKU == "NEPRAZDNY" {
    next;
}

TYP_RADKU == "PRAZDNY" {
    next;
}

# Pokud nebyl daný typ řádku zpracován, pravděpodobně nebyl implementován,
# což je fatální chyba.
{
    ShoditFatalniVyjimku("Nezpracovany typ radku: " TYP_RADKU);
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }

    # Neukončený komentář?
    if (JE_UVNITR_KOMENTARE) {
        ShoditFatalniVyjimku("Komentář otevřený samostatným řádkem \"<!--\" musí být ukončený v rámci téhož zdrojového souboru samostatným řádkem \"-->\".");
    }

    # Řádně ukončit poslední otevřený typ řádku.
    if (TYP_RADKU != "") {
        PREDCHOZI_TYP_RADKU = TYP_RADKU;
        TYP_RADKU = "PRAZDNY";
        UkoncitPredchoziTypRadku();
        if (JE_ODSTAVEC_K_UKONCENI) {
            printf("%s", KonecOdstavcu());
        }
    }

    # Řádně ukončit kapitolu, je-li otevřena.
    if (PODSEKCE != "")
        printf("%s", KonecPodsekce(KAPITOLA, SEKCE, PODSEKCE));
    if (SEKCE != "")
        printf("%s", KonecSekce(KAPITOLA, SEKCE));
    if (KAPITOLA != "") {
        if (tolower(KAPITOLA) == "licence") {
            printf("%s", VypnoutRezimLicence());
        }
        printf("%s", KonecKapitoly(KAPITOLA, ppcall, pptall));
    }
}
