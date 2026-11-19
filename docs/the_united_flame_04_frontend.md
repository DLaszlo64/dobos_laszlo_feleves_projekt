# VIZSGAREMEK / PROJEKTDOLGOZAT – FRONTEND ARCHITEKTÚRA ÉS FELHASZNÁLÓI FELÜLET

| Dokumentum adatok | Részletek |
| :--- | :--- |
| **Projekt hivatalos címe** | **The United Flame** – E-sport Verseny- és Csapatkezelő Webalkalmazás |
| **Dokumentum típusa** | 4. Rész: Frontend Architektúra és Felhasználói Felület (UI/UX) |
| **Készítő diák neve** | [Dobos László & Szalka László György] |
| **Képzés / Szakma** | 13. évfolyam – Szoftverfejlesztő és -tesztelő technikus |
| **Oktatási Intézmény** | [Hengersor] |
| **Konzulens tanár** | [Bencze István] |
| **Készítés** | 2026. november 17. |
| **GitHub Repository** | `git@github.com:DLaszlo64/MesterMunka.git` |

---

## 1. Technológiai elemzés: React.js előnyei

A **The United Flame** kliensoldali felületének megvalósításához a **React.js** könyvtárat választottuk az alábbi technológiai előnyök miatt:

* **Komponens-alapú felépítés:** Az UI független, újrahasznosítható építőelemekre (pl. `CsapatKartya`, `VersenyTablazat`, `NavBar`) bontható. Ez csökkenti a kódduplikációt, átláthatóvá teszi a fejlesztést, és megkönnyíti a karbantartást.
* **Virtuális DOM (Virtual DOM):** A React a memóriában tartja a DOM könnyűsúlyú másolatát. Amikor élő eredmények vagy ranglisták frissülnek, a React kiszámítja a minimális különbségeket (diffing), és csak a ténylegesen megváltozott HTML elemeket rajzolja újra, ami rendkívül gyors megjelenítést eredményez.
* **Kliensoldali routing (React Router):** A platform Single Page Application (SPA) működésű. Az oldalak közötti váltás (pl. Főoldal $\rightarrow$ Csapatok $\rightarrow$ Profil) teljes oldalújratöltés nélkül, azonnal történik, natív alkalmazás-élményt nyújtva.

---

## 2. Állapotkezelési stratégia és adatáramlás

Az alkalmazásban egyirányú adatáramlást (One-Way Data Flow) alkalmazunk, kombinálva a lokális és globális állapotkezelést:

* **Lokális komponensállapot (`useState`):** Az űrlapmezők értékeinek (`nev`, `tag`, `jatek`), a szűrőfeltételeknek, valamint a modális ablakok nyitott/zárt állapotának tárolására szolgál.
* **Mellékhatások és API hívások (`useEffect`):** A komponensek betöltődésekor (mount) vagy szűrőváltozáskor indítja el az aszinkron `fetch`/`axios` kéréseket a REST API felé, és frissíti a megjelenítendő listákat.
* **Globális kontextus (`useContext`):** Az `AuthContext` tárolja a bejelentkezett felhasználó adatait, szerepkörét (`jatekos`, `kapitany`, `admin`) és a JWT tokent, így az alkalmazás bármely pontjáról elérhető a jogosultság-ellenőrzéshez (pl. védett útvonalak – `ProtectedRoute`).

---

## 3. Komponensfa hierarchia

```text
App (AuthProvider + BrowserRouter)
├── Layout
│   ├── Navbar (Navigáció, Bejelentkezés/Profil menü)
│   └── Footer (Copyright, közösségi linkek)
└── Routes (Oldalak)
    ├── HomePage (Irányítópult, kiemelt versenyek, élő meccsek)
    ├── TeamsPage (Csapatlista)
    │   ├── TeamFilterBar (Játék és név szerinti szűrés)
    │   └── TeamCard (Egyedi csapat kártya + részletek gomb)
    ├── CreateTeamPage [ProtectedRoute]
    │   └── TeamForm (Új csapat létrehozása + kliensoldali validáció)
    └── AdminDashboardPage [ProtectedRoute: Admin]
        └── ConfirmModal (Megerősítő ablak törléshez / jóváhagyáshoz)
```

---

## 4. UI Drótvázak (Wireframes)

### 4.1. Főoldal / Irányítópult (`HomePage`)

```text
+-----------------------------------------------------------------------+
| [LOGO: THE UNITED FLAME]   Kezdőlap | Csapatok | Versenyek   [Belépés]|
+-----------------------------------------------------------------------+
|  HERO BANNER: "Csatlakozz a lánghoz! Nevezz a következő kupára!"      |
|               [ Csapat alapítása ]   [ Versenyek böngészése ]         |
+-----------------------------------------------------------------------+
|  KIEMELT VERSENYEK                   |  TOP 3 CSAPAT (RANGLISTA)      |
|  +---------------------------------+ |  1. [FLG] Flame Guardians (1450)|
|  | TUF Winter Cup - CS2 (12/16)    | |  2. [PHX] Phoenix Rising (1320) |
|  | Kezdés: 2026.12.01. [Részletek]  | |  3. [VPR] Viper Squad (1280)    |
|  +---------------------------------+ |                                |
+-----------------------------------------------------------------------+
```

### 4.2. Összetett Adatlista szűréssel (`TeamsPage`)

```text
+-----------------------------------------------------------------------+
| [LOGO]  Kezdőlap | [Csapatok] | Versenyek            [Profil: @Bence] |
+-----------------------------------------------------------------------+
| SZŰRŐK: [ Keresés névre... ]  [ Játék: Minden v ]  [ + Új csapat ]    |
+-----------------------------------------------------------------------+
| +-------------------+  +-------------------+  +-------------------+   |
| | [FLG]             |  | [PHX]             |  | [NVA]             |   |
| | Flame Guardians   |  | Phoenix Rising    |  | Nova Esports      |   |
| | Játék: CS2        |  | Játék: Valorant   |  | Játék: LoL        |   |
| | Pont: 1450 ELO    |  | Pont: 1320 ELO    |  | Pont: 1190 ELO    |   |
| | [ Adatlap ]       |  | [ Adatlap ]       |  | [ Adatlap ]       |   |
| +-------------------+  +-------------------+  +-------------------+   |
+-----------------------------------------------------------------------+
```

### 4.3. Űrlap / Rögzítő nézet (`CreateTeamPage`)

```text
+-----------------------------------------------------------------------+
| [LOGO]  Kezdőlap | Csapatok | Versenyek              [Profil: @Bence] |
+-----------------------------------------------------------------------+
|                  +---------------------------------+                  |
|                  |      ÚJ E-SPORT CSAPAT          |                  |
|                  |                                 |                  |
|                  | Csapat neve:                    |                  |
|                  | [_____________________________] |                  |
|                  |                                 |                  |
|                  | Rövidítés (Tag, max 4 kar.):    |                  |
|                  | [______]                        |                  |
|                  |                                 |                  |
|                  | Fő játék kiválasztása:          |                  |
|                  | [ Counter-Strike 2          v ] |                  |
|                  |                                 |                  |
|                  | [ Mégse ]    [ Csapat mentése ] |                  |
|                  +---------------------------------+                  |
+-----------------------------------------------------------------------+
```

---

## 5. Vizuális visszajelzések (UX elemek)

A felhasználói élmény és a hibabiztos működés érdekében az alábbi vizuális visszajelzéseket terveztük meg:

* **Töltési állapotok (Loading Spinner / Skeleton):** Amíg az API válaszára várunk (`isLoading === true`), a rendszer egy animált töltőikont (spinner) vagy csontváz-kártyákat (skeleton UI) jelenít meg, megakadályozva a gombok többszöri megnyomását.
* **Hibaüzenetek és Toast értesítések:** Sikertelen API kérés (pl. foglalt csapatnév – `400 Bad Request`) esetén piros figyelmeztető sáv (`Alert Banner`) jelenik meg az űrlap felett a szervertől kapott pontos hibaüzenettel; sikeres mentésnél pedig zöld felugró értesítés (`Toast`) tájékoztatja a felhasználót.
* **Megerősítő modális dialógus (`ConfirmModal`):** Destruktív műveletek (pl. csapat törlése vagy játékos eltávolítása) előtt egy felugró ablak kér megerősítést (*"Biztosan törölni szeretnéd a csapatot? Ez a művelet nem vonható vissza!"*), megelőzve a véletlen adatvesztést.