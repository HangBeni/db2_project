# db2_project
Ez az adatbázis az Adatbázisok2 kurzusomra készült

Az init.plsql scriptel tudják inicializálni az adatbázist.
Környezet függő változók pl a fájl elején lévő sys jelszó és csatlakozás, 
én a [wnameless](https://registry.hub.docker.com/r/wnameless/oracle-xe-11g-r2) docker image-t használtam, amihez sys/oracle páros tartozik,
valamint az adatbázishoz készült egy Directory ovjektum, ennek elérési útját a megfelelő kódrészlet kikommentelésével lehet elérni.

A futtatás után a PL/SQL block run successfully mellett egy hiba üzenetet is kell látni, ami a címek megduplázását jelzi. Szándékosan van bent.

A hrphee_db.erd.json egy vizualizációs fájl, amihez én a vscode [ERD Editor](https://marketplace.visualstudio.com/items?itemName=dineug.vuerd-vscode) plugint használtam.

Az adatbázis leírását [Itt](https://docs.google.com/document/d/1Wv3DJ2b22wwwJUuxy2MGCxpFr99euPWg2we9XRWJ6Hs/edit?usp=sharing) találhatjátok
